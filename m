Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0CD8505329
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238274AbiDRMzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240281AbiDRMzC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:55:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCC722BE5;
        Mon, 18 Apr 2022 05:35:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7933E6118A;
        Mon, 18 Apr 2022 12:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89277C385A1;
        Mon, 18 Apr 2022 12:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285330;
        bh=resUGCgfDFyLK6Iu5p0IhwFZLP0ZHosQKFmc2IXJMqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hSbh7MHHQ/RqcQCHNBNa9RCBoFR7oUrxmUoyK6QWnYNEPKpvhL9Crle0+LopoM5KG
         PpIntdWXXO1NLi95P5p4tIbk4QRjAM0mkEbeX8sjXvl0eCDXyWYTuwLZ2rz1I+C3aI
         twRsPTQEEkhzpMUA1EoHbOiaxWP5N6MOSFK4ZugA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, George Shen <George.Shen@amd.com>,
        Alex Hung <alex.hung@amd.com>,
        Martin Leung <Martin.Leung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/189] drm/amd/display: Revert FEC check in validation
Date:   Mon, 18 Apr 2022 14:12:34 +0200
Message-Id: <20220418121205.065490608@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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

From: Martin Leung <Martin.Leung@amd.com>

[ Upstream commit b2075fce104b88b789c15ef1ed2b91dc94198e26 ]

why and how:
causes failure on install on certain machines

Reviewed-by: George Shen <George.Shen@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Martin Leung <Martin.Leung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 35a27fe48f66..b37c4d2e7a1e 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1377,10 +1377,6 @@ bool dc_validate_seamless_boot_timing(const struct dc *dc,
 	if (!link->link_enc->funcs->is_dig_enabled(link->link_enc))
 		return false;
 
-	/* Check for FEC status*/
-	if (link->link_enc->funcs->fec_is_active(link->link_enc))
-		return false;
-
 	enc_inst = link->link_enc->funcs->get_dig_frontend(link->link_enc);
 
 	if (enc_inst == ENGINE_ID_UNKNOWN)
-- 
2.35.1



