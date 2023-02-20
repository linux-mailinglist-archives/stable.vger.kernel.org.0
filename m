Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA70D69CD05
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbjBTNpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbjBTNpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:45:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3B31DBB9
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:45:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E04EB80D44
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E9EC433D2;
        Mon, 20 Feb 2023 13:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900707;
        bh=n4PE0z9z72VznYfALnTqyAG7Gb7cx7fJnL51LaMUDN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ly7BiL5h9swkxyzaQFLHwJKyJ9UeunzBmDcsTOWxoejQXn4F4Z2VVdpBqQWyldaK+
         iDggO6J2do0ZFvYc6CUw7TCY3FmBk22d6yWyf5b695HpB6OowATUbUrE9qaIr08Gdv
         3ahABagZ5ayOAjOrmTV1Y1q38gBvkxhA/4WQGegE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Miko Larsson <mikoxyzzz@gmail.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 036/156] fbcon: Check font dimension limits
Date:   Mon, 20 Feb 2023 14:34:40 +0100
Message-Id: <20230220133603.913092361@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit 2b09d5d364986f724f17001ccfe4126b9b43a0be upstream.

blit_x and blit_y are u32, so fbcon currently cannot support fonts
larger than 32x32.

The 32x32 case also needs shifting an unsigned int, to properly set bit
31, otherwise we get "UBSAN: shift-out-of-bounds in fbcon_set_font",
as reported on:

http://lore.kernel.org/all/IA1PR07MB98308653E259A6F2CE94A4AFABCE9@IA1PR07MB9830.namprd07.prod.outlook.com
Kernel Branch: 6.2.0-rc5-next-20230124
Kernel config: https://drive.google.com/file/d/1F-LszDAizEEH0ZX0HcSR06v5q8FPl2Uv/view?usp=sharing
Reproducer: https://drive.google.com/file/d/1mP1jcLBY7vWCNM60OMf-ogw-urQRjNrm/view?usp=sharing

Reported-by: Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Fixes: 2d2699d98492 ("fbcon: font setting should check limitation of driver")
Cc: stable@vger.kernel.org
Tested-by: Miko Larsson <mikoxyzzz@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2497,9 +2497,12 @@ static int fbcon_set_font(struct vc_data
 	    h > FBCON_SWAP(info->var.rotate, info->var.yres, info->var.xres))
 		return -EINVAL;
 
+	if (font->width > 32 || font->height > 32)
+		return -EINVAL;
+
 	/* Make sure drawing engine can handle the font */
-	if (!(info->pixmap.blit_x & (1 << (font->width - 1))) ||
-	    !(info->pixmap.blit_y & (1 << (font->height - 1))))
+	if (!(info->pixmap.blit_x & BIT(font->width - 1)) ||
+	    !(info->pixmap.blit_y & BIT(font->height - 1)))
 		return -EINVAL;
 
 	/* Make sure driver can handle the font length */


