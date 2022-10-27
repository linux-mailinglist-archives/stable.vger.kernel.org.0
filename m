Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C07F160FDF2
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236804AbiJ0RAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236806AbiJ0RAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:00:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4B5A2852
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:00:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E893BB82717
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49554C433C1;
        Thu, 27 Oct 2022 17:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890040;
        bh=iBeqD2U8u/o1LFBzNgl8bPntYvGiDIAVwfGxdmaDc8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sgGT5NCVRRRu0A6qzD1GKBx04tbGnH0Q06E671pnB1AN+Nt2ZDf0KXSE0FoAnrirQ
         D7jSYh9QoVfRAOARciBFalc/hOG2x+Hn5aFayU0L/qd2Q8SXkp49tBFPxgZjZ353+B
         ElvFEUca/hd+RvQ3nznJMf5FugSlwHMVLf0ZObZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        =?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 64/94] drm/amd/display: Increase frame size limit for display_mode_vba_util_32.o
Date:   Thu, 27 Oct 2022 18:55:06 +0200
Message-Id: <20221027165059.744651675@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 8a70b2d89ea3f2dc1449f0634ca6befb41472f24 ]

Building 32-bit images may fail with the following error.

drivers/gpu/drm/amd/amdgpu/../display/dc/dml/dcn32/display_mode_vba_util_32.c:
	In function ‘dml32_UseMinimumDCFCLK’:
drivers/gpu/drm/amd/amdgpu/../display/dc/dml/dcn32/display_mode_vba_util_32.c:3142:1:
	error: the frame size of 1096 bytes is larger than 1024 bytes

This is seen when building i386:allmodconfig with any of the following
compilers.

	gcc (Debian 12.2.0-3) 12.2.0
	gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0

The problem is not seen if the compiler supports GCC_PLUGIN_LATENT_ENTROPY
because in that case CONFIG_FRAME_WARN is already set to 2048 even for
32-bit builds.

dml32_UseMinimumDCFCLK() was introduced with commit dda4fb85e433
("drm/amd/display: DML changes for DCN32/321"). It declares a large
number of local variables. Increase the frame size for the affected
file to 2048, similar to other files in the same directory, to enable
32-bit build tests with affected compilers.

Fixes: dda4fb85e433 ("drm/amd/display: DML changes for DCN32/321")
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reported-by: Łukasz Bartosik <ukaszb@google.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/Makefile b/drivers/gpu/drm/amd/display/dc/dml/Makefile
index cb81ed2fbd53..d0c6cf61c676 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml/Makefile
@@ -77,7 +77,7 @@ CFLAGS_$(AMDDALPATH)/dc/dml/dcn30/dcn30_fpu.o := $(dml_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml/dcn32/dcn32_fpu.o := $(dml_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml/dcn32/display_mode_vba_32.o := $(dml_ccflags) $(frame_warn_flag)
 CFLAGS_$(AMDDALPATH)/dc/dml/dcn32/display_rq_dlg_calc_32.o := $(dml_ccflags)
-CFLAGS_$(AMDDALPATH)/dc/dml/dcn32/display_mode_vba_util_32.o := $(dml_ccflags)
+CFLAGS_$(AMDDALPATH)/dc/dml/dcn32/display_mode_vba_util_32.o := $(dml_ccflags) $(frame_warn_flag)
 CFLAGS_$(AMDDALPATH)/dc/dml/dcn321/dcn321_fpu.o := $(dml_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml/dcn31/dcn31_fpu.o := $(dml_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml/dcn301/dcn301_fpu.o := $(dml_ccflags)
-- 
2.35.1



