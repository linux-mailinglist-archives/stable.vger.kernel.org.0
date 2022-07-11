Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE7356FA48
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiGKJPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbiGKJOu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:14:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830DF3CBEE;
        Mon, 11 Jul 2022 02:10:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C8B7611F1;
        Mon, 11 Jul 2022 09:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D735C341CE;
        Mon, 11 Jul 2022 09:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530641;
        bh=AiqScboVoKrl9NbfUrwOqZcc0KyBFSunSKXP2EyflOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qUVCBgqlo4XR0v4SXgM4Rw35J95q8PVXGVTZzrIYsPHj5mJTBK09saY8HHres9/wS
         EgqTYIPIuqS2cqAHhttJczO+fOS93rM6Phadu27uNG2RpxdUr9Cq2lJBNOSL6G1AoG
         9MFLH+voZ9pFQQFjVRdnNWqrXm8nFzeWPI7PtrQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guiling Deng <greens9@163.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 09/38] fbdev: fbmem: Fix logo center image dx issue
Date:   Mon, 11 Jul 2022 11:06:51 +0200
Message-Id: <20220711090539.003201795@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090538.722676354@linuxfoundation.org>
References: <20220711090538.722676354@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Guiling Deng <greens9@163.com>

commit 955f04766d4e6eb94bf3baa539e096808c74ebfb upstream.

Image.dx gets wrong value because of missing '()'.

If xres == logo->width and n == 1, image.dx = -16.

Signed-off-by: Guiling Deng <greens9@163.com>
Fixes: 3d8b1933eb1c ("fbdev: fbmem: add config option to center the bootup logo")
Cc: stable@vger.kernel.org # v5.0+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -512,7 +512,7 @@ static int fb_show_logo_line(struct fb_i
 
 		while (n && (n * (logo->width + 8) - 8 > xres))
 			--n;
-		image.dx = (xres - n * (logo->width + 8) - 8) / 2;
+		image.dx = (xres - (n * (logo->width + 8) - 8)) / 2;
 		image.dy = y ?: (yres - logo->height) / 2;
 	} else {
 		image.dx = 0;


