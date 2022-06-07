Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7332E5404AE
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345564AbiFGRSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345558AbiFGRSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:18:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5ED104CB2;
        Tue,  7 Jun 2022 10:18:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 086D7B8220C;
        Tue,  7 Jun 2022 17:18:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC44C34115;
        Tue,  7 Jun 2022 17:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622311;
        bh=buBy/BXcZHrR3ioQKVFI+gKvmytx70EnsyZQOSGJah0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=icVOQXieKRDTB/HmwenaG4lLwQJGl2uCZV+dOMAbZ7UEoCnxqVDX0MWZlwngS3aQj
         KITcCPrM7BtpxXlKIQXXWkKvgbJ37YP2tPfvCXP0kZLgnpkRZfIfIKdtClMxykNb8m
         RLaQW5wbsZUqjJHsm/1+DK3VdQorE7ocKP16CPXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 015/452] Fonts: Make font size unsigned in font_desc
Date:   Tue,  7 Jun 2022 18:57:52 +0200
Message-Id: <20220607164908.995512648@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

commit 7cb415003468d41aecd6877ae088c38f6c0fc174 upstream.

`width` and `height` are defined as unsigned in our UAPI font descriptor
`struct console_font`. Make them unsigned in our kernel font descriptor
`struct font_desc`, too.

Also, change the corresponding printk() format identifiers from `%d` to
`%u`, in sti_select_fbfont().

Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20201028105647.1210161-1-yepeilin.cs@gmail.com
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/console/sticore.c |    2 +-
 include/linux/font.h            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/video/console/sticore.c
+++ b/drivers/video/console/sticore.c
@@ -503,7 +503,7 @@ sti_select_fbfont(struct sti_cooked_rom
 	if (!fbfont)
 		return NULL;
 
-	pr_info("STI selected %dx%d framebuffer font %s for sticon\n",
+	pr_info("STI selected %ux%u framebuffer font %s for sticon\n",
 			fbfont->width, fbfont->height, fbfont->name);
 			
 	bpc = ((fbfont->width+7)/8) * fbfont->height; 
--- a/include/linux/font.h
+++ b/include/linux/font.h
@@ -16,7 +16,7 @@
 struct font_desc {
     int idx;
     const char *name;
-    int width, height;
+    unsigned int width, height;
     const void *data;
     int pref;
 };


