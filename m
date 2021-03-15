Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165EE33B79E
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbhCOOAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232679AbhCON73 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 341EF64F06;
        Mon, 15 Mar 2021 13:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816747;
        bh=588BgDknMzbDHS7zPOgtnxq0+noLDSWDQe9Z1AjJ8w0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQpiQbNM/TvefCFvBomnVQQ3MHhkb13xThyenTiiXlBSNQ43PdRRvum5OyvwHu4dX
         3s3eh17HTko178vl7L0avd2pTdkqBb/4B7dr0hDHzfzm1mi9rc4mOmezA1wkJOFLUf
         YPGZvWBKWoMvzGDSBSniKsHepTSxw4b0U7Kk1KSY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Feifei Xu <Feifei.Xu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Georgios Toptsidis <gtoptsid@gmail.com>
Subject: [PATCH 5.11 100/306] drm/amd/pm: correct the watermark settings for Polaris
Date:   Mon, 15 Mar 2021 14:52:43 +0100
Message-Id: <20210315135511.029768060@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Evan Quan <evan.quan@amd.com>

commit 48123d068fcb584838ce29912660c5e9490bad0e upstream.

The "/ 10" should be applied to the right-hand operand instead of
the left-hand one.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Noticed-by: Georgios Toptsidis <gtoptsid@gmail.com>
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -5216,10 +5216,10 @@ static int smu7_set_watermarks_for_clock
 		for (j = 0; j < dep_sclk_table->count; j++) {
 			valid_entry = false;
 			for (k = 0; k < watermarks->num_wm_sets; k++) {
-				if (dep_sclk_table->entries[i].clk / 10 >= watermarks->wm_clk_ranges[k].wm_min_eng_clk_in_khz &&
-				    dep_sclk_table->entries[i].clk / 10 < watermarks->wm_clk_ranges[k].wm_max_eng_clk_in_khz &&
-				    dep_mclk_table->entries[i].clk / 10 >= watermarks->wm_clk_ranges[k].wm_min_mem_clk_in_khz &&
-				    dep_mclk_table->entries[i].clk / 10 < watermarks->wm_clk_ranges[k].wm_max_mem_clk_in_khz) {
+				if (dep_sclk_table->entries[i].clk >= watermarks->wm_clk_ranges[k].wm_min_eng_clk_in_khz / 10 &&
+				    dep_sclk_table->entries[i].clk < watermarks->wm_clk_ranges[k].wm_max_eng_clk_in_khz / 10 &&
+				    dep_mclk_table->entries[i].clk >= watermarks->wm_clk_ranges[k].wm_min_mem_clk_in_khz / 10 &&
+				    dep_mclk_table->entries[i].clk < watermarks->wm_clk_ranges[k].wm_max_mem_clk_in_khz / 10) {
 					valid_entry = true;
 					table->DisplayWatermark[i][j] = watermarks->wm_clk_ranges[k].wm_set_id;
 					break;


