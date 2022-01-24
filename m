Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D50C49AA19
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1324084AbiAYDaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1319411AbiAYDIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 22:08:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93500C0FE698;
        Mon, 24 Jan 2022 13:44:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 596DFB811FB;
        Mon, 24 Jan 2022 21:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740D0C340E4;
        Mon, 24 Jan 2022 21:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060669;
        bh=jHBt4D2LHkfF9t7FKzh7y8T3seROGWJIg2IRNcojcvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ucyyQiGOdoiSgLTnPHBAKn6Jgualeyrd7DjNcaryeIkLqdUgucHF0yt4DzG1DWly4
         6INCzf4oLHUsnbxgTjP/2PjWGfXO9NCscTscSMeB07GMFEOtzrFSEzkH3XFfUtRMII
         Gp+dZOXAjDQaNa3LMGf2pKy3wgnOqntR3FSsKNy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 1025/1039] sch_api: Dont skip qdisc attach on ingress
Date:   Mon, 24 Jan 2022 19:46:54 +0100
Message-Id: <20220124184159.746106739@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

commit de2d807b294d3d2ce5e59043ae2634016765d076 upstream.

The attach callback of struct Qdisc_ops is used by only a few qdiscs:
mq, mqprio and htb. qdisc_graft() contains the following logic
(pseudocode):

    if (!qdisc->ops->attach) {
        if (ingress)
            do ingress stuff;
        else
            do egress stuff;
    }
    if (!ingress) {
        ...
        if (qdisc->ops->attach)
            qdisc->ops->attach(qdisc);
    } else {
        ...
    }

As we see, the attach callback is not called if the qdisc is being
attached to ingress (TC_H_INGRESS). That wasn't a problem for mq and
mqprio, since they contain a check that they are attached to TC_H_ROOT,
and they can't be attached to TC_H_INGRESS anyway.

However, the commit cited below added the attach callback to htb. It is
needed for the hardware offload, but in the non-offload mode it
simulates the "do egress stuff" part of the pseudocode above. The
problem is that when htb is attached to ingress, neither "do ingress
stuff" nor attach() is called. It results in an inconsistency, and the
following message is printed to dmesg:

unregister_netdevice: waiting for lo to become free. Usage count = 2

This commit addresses the issue by running "do ingress stuff" in the
ingress flow even in the attach callback is present, which is fine,
because attach isn't going to be called afterwards.

The bug was found by syzbot and reported by Eric.

Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reported-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1062,7 +1062,7 @@ static int qdisc_graft(struct net_device
 
 		qdisc_offload_graft_root(dev, new, old, extack);
 
-		if (new && new->ops->attach)
+		if (new && new->ops->attach && !ingress)
 			goto skip;
 
 		for (i = 0; i < num_q; i++) {


