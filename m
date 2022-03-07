Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF2A4CF669
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237556AbiCGJgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237593AbiCGJgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:36:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59ACF66FAA;
        Mon,  7 Mar 2022 01:31:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54592611AE;
        Mon,  7 Mar 2022 09:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571F7C340E9;
        Mon,  7 Mar 2022 09:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645467;
        bh=21YY4NxrrfmPda0r7VTfoipztWCNAl+87mork/YF//A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hi/jOk6zozW9k1ii7PU9/WZmnZc5OkueblWEubXW4bF0tEwmD/2Vp9P9uH8jpEoDe
         h3TzCKkVJFDH+c08pzYCFXkRa1/vlw4ew6cNPB/EclHa7iy93glrtitkjwlmyhpyNO
         szZ9hUt7w4GQg39kds8qQUDxa6jm2m3ATHtYRxnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.10 040/105] xfrm: enforce validity of offload input flags
Date:   Mon,  7 Mar 2022 10:18:43 +0100
Message-Id: <20220307091645.315094498@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
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
@@ -506,6 +506,12 @@ struct xfrm_user_offload {
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
@@ -223,6 +223,9 @@ int xfrm_dev_state_add(struct net *net,
 	if (x->encap || x->tfcpad)
 		return -EINVAL;
 
+	if (xuo->flags & ~(XFRM_OFFLOAD_IPV6 | XFRM_OFFLOAD_INBOUND))
+		return -EINVAL;
+
 	dev = dev_get_by_index(net, xuo->ifindex);
 	if (!dev) {
 		if (!(xuo->flags & XFRM_OFFLOAD_INBOUND)) {
@@ -261,7 +264,8 @@ int xfrm_dev_state_add(struct net *net,
 	xso->dev = dev;
 	xso->real_dev = dev;
 	xso->num_exthdrs = 1;
-	xso->flags = xuo->flags;
+	/* Don't forward bit that is not implemented */
+	xso->flags = xuo->flags & ~XFRM_OFFLOAD_IPV6;
 
 	err = dev->xfrmdev_ops->xdo_dev_state_add(x);
 	if (err) {


