Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22504CF4FA
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236659AbiCGJYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237059AbiCGJXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:23:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5325C6662A;
        Mon,  7 Mar 2022 01:21:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F080FB810C0;
        Mon,  7 Mar 2022 09:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6482AC340F6;
        Mon,  7 Mar 2022 09:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646644903;
        bh=zu22j3tHmE8fVI+T7JaCdg1E5egrF7AQyc/FiqQy8Qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSPn1nOc4013KRM2/+xI7OyHDS0DAMb2A8iZlf3wAo/M+ZtiJMfhrXdSYHAW833dg
         FczabSDWvFVyS7a4ngHrUiEh3l87zI6lKXDj3xpQdgWGTEFOOjQv6EaHlWzwDlGRb4
         cSCrDBSiK7WfkTxy8jQOtaw7UuZUnLuGFt+HclX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 4.14 17/42] xfrm: enforce validity of offload input flags
Date:   Mon,  7 Mar 2022 10:18:51 +0100
Message-Id: <20220307091636.652610016@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091636.146155347@linuxfoundation.org>
References: <20220307091636.146155347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

commit 7c76ecd9c99b6e9a771d813ab1aa7fa428b3ade1 upstream.

struct xfrm_user_offload has flags variable that received user input,
but kernel didn't check if valid bits were provided. It caused a situation
where not sanitized input was forwarded directly to the drivers.

For example, XFRM_OFFLOAD_IPV6 define that was exposed, was used by
strongswan, but not implemented in the kernel at all.

As a solution, check and sanitize input flags to forward
XFRM_OFFLOAD_INBOUND to the drivers.

Fixes: d77e38e612a0 ("xfrm: Add an IPsec hardware offloading API")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/xfrm.h |    6 ++++++
 net/xfrm/xfrm_device.c    |    6 +++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -501,6 +501,12 @@ struct xfrm_user_offload {
 	int				ifindex;
 	__u8				flags;
 };
+/* This flag was exposed without any kernel code that supporting it.
+ * Unfortunately, strongswan has the code that uses sets this flag,
+ * which makes impossible to reuse this bit.
+ *
+ * So leave it here to make sure that it won't be reused by mistake.
+ */
 #define XFRM_OFFLOAD_IPV6	1
 #define XFRM_OFFLOAD_INBOUND	2
 
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -69,6 +69,9 @@ int xfrm_dev_state_add(struct net *net,
 	if (x->encap || x->tfcpad || (x->props.flags & XFRM_STATE_ESN))
 		return 0;
 
+	if (xuo->flags & ~(XFRM_OFFLOAD_IPV6 | XFRM_OFFLOAD_INBOUND))
+		return -EINVAL;
+
 	dev = dev_get_by_index(net, xuo->ifindex);
 	if (!dev) {
 		if (!(xuo->flags & XFRM_OFFLOAD_INBOUND)) {
@@ -98,7 +101,8 @@ int xfrm_dev_state_add(struct net *net,
 
 	xso->dev = dev;
 	xso->num_exthdrs = 1;
-	xso->flags = xuo->flags;
+	/* Don't forward bit that is not implemented */
+	xso->flags = xuo->flags & ~XFRM_OFFLOAD_IPV6;
 
 	err = dev->xfrmdev_ops->xdo_dev_state_add(x);
 	if (err) {


