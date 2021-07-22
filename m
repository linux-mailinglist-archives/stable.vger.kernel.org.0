Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0B43D28E8
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbhGVP77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:59:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233396AbhGVP6x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:58:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1EE1610CC;
        Thu, 22 Jul 2021 16:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971968;
        bh=bvQNfpQ830/h9p5eEFxitxbkDTvpV3Q2eq0TWFknLf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RqA33SLyDmyyZ9KSeOxFP+MLJkl9m75cTN+3jrzk2r6UMTlFYwYie3W84AgXaIMik
         ydThzr7JTqqvGBmaTwJ+joP3xNN4lEYR9riGvk9x/GRl0QtCxgBohbXuoBwLIz3zA6
         fNjjf4k2UUvtdMXPdyUYMXVlK+Vtn8/HW3Q6fIYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, wenxu <wenxu@ucloud.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 096/125] net/sched: act_ct: fix err check for nf_conntrack_confirm
Date:   Thu, 22 Jul 2021 18:31:27 +0200
Message-Id: <20210722155627.880666502@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

commit 8955b90c3cdad199137809aac8ccbbb585355913 upstream.

The confirm operation should be checked. If there are any failed,
the packet should be dropped like in ovs and netfilter.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ct.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1023,7 +1023,8 @@ do_nat:
 		/* This will take care of sending queued events
 		 * even if the connection is already confirmed.
 		 */
-		nf_conntrack_confirm(skb);
+		if (nf_conntrack_confirm(skb) != NF_ACCEPT)
+			goto drop;
 	}
 
 	if (!skip_add)


