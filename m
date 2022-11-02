Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB4D6157C9
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiKBCi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiKBCi7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:38:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396E7AE7C
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:38:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D734FB82070
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA15CC433D7;
        Wed,  2 Nov 2022 02:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356735;
        bh=+hfvyKi5N180oQ54BjCvZNQRNkkZq+Rxdwv/dumIUwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lSY4DOLhXf0NMpawblASL3kzg+vr4Bz97uml9RONCQZ8T2W/NuYuUOfuaSGyo5HGy
         F8Y+PqJKLox78QUPtFjxxB9ULpNtsnwj7jNX5w8/l7P3X3aYxmXoiytDjE89IcMyRX
         pyXECaPL5rL9ueMGln0vZFTwGEejgvypXoJgWurE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Helge Deller <deller@gmx.de>
Subject: [PATCH 6.0 050/240] fbdev: stifb: Fall back to cfb_fillrect() on 32-bit HCRX cards
Date:   Wed,  2 Nov 2022 03:30:25 +0100
Message-Id: <20221102022112.532391799@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 776d875fd4cbb3884860ea7f63c3958f02b0c80e upstream.

When the text console is scrolling text upwards it calls the fillrect()
function to empty the new line. The current implementation doesn't seem
to work correctly on HCRX cards in 32-bit mode and leave garbage in that
line instead. Fix it by falling back to standard cfb_fillrect() in that
case.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/stifb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/stifb.c
+++ b/drivers/video/fbdev/stifb.c
@@ -1055,7 +1055,8 @@ stifb_fillrect(struct fb_info *info, con
 {
 	struct stifb_info *fb = container_of(info, struct stifb_info, info);
 
-	if (rect->rop != ROP_COPY)
+	if (rect->rop != ROP_COPY ||
+	    (fb->id == S9000_ID_HCRX && fb->info.var.bits_per_pixel == 32))
 		return cfb_fillrect(info, rect);
 
 	SETUP_HW(fb);


