Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FFF259A6F
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730161AbgIAP07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:26:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730156AbgIAP0y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:26:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC1A3206FA;
        Tue,  1 Sep 2020 15:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974014;
        bh=ZMkXKSTSBiaCcYZxiGbeuz15CQ86paK9AtdPbUfBVOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H9aCMG0YTKf2diHPOtWmgCtIHlPRrLAxw3GmqUFbW7SmP7GICx9gjAdYrlphilde5
         oMmz0Mxf/SJLVWI68mWRWf3o1HxA7qQvBZYKUlufkT23hmpsd138VINtl9qgtIkrf2
         7LR8FrId0C8VvuS7LZ0MHNsYEcUPa7YkVmjvo9q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alaa Hleihel <alaa@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 011/214] net/sched: act_ct: Fix skb double-free in tcf_ct_handle_fragments() error flow
Date:   Tue,  1 Sep 2020 17:08:11 +0200
Message-Id: <20200901150953.508117152@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alaa Hleihel <alaa@mellanox.com>

[ Upstream commit eda814b97dfb8d9f4808eb2f65af9bd3705c4cae ]

tcf_ct_handle_fragments() shouldn't free the skb when ip_defrag() call
fails. Otherwise, we will cause a double-free bug.
In such cases, just return the error to the caller.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -186,7 +186,7 @@ static int tcf_ct_handle_fragments(struc
 		memset(IP6CB(skb), 0, sizeof(struct inet6_skb_parm));
 		err = nf_ct_frag6_gather(net, skb, user);
 		if (err && err != -EINPROGRESS)
-			goto out_free;
+			return err;
 #else
 		err = -EOPNOTSUPP;
 		goto out_free;


