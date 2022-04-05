Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E0C4F28EE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbiDEIXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237452AbiDEISC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:18:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05174B6D22;
        Tue,  5 Apr 2022 01:06:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3072FB81BB4;
        Tue,  5 Apr 2022 08:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7649CC385A1;
        Tue,  5 Apr 2022 08:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145977;
        bh=xeyGYelppQeBHEJBSkuf+yHBR61hNi8XFJnh6P8IiLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xaeyziYcyCyyl/iD0mX6jv6YjBcQ15uyt6G0CmoAm8Y+Ndhqz8qODSTLIII5dkR7x
         sG8PgPcwFgR9PzhMGOZcgO3F1ZIYwhQNYiuQebUFoZKPBdnz/za/XGr0i1qmalAWDB
         5wnPNIkdxvPd+27QKew6kTLqs3A9d9oQ6yCYmKyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ma=C3=ADra=20Canal?= <maira.canal@usp.br>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0599/1126] drm/amd/display: Remove vupdate_int_entry definition
Date:   Tue,  5 Apr 2022 09:22:26 +0200
Message-Id: <20220405070425.217246117@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Maíra Canal <maira.canal@usp.br>

[ Upstream commit 3679b8518cd213c25d555553ef212e233faf698c ]

Remove the vupdate_int_entry definition and utilization to avoid the
following warning by Clang:

drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:410:2:
warning: initializer overrides prior initialization of this subobject
[-Winitializer-overrides]
    vupdate_no_lock_int_entry(0),
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:280:39:
note: expanded from macro 'vupdate_no_lock_int_entry'
    [DC_IRQ_SOURCE_VUPDATE1 + reg_num] = {\
    ^~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:404:2:
note: previous initialization is here
    vupdate_int_entry(0),
    ^~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:269:39:
note: expanded from macro 'vupdate_int_entry'
    [DC_IRQ_SOURCE_VUPDATE1 + reg_num] = {\
    ^~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:411:2:
warning: initializer overrides prior initialization of this subobject
[-Winitializer-overrides]
    vupdate_no_lock_int_entry(1),
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:280:39:
note: expanded from macro 'vupdate_no_lock_int_entry'
    [DC_IRQ_SOURCE_VUPDATE1 + reg_num] = {\
    ^~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:405:2:
note: previous initialization is here
    vupdate_int_entry(1),
    ^~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:269:39:
note: expanded from macro 'vupdate_int_entry'
    [DC_IRQ_SOURCE_VUPDATE1 + reg_num] = {\
    ^~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:412:2:
warning: initializer overrides prior initialization of this subobject
[-Winitializer-overrides]
    vupdate_no_lock_int_entry(2),
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:280:39:
note: expanded from macro 'vupdate_no_lock_int_entry'
    [DC_IRQ_SOURCE_VUPDATE1 + reg_num] = {\
    ^~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:406:2:
note: previous initialization is here
    vupdate_int_entry(2),
    ^~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:269:39:
note: expanded from macro 'vupdate_int_entry'
    [DC_IRQ_SOURCE_VUPDATE1 + reg_num] = {\
    ^~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:413:2:
warning: initializer overrides prior initialization of this subobject
[-Winitializer-overrides]
    vupdate_no_lock_int_entry(3),
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:280:39:
note: expanded from macro 'vupdate_no_lock_int_entry'
    [DC_IRQ_SOURCE_VUPDATE1 + reg_num] = {\
    ^~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:407:2:
note: previous initialization is here
    vupdate_int_entry(3),
    ^~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:269:39:
note: expanded from macro 'vupdate_int_entry'
    [DC_IRQ_SOURCE_VUPDATE1 + reg_num] = {\
    ^~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:414:2:
warning: initializer overrides prior initialization of this subobject
[-Winitializer-overrides]
    vupdate_no_lock_int_entry(4),
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:280:39:
note: expanded from macro 'vupdate_no_lock_int_entry'
    [DC_IRQ_SOURCE_VUPDATE1 + reg_num] = {\
    ^~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:408:2:
note: previous initialization is here
    vupdate_int_entry(4),
    ^~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:269:39:
note: expanded from macro 'vupdate_int_entry'
    [DC_IRQ_SOURCE_VUPDATE1 + reg_num] = {\
    ^~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:415:2:
warning: initializer overrides prior initialization of this subobject
[-Winitializer-overrides]
    vupdate_no_lock_int_entry(5),
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:280:39:
note: expanded from macro 'vupdate_no_lock_int_entry'
    [DC_IRQ_SOURCE_VUPDATE1 + reg_num] = {\
    ^~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:409:2:
note: previous initialization is here
    vupdate_int_entry(5),
    ^~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn21/irq_service_dcn21.c:269:39:
note: expanded from macro 'vupdate_int_entry'
        [DC_IRQ_SOURCE_VUPDATE1 + reg_num] = {\
        ^~
6 warnings generated.

Fixes: 688f97ed3f5e ("drm/amd/display: Add vupdate_no_lock interrupts for DCN2.1")
Signed-off-by: Maíra Canal <maira.canal@usp.br>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/irq/dcn21/irq_service_dcn21.c   | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/irq/dcn21/irq_service_dcn21.c b/drivers/gpu/drm/amd/display/dc/irq/dcn21/irq_service_dcn21.c
index 0f15bcada4e9..717977aec6d0 100644
--- a/drivers/gpu/drm/amd/display/dc/irq/dcn21/irq_service_dcn21.c
+++ b/drivers/gpu/drm/amd/display/dc/irq/dcn21/irq_service_dcn21.c
@@ -265,14 +265,6 @@ static const struct irq_source_info_funcs vline0_irq_info_funcs = {
 		.funcs = &pflip_irq_info_funcs\
 	}
 
-#define vupdate_int_entry(reg_num)\
-	[DC_IRQ_SOURCE_VUPDATE1 + reg_num] = {\
-		IRQ_REG_ENTRY(OTG, reg_num,\
-			OTG_GLOBAL_SYNC_STATUS, VUPDATE_INT_EN,\
-			OTG_GLOBAL_SYNC_STATUS, VUPDATE_EVENT_CLEAR),\
-		.funcs = &vblank_irq_info_funcs\
-	}
-
 /* vupdate_no_lock_int_entry maps to DC_IRQ_SOURCE_VUPDATEx, to match semantic
  * of DCE's DC_IRQ_SOURCE_VUPDATEx.
  */
@@ -401,12 +393,6 @@ irq_source_info_dcn21[DAL_IRQ_SOURCES_NUMBER] = {
 	dc_underflow_int_entry(6),
 	[DC_IRQ_SOURCE_DMCU_SCP] = dummy_irq_entry(),
 	[DC_IRQ_SOURCE_VBIOS_SW] = dummy_irq_entry(),
-	vupdate_int_entry(0),
-	vupdate_int_entry(1),
-	vupdate_int_entry(2),
-	vupdate_int_entry(3),
-	vupdate_int_entry(4),
-	vupdate_int_entry(5),
 	vupdate_no_lock_int_entry(0),
 	vupdate_no_lock_int_entry(1),
 	vupdate_no_lock_int_entry(2),
-- 
2.34.1



