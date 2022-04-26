Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9AB250F857
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346692AbiDZJIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347931AbiDZJGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:06:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35451B9F07;
        Tue, 26 Apr 2022 01:47:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4DC860C42;
        Tue, 26 Apr 2022 08:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F26C385A0;
        Tue, 26 Apr 2022 08:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962852;
        bh=4sPhDbCQx1zPEz4C3yDJVaZMcs36wzOetBzsjQaMW1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XInRp8yAzZ2E74xNgHbGlaX3nj8zY6aqL7nhw+HJmBTFlBjF32miLELNWOJuzw/Fe
         VI46djLsfP1u4LJRX+sCDdNNWQn6Ez2GKOiAZ/v0TxAgVUnk+hM+LsC3coGJvHe19a
         XCOYguCQgn5VD67Ab8oQE8/9/YeS7Qy+//Lt9GoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 111/146] arm/xen: Fix some refcount leaks
Date:   Tue, 26 Apr 2022 10:21:46 +0200
Message-Id: <20220426081753.175577347@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 533bec143a4c32f7b2014a159d0f5376226e5b4d ]

The of_find_compatible_node() function returns a node pointer with
refcount incremented, We should use of_node_put() on it when done
Add the missing of_node_put() to release the refcount.

Fixes: 9b08aaa3199a ("ARM: XEN: Move xen_early_init() before efi_init()")
Fixes: b2371587fe0c ("arm/xen: Read extended regions from DT and init Xen resource")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Stefano Stabellini <stefano.stabellini@xilinx.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/xen/enlighten.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index ec5b082f3de6..07eb69f9e7df 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -337,12 +337,15 @@ int __init arch_xen_unpopulated_init(struct resource **res)
 
 	if (!nr_reg) {
 		pr_err("No extended regions are found\n");
+		of_node_put(np);
 		return -EINVAL;
 	}
 
 	regs = kcalloc(nr_reg, sizeof(*regs), GFP_KERNEL);
-	if (!regs)
+	if (!regs) {
+		of_node_put(np);
 		return -ENOMEM;
+	}
 
 	/*
 	 * Create resource from extended regions provided by the hypervisor to be
@@ -403,8 +406,8 @@ int __init arch_xen_unpopulated_init(struct resource **res)
 	*res = &xen_resource;
 
 err:
+	of_node_put(np);
 	kfree(regs);
-
 	return rc;
 }
 #endif
@@ -424,8 +427,10 @@ static void __init xen_dt_guest_init(void)
 
 	if (of_address_to_resource(xen_node, GRANT_TABLE_INDEX, &res)) {
 		pr_err("Xen grant table region is not found\n");
+		of_node_put(xen_node);
 		return;
 	}
+	of_node_put(xen_node);
 	xen_grant_frames = res.start;
 }
 
-- 
2.35.1



