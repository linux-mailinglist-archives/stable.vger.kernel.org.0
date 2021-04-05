Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21A6354011
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238957AbhDEJPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:15:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240578AbhDEJPW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:15:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2099C61394;
        Mon,  5 Apr 2021 09:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614116;
        bh=B6MEdc2m4jaRJeHFmab24wSz6Pnm4f72YLpwiEZmLs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fhout3jJmUnt8Yh5bwNSIfJ9GEvhpWMwujwoFb2NY8K6G2abQzATCxWgU8k6w8mIz
         ZQu02ahRbli3/p3m5tA9gkygsW/ZT98/6HcOuOjdOCUXUyRK7ZB3Iky2q4Xk2ktZAl
         1JoaLwQsvwhMI0liiQ0oXVhVvspqUBSF5eUj1QnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 089/152] drm/amd/pm: no need to force MCLK to highest when no display connected
Date:   Mon,  5 Apr 2021 10:53:58 +0200
Message-Id: <20210405085037.143718916@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit acc7baafeb0b52a5b91be64c4776f827a163dda1 upstream.

Correct the check for vblank short.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Tested-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -3330,7 +3330,8 @@ static int smu7_apply_state_adjust_rules
 
 	disable_mclk_switching_for_display = ((1 < hwmgr->display_config->num_display) &&
 						!hwmgr->display_config->multi_monitor_in_sync) ||
-						smu7_vblank_too_short(hwmgr, hwmgr->display_config->min_vblank_time);
+						(hwmgr->display_config->num_display &&
+						smu7_vblank_too_short(hwmgr, hwmgr->display_config->min_vblank_time));
 
 	disable_mclk_switching = disable_mclk_switching_for_frame_lock ||
 					 disable_mclk_switching_for_display;


