Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D35962147B
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbiKHOBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234930AbiKHOBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:01:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B4C682B1
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:01:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70B1461596
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:01:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C478C433C1;
        Tue,  8 Nov 2022 14:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916099;
        bh=P/dKi00nqYsKddUPWFkuhSbz9HUs8JGCLjgIgv6rD5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvaJmhSnM9vlDqqLJ64Gi92eQajobQ6/F9/zuDsx9IeS/fn+RnBkUmG4yal8UvSi6
         FNa6hfUHkWyrYyrH9Ur7AFQvC+dJFBVoGqKlUJdiaOwxGlUjU6EOR5it0GzB2b1rTg
         JiGn+U93QUUSG7qSZLGDpRBAxi0lPa+PyTdHPElc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/144] fbdev: stifb: Fall back to cfb_fillrect() on 32-bit HCRX cards
Date:   Tue,  8 Nov 2022 14:38:59 +0100
Message-Id: <20221108133347.887840063@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

[ Upstream commit 776d875fd4cbb3884860ea7f63c3958f02b0c80e ]

When the text console is scrolling text upwards it calls the fillrect()
function to empty the new line. The current implementation doesn't seem
to work correctly on HCRX cards in 32-bit mode and leave garbage in that
line instead. Fix it by falling back to standard cfb_fillrect() in that
case.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/stifb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/stifb.c b/drivers/video/fbdev/stifb.c
index 7753e586e65a..3feb6e40d56d 100644
--- a/drivers/video/fbdev/stifb.c
+++ b/drivers/video/fbdev/stifb.c
@@ -1055,7 +1055,8 @@ stifb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
 {
 	struct stifb_info *fb = container_of(info, struct stifb_info, info);
 
-	if (rect->rop != ROP_COPY)
+	if (rect->rop != ROP_COPY ||
+	    (fb->id == S9000_ID_HCRX && fb->info.var.bits_per_pixel == 32))
 		return cfb_fillrect(info, rect);
 
 	SETUP_HW(fb);
-- 
2.35.1



