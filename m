Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F6251F9ED
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 12:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiEIKfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 06:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbiEIKee (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 06:34:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BE6270184
        for <stable@vger.kernel.org>; Mon,  9 May 2022 03:29:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0524DB810E8
        for <stable@vger.kernel.org>; Mon,  9 May 2022 10:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34843C385AB;
        Mon,  9 May 2022 10:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652092183;
        bh=vKFa5NLrGm/G6fu/tDI80dYSbf6351ZIMMGef5KpCdU=;
        h=Subject:To:Cc:From:Date:From;
        b=r8pYgUQMx81CZ+oBB1K/Bz25mKBwYTS3tnv1WUWDZSmTbimk4LZF4idPouyTfeRx8
         7mHu/rbaP/9WPyBNhA5teDBr+Y9cR6GxbBaLez9+trEwmsYEoWNzOb333rdt6uSrxM
         l4S+mrRuCVEDW9kE9juIhtKPINamG4pkXr4S4CUo=
Subject: FAILED: patch "[PATCH] iommu/dart: Add missing module owner to ops structure" failed to apply to 5.15-stable tree
To:     marcan@marcan.st, jroedel@suse.de, sven@svenpeter.dev
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 12:29:32 +0200
Message-ID: <1652092172181239@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2ac2fab52917ae82cbca97cf6e5d2993530257ed Mon Sep 17 00:00:00 2001
From: Hector Martin <marcan@marcan.st>
Date: Mon, 2 May 2022 18:22:38 +0900
Subject: [PATCH] iommu/dart: Add missing module owner to ops structure

This is required to make loading this as a module work.

Signed-off-by: Hector Martin <marcan@marcan.st>
Fixes: 46d1fb072e76 ("iommu/dart: Add DART iommu driver")
Reviewed-by: Sven Peter <sven@svenpeter.dev>
Link: https://lore.kernel.org/r/20220502092238.30486-1-marcan@marcan.st
Signed-off-by: Joerg Roedel <jroedel@suse.de>

diff --git a/drivers/iommu/apple-dart.c b/drivers/iommu/apple-dart.c
index 15b77f16cfa3..8af0242a90d9 100644
--- a/drivers/iommu/apple-dart.c
+++ b/drivers/iommu/apple-dart.c
@@ -773,6 +773,7 @@ static const struct iommu_ops apple_dart_iommu_ops = {
 	.get_resv_regions = apple_dart_get_resv_regions,
 	.put_resv_regions = generic_iommu_put_resv_regions,
 	.pgsize_bitmap = -1UL, /* Restricted during dart probe */
+	.owner = THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
 		.attach_dev	= apple_dart_attach_dev,
 		.detach_dev	= apple_dart_detach_dev,

