Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B0C35BF2D
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239546AbhDLJDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239824AbhDLJBZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:01:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B92DB61285;
        Mon, 12 Apr 2021 08:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217967;
        bh=SnwYnGka7j4RriaJYqaMrWjTNiuHrEOFGObR5dEbsDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tL0eSygj2hEvMRbMXq0XrLL6eOcaO0TLp6080a4lW2wrWRLiFEjQOmwrRX1K4houh
         4fZYF7aRzxflBl9+gThsjtIVxAT4waKWnZPis2sZy10c8nenLx7TghtroXaTLWrJ7w
         68puwDidjTSjrfcEkH4FIdrBawQj3U2G/x4bJxiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Konstantin Kharlamov <Hi-Angel@yandex.ru>,
        Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 023/210] drm/amdgpu/smu7: fix CAC setting on TOPAZ
Date:   Mon, 12 Apr 2021 10:38:48 +0200
Message-Id: <20210412084016.782455983@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit cdcc108a2aced5f9cbc45920e29bf49819e5477f upstream.

We need to enable MC CAC for mclk switching to work.

Fixes: d765129a719f ("drm/amd/pm: correct sclk/mclk dpm enablement")
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1561
Tested-by: Konstantin Kharlamov <Hi-Angel@yandex.ru>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -1224,7 +1224,8 @@ static int smu7_enable_sclk_mclk_dpm(str
 		    (hwmgr->chip_id == CHIP_POLARIS10) ||
 		    (hwmgr->chip_id == CHIP_POLARIS11) ||
 		    (hwmgr->chip_id == CHIP_POLARIS12) ||
-		    (hwmgr->chip_id == CHIP_TONGA))
+		    (hwmgr->chip_id == CHIP_TONGA) ||
+		    (hwmgr->chip_id == CHIP_TOPAZ))
 			PHM_WRITE_FIELD(hwmgr->device, MC_SEQ_CNTL_3, CAC_EN, 0x1);
 
 


