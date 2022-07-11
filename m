Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C634B56FD82
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbiGKJ4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234133AbiGKJ4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:56:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5BEB31C8;
        Mon, 11 Jul 2022 02:26:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0B2D61383;
        Mon, 11 Jul 2022 09:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4618C34115;
        Mon, 11 Jul 2022 09:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531593;
        bh=kIuWGbz5DEODWD0dV/0NoRWJI6rMTuCyhXGaKzuwQ3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ze9IgzQHF7HmQIp5pZzA7TPZd40t08pIsQPzUPoHMwUUiXLd/lCo+StSD8E5iKXwj
         TfSfePebUQ4SfIduEqF8ziPZqNzGBzfhYM0dkZfAitLfhhMLUlIEhquHUU1JTQHNS1
         kDRSAUmGjPl33I2bM/AZyZ0GIbveHdUwG/52BoL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 5.15 160/230] fbmem: Check virtual screen sizes in fb_set_var()
Date:   Mon, 11 Jul 2022 11:06:56 +0200
Message-Id: <20220711090608.599372121@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit 6c11df58fd1ac0aefcb3b227f72769272b939e56 upstream.

Verify that the fbdev or drm driver correctly adjusted the virtual
screen sizes. On failure report the failing driver and reject the screen
size change.

Signed-off-by: Helge Deller <deller@gmx.de>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbmem.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1020,6 +1020,16 @@ fb_set_var(struct fb_info *info, struct
 	if (ret)
 		return ret;
 
+	/* verify that virtual resolution >= physical resolution */
+	if (var->xres_virtual < var->xres ||
+	    var->yres_virtual < var->yres) {
+		pr_warn("WARNING: fbcon: Driver '%s' missed to adjust virtual screen size (%ux%u vs. %ux%u)\n",
+			info->fix.id,
+			var->xres_virtual, var->yres_virtual,
+			var->xres, var->yres);
+		return -EINVAL;
+	}
+
 	if ((var->activate & FB_ACTIVATE_MASK) != FB_ACTIVATE_NOW)
 		return 0;
 


