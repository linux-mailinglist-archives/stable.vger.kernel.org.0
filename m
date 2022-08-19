Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A58559A1A6
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350292AbiHSPtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349063AbiHSPsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:48:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0331F103C5D;
        Fri, 19 Aug 2022 08:47:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EDB061562;
        Fri, 19 Aug 2022 15:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57472C433C1;
        Fri, 19 Aug 2022 15:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924041;
        bh=aMXibCZSLinqlXttnoe/IdezM/SNv9RONsIb4svQWZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wAv1wN1f6CJRWZhTCAFDLOCVr+88GRnIvMtl9ZDaL0XM/NN0yhIWoLkWy39HaDFuk
         3vwkHgXVoQ55ttmXzU2BPUA6q4M8KjfFtKKZwnxA37qcguZGmzqSpAVxbI14F23uab
         UtGSulyrB9ml460aoe793YKefS/hYbUQUh8YE+Uo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 035/545] fbcon: Fix boundary checks for fbcon=vc:n1-n2 parameters
Date:   Fri, 19 Aug 2022 17:36:45 +0200
Message-Id: <20220819153830.782846349@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit cad564ca557f8d3bb3b1fa965d9a2b3f6490ec69 upstream.

The user may use the fbcon=vc:<n1>-<n2> option to tell fbcon to take
over the given range (n1...n2) of consoles. The value for n1 and n2
needs to be a positive number and up to (MAX_NR_CONSOLES - 1).
The given values were not fully checked against those boundaries yet.

To fix the issue, convert first_fb_vc and last_fb_vc to unsigned
integers and check them against the upper boundary, and make sure that
first_fb_vc is smaller than last_fb_vc.

Cc: stable@vger.kernel.org # v4.19+
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Helge Deller <deller@gmx.de>
Link: https://patchwork.freedesktop.org/patch/msgid/YpkYRMojilrtZIgM@p100
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -123,8 +123,8 @@ static int logo_lines;
    enums.  */
 static int logo_shown = FBCON_LOGO_CANSHOW;
 /* console mappings */
-static int first_fb_vc;
-static int last_fb_vc = MAX_NR_CONSOLES - 1;
+static unsigned int first_fb_vc;
+static unsigned int last_fb_vc = MAX_NR_CONSOLES - 1;
 static int fbcon_is_default = 1; 
 static int primary_device = -1;
 static int fbcon_has_console_bind;
@@ -472,10 +472,12 @@ static int __init fb_console_setup(char
 			options += 3;
 			if (*options)
 				first_fb_vc = simple_strtoul(options, &options, 10) - 1;
-			if (first_fb_vc < 0)
+			if (first_fb_vc >= MAX_NR_CONSOLES)
 				first_fb_vc = 0;
 			if (*options++ == '-')
 				last_fb_vc = simple_strtoul(options, &options, 10) - 1;
+			if (last_fb_vc < first_fb_vc || last_fb_vc >= MAX_NR_CONSOLES)
+				last_fb_vc = MAX_NR_CONSOLES - 1;
 			fbcon_is_default = 0; 
 			continue;
 		}


