Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC826AA56F
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 00:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbjCCXN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 18:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbjCCXN1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 18:13:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C201457F9;
        Fri,  3 Mar 2023 15:13:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 06E40CE229C;
        Fri,  3 Mar 2023 21:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230B3C433A0;
        Fri,  3 Mar 2023 21:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879971;
        bh=KNB/gvnf8eLD2actKsJ+PYpfMYMabWWqOluMYv7CS4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+ahD3qYj8nmFuGxZv72MVrDxHvOVNMETqVlCaQhCzYiGws0Zn4FZ37PYm3dRrain
         8THT6w7+a4+jJXu5YR5A85bL/YCyCrpQHZrcw2OxMoIap3sQeGKPy5Ez7E7mNOxq2E
         a5hhEFu/UoLllwfiQj8xQUgFhJTKausRW5653Zb6jNRPDAlVhvxJXp0KHnINzh8LKy
         NCHzuzhcm9z6rdJggTSVZ0YEayRmDfWb8hlQvo7dP6sn/lRiqafb7t5COAU7WACuZg
         CsgWksPsDSf160CiJZMEkS6FApufbgHCOJ4tkfj6wa63C0pXM0gOsaW4FC3M3AXpZq
         jisfWxdbJNLFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alper Nebi Yasak <alpernebiyasak@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 18/50] firmware: coreboot: framebuffer: Ignore reserved pixel color bits
Date:   Fri,  3 Mar 2023 16:44:59 -0500
Message-Id: <20230303214531.1450154-18-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214531.1450154-1-sashal@kernel.org>
References: <20230303214531.1450154-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alper Nebi Yasak <alpernebiyasak@gmail.com>

[ Upstream commit e6acaf25cba14661211bb72181c35dd13b24f5b3 ]

The coreboot framebuffer doesn't support transparency, its 'reserved'
bit field is merely padding for byte/word alignment of pixel colors [1].
When trying to match the framebuffer to a simplefb format, the kernel
driver unnecessarily requires the format's transparency bit field to
exactly match this padding, even if the former is zero-width.

Due to a coreboot bug [2] (fixed upstream), some boards misreport the
reserved field's size as equal to its position (0x18 for both on a
'Lick' Chromebook), and the driver fails to probe where it would have
otherwise worked fine with e.g. the a8r8g8b8 or x8r8g8b8 formats.

Remove the transparency comparison with reserved bits. When the
bits-per-pixel and other color components match, transparency will
already be in a subset of the reserved field. Not forcing it to match
reserved bits allows the driver to work on the boards which misreport
the reserved field. It also enables using simplefb formats that don't
have transparency bits, although this doesn't currently happen due to
format support and ordering in linux/platform_data/simplefb.h.

[1] https://review.coreboot.org/plugins/gitiles/coreboot/+/4.19/src/commonlib/include/commonlib/coreboot_tables.h#255
[2] https://review.coreboot.org/plugins/gitiles/coreboot/+/4.13/src/drivers/intel/fsp2_0/graphics.c#82

Signed-off-by: Alper Nebi Yasak <alpernebiyasak@gmail.com>
Link: https://lore.kernel.org/r/20230122190433.195941-1-alpernebiyasak@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/google/framebuffer-coreboot.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/firmware/google/framebuffer-coreboot.c b/drivers/firmware/google/framebuffer-coreboot.c
index c6dcc1ef93acf..c323a818805cc 100644
--- a/drivers/firmware/google/framebuffer-coreboot.c
+++ b/drivers/firmware/google/framebuffer-coreboot.c
@@ -43,9 +43,7 @@ static int framebuffer_probe(struct coreboot_device *dev)
 		    fb->green_mask_pos     == formats[i].green.offset &&
 		    fb->green_mask_size    == formats[i].green.length &&
 		    fb->blue_mask_pos      == formats[i].blue.offset &&
-		    fb->blue_mask_size     == formats[i].blue.length &&
-		    fb->reserved_mask_pos  == formats[i].transp.offset &&
-		    fb->reserved_mask_size == formats[i].transp.length)
+		    fb->blue_mask_size     == formats[i].blue.length)
 			pdata.format = formats[i].name;
 	}
 	if (!pdata.format)
-- 
2.39.2

