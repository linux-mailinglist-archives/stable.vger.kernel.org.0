Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341AE4C74AB
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238665AbiB1RqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:46:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239651AbiB1Ro1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:44:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C287F89CED;
        Mon, 28 Feb 2022 09:36:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBB1CB815BA;
        Mon, 28 Feb 2022 17:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488E9C340E7;
        Mon, 28 Feb 2022 17:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069803;
        bh=qbNNbykP+4sCWhIIBiMaTFZFir/tkMMCt9YxX/k7OtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YlC7KrOcweSBXlaI1z6rt+F8/ncnoxkeMjvRWK+VijeQWjNLCGN+5hMuj+OinZFug
         3pU3/RQxoQ1fxJ5GAuW+qWt378TmdEgpOc3mXw/iNbLdzJ0QdObBJaXPLfOvI7YwjE
         dlP+v5HpP9ayYQXS0Vc+QuO3mMDOlVPwlMR9rrwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 018/139] drm/amdgpu: disable MMHUB PG for Picasso
Date:   Mon, 28 Feb 2022 18:23:12 +0100
Message-Id: <20220228172349.779132467@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit f626dd0ff05043e5a7154770cc7cda66acee33a3 upstream.

MMHUB PG needs to be disabled for Picasso for stability reasons.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/soc15.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1273,8 +1273,11 @@ static int soc15_common_early_init(void
 				AMD_CG_SUPPORT_SDMA_LS |
 				AMD_CG_SUPPORT_VCN_MGCG;
 
+			/*
+			 * MMHUB PG needs to be disabled for Picasso for
+			 * stability reasons.
+			 */
 			adev->pg_flags = AMD_PG_SUPPORT_SDMA |
-				AMD_PG_SUPPORT_MMHUB |
 				AMD_PG_SUPPORT_VCN;
 		} else {
 			adev->cg_flags = AMD_CG_SUPPORT_GFX_MGCG |


