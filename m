Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69BD556FB4B
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbiGKJ2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbiGKJ1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:27:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DEB064E3C;
        Mon, 11 Jul 2022 02:15:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96E9F6127D;
        Mon, 11 Jul 2022 09:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A399AC34115;
        Mon, 11 Jul 2022 09:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530944;
        bh=o1OFCP3bO86cv1e3AyPnCsMYZPBo9rwY9+UU0tu8cX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tT/zscwPP4ho7JtnlrUGl8+9m/ZJjhjg/9QSgd/17gGMcqFm1kWJwECAqplQKpAdA
         Me2873d0117g2ZfMUR7kL/dc9DDYOZe1ebrJIL6OtX4HaC0ftaau2+i5qoZg9nnWnY
         r4z8YHxw2K6sEBFKK1/L4tA7V76CGpkWo2psOGzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guiling Deng <greens9@163.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.18 033/112] fbdev: fbmem: Fix logo center image dx issue
Date:   Mon, 11 Jul 2022 11:06:33 +0200
Message-Id: <20220711090550.508197556@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
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
@@ -510,7 +510,7 @@ static int fb_show_logo_line(struct fb_i
 
 		while (n && (n * (logo->width + 8) - 8 > xres))
 			--n;
-		image.dx = (xres - n * (logo->width + 8) - 8) / 2;
+		image.dx = (xres - (n * (logo->width + 8) - 8)) / 2;
 		image.dy = y ?: (yres - logo->height) / 2;
 	} else {
 		image.dx = 0;


