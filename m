Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03211B0A6D
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729201AbgDTMsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:48:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728009AbgDTMsF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:48:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FD78206DD;
        Mon, 20 Apr 2020 12:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386884;
        bh=Eivq5juyMXA4AkvbRseQC8H4peMc7yxvOwgs/rLooDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JLCmvE9pklbDH+b+/CXvG5MlwdRCXxSdvE2Q2JYs1bXFKs+QjmHhucZHV4qPTC38k
         KoUXT1A03slDEAnrox/0PZXTve+1SH9+UNnFAVAHWSz4T+lWTQQXt7QHUUcdiyHeMn
         6/2OOEtUlZXXTMrYRztLPeH9TBPKR0qkG+XlToBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergei Lopatin <magist3r@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 51/60] drm/amd/powerplay: force the trim of the mclk dpm_levels if OD is enabled
Date:   Mon, 20 Apr 2020 14:39:29 +0200
Message-Id: <20200420121514.095203591@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121500.490651540@linuxfoundation.org>
References: <20200420121500.490651540@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Lopatin <magist3r@gmail.com>

commit 8c7f0a44b4b4ef16df8f44fbaee6d1f5d1593c83 upstream.

Should prevent flicker if PP_OVERDRIVE_MASK is set.

bug: https://bugs.freedesktop.org/show_bug.cgi?id=102646
bug: https://bugs.freedesktop.org/show_bug.cgi?id=108941
bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1088
bug: https://gitlab.freedesktop.org/drm/amd/-/issues/628

Signed-off-by: Sergei Lopatin <magist3r@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
@@ -3805,9 +3805,12 @@ static int smu7_trim_single_dpm_states(s
 {
 	uint32_t i;
 
+	/* force the trim if mclk_switching is disabled to prevent flicker */
+	bool force_trim = (low_limit == high_limit);
 	for (i = 0; i < dpm_table->count; i++) {
 	/*skip the trim if od is enabled*/
-		if (!hwmgr->od_enabled && (dpm_table->dpm_levels[i].value < low_limit
+		if ((!hwmgr->od_enabled || force_trim)
+			&& (dpm_table->dpm_levels[i].value < low_limit
 			|| dpm_table->dpm_levels[i].value > high_limit))
 			dpm_table->dpm_levels[i].enabled = false;
 		else


