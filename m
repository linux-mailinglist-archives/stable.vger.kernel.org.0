Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30BB43CAA41
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243532AbhGOTMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:12:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243804AbhGOTKH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:10:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1D7361285;
        Thu, 15 Jul 2021 19:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376003;
        bh=V5xozR4nuZSnCU9y6noaDhHo7F8Fk/JOZVL7sZpw1Xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nNSmbQZ5LL55E/UMVqJqR3a6okz/SUnEo2un8ss90vwB5HB5ubC4mmRlzVzW37jtb
         gDJVAwriuxhxALCifVWWp6WMss4Fr0bjdh3bfQuVIfyd6D5ojPoBd2Ih64GQKY2QS3
         tOStY4e15zDQuX3ldHTKiDEhOT7BpsI71mcRlC6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wesley Chalmers <Wesley.Chalmers@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 086/266] drm/amd/display: Set DISPCLK_MAX_ERRDET_CYCLES to 7
Date:   Thu, 15 Jul 2021 20:37:21 +0200
Message-Id: <20210715182629.442143324@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Chalmers <Wesley.Chalmers@amd.com>

[ Upstream commit 3577e1678772ce3ede92af3a75b44a4b76f9b4ad ]

[WHY]
DISPCLK_MAX_ERRDET_CYCLES must be 7 to prevent connection loss when
changing DENTIST_DISPCLK_WDIVIDER from 126 to 127 and back.

Signed-off-by: Wesley Chalmers <Wesley.Chalmers@amd.com>
Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Stylon Wang <stylon.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 6a10daec15cc..793554e61c52 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -243,7 +243,7 @@ void dcn20_dccg_init(struct dce_hwseq *hws)
 	REG_WRITE(MILLISECOND_TIME_BASE_DIV, 0x1186a0);
 
 	/* This value is dependent on the hardware pipeline delay so set once per SOC */
-	REG_WRITE(DISPCLK_FREQ_CHANGE_CNTL, 0x801003c);
+	REG_WRITE(DISPCLK_FREQ_CHANGE_CNTL, 0xe01003c);
 }
 
 void dcn20_disable_vga(
-- 
2.30.2



