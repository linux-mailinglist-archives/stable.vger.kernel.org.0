Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB8014556C
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbgAVNV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:21:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:39290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729440AbgAVNV5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:21:57 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A2A0205F4;
        Wed, 22 Jan 2020 13:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699316;
        bh=/eE6De9bd/obPBfI1sCrVlL2CEwXPM8wDtngzyOWKgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwdJua+tS1HaR8T9Cz3r7+dmtvs4amvmmbjkGeewVeAAgiX/MRBOuMvM6lg7YfHRr
         LU9qON7yWkUVzJOQ3rVCLZ2uC1pncLsVwIXj5OIsrxKaIdyX3YzW4tfoamH1rOSDV2
         XV9y8Y+kD8E7hzPb75C2GIpYOzeCkFDMo+wCv4uc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Mario Kleiner <mario.kleiner.de@gmail.com>,
        Martin Leung <martin.leung@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 106/222] drm/amd/display: Reorder detect_edp_sink_caps before link settings read.
Date:   Wed, 22 Jan 2020 10:28:12 +0100
Message-Id: <20200122092841.327644984@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Kleiner <mario.kleiner.de@gmail.com>

[ Upstream commit 3b7c59754cc22760760a84ebddb8e0b1e8dd871b ]

read_current_link_settings_on_detect() on eDP 1.4+ may use the
edp_supported_link_rates table which is set up by
detect_edp_sink_caps(), so that function needs to be called first.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Cc: Martin Leung <martin.leung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 793aa8e8ec9a..c0f1c62c59b4 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -809,8 +809,8 @@ bool dc_link_detect(struct dc_link *link, enum dc_detect_reason reason)
 		}
 
 		case SIGNAL_TYPE_EDP: {
-			read_edp_current_link_settings_on_detect(link);
 			detect_edp_sink_caps(link);
+			read_edp_current_link_settings_on_detect(link);
 			sink_caps.transaction_type =
 				DDC_TRANSACTION_TYPE_I2C_OVER_AUX;
 			sink_caps.signal = SIGNAL_TYPE_EDP;
-- 
2.20.1



