Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0616E29B942
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802289AbgJ0PqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797437AbgJ0P0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:26:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1C322417A;
        Tue, 27 Oct 2020 15:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812415;
        bh=2e1LlIropViaVyQW04caUHDTvly9fBFNOPe/JBU6QAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ku4qAW9Zjmjlvz1edo82hnelXMFulL0Qfr+hY6qBNL9IyA87tPuIktIrwX8Avu5VC
         c0G3AogGY8b42mOBP+znRO6+akG6uGV2K2B9jL7aCz8P5VldNfoss8IHjhz0QLPv6j
         +mao1NRh1cXKAhnUMC4QDXltSKWyLa/ljcsmUHK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 201/757] drm/amd/display: fix potential integer overflow when shifting 32 bit variable bl_pwm
Date:   Tue, 27 Oct 2020 14:47:31 +0100
Message-Id: <20201027135500.032030790@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 1d5503331b12a76266049289747dfd94f1643fde ]

The 32 bit unsigned integer bl_pwm is being shifted using 32 bit arithmetic
and then being assigned to a 64 bit unsigned integer.  There is a potential
for a 32 bit overflow so cast bl_pwm to enforce a 64 bit shift operation
to avoid this.

Addresses-Coverity: ("unintentional integer overflow")
Fixes: 3ba01817365c ("drm/amd/display: Move panel_cntl specific register from abm to panel_cntl.")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c b/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c
index 43781e77be431..f9456ff6845b6 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c
@@ -75,7 +75,7 @@ static unsigned int calculate_16_bit_backlight_from_pwm(struct dce_panel_cntl *d
 	else
 		bl_pwm &= 0xFFFF;
 
-	current_backlight = bl_pwm << (1 + bl_int_count);
+	current_backlight = (uint64_t)bl_pwm << (1 + bl_int_count);
 
 	if (bl_period == 0)
 		bl_period = 0xFFFF;
-- 
2.25.1



