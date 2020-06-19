Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C69F2012B2
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392510AbgFSPzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:55:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390633AbgFSPV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:21:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A91F20B80;
        Fri, 19 Jun 2020 15:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580088;
        bh=h1T8WN4lKVZU17Fkg6U+9UkbB+FzXtXp0Ckcu6/lPss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fzdc6GVr/+rR/3nVwnKWBZiM248AO/k3ZNZnkhsqB61i7duVhQzUBhVXO8Fz/6MZ/
         ZkjjlE0+pkMDM6wCkVBsKdS9/rUOW4XmGsLD+/KPJ2vjBlRxxBOvcGFl8kxUmyjPll
         k54zKHkwf2BNtUKOsFZKKlYuBs+xZrEQa8v4MzP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alvin Lee <alvin.lee2@amd.com>,
        Yongqiang Sun <yongqiang.sun@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 087/376] drm/amd/display: Revert to old formula in set_vtg_params
Date:   Fri, 19 Jun 2020 16:30:05 +0200
Message-Id: <20200619141714.460253808@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvin Lee <alvin.lee2@amd.com>

[ Upstream commit a1a0e61f3c43c610f0a3c109348c14ce930c1977 ]

[Why]
New formula + cursor change causing underflow
on certain configs

[How]
Rever to old formula

Signed-off-by: Alvin Lee <alvin.lee2@amd.com>
Reviewed-by: Yongqiang Sun <yongqiang.sun@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c
index 17d96ec6acd8..ec0ab42becba 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c
@@ -299,6 +299,7 @@ void optc1_set_vtg_params(struct timing_generator *optc,
 	uint32_t asic_blank_end;
 	uint32_t v_init;
 	uint32_t v_fp2 = 0;
+	int32_t vertical_line_start;
 
 	struct optc *optc1 = DCN10TG_FROM_TG(optc);
 
@@ -315,8 +316,9 @@ void optc1_set_vtg_params(struct timing_generator *optc,
 			patched_crtc_timing.v_border_top;
 
 	/* if VSTARTUP is before VSYNC, FP2 is the offset, otherwise 0 */
-	if (optc1->vstartup_start > asic_blank_end)
-		v_fp2 = optc1->vstartup_start - asic_blank_end;
+	vertical_line_start = asic_blank_end - optc1->vstartup_start + 1;
+	if (vertical_line_start < 0)
+		v_fp2 = -vertical_line_start;
 
 	/* Interlace */
 	if (REG(OTG_INTERLACE_CONTROL)) {
-- 
2.25.1



