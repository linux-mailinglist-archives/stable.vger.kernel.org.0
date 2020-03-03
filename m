Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9A5177E11
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 18:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731083AbgCCRqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:46:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:52718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729854AbgCCRqN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:46:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBD6820842;
        Tue,  3 Mar 2020 17:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257573;
        bh=r4h0h0vNmAe26MlCqgqj9TQfWY49lPNNCtdDgv9Pe6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y2JkjPpmkgAhZvtL+8F7ICZDCmNg2O+21Tg/e16wJajr2kXvgx1EZSB7KbbAnrODM
         p+oet5HqYdszW34DiSa/RZCKsgwCdM1MWDjj1vG2C6giX28bfQLgBDH3cMuZT2Cn48
         OvAHoohhCh7EDnIulPokzImx+p5DaQDgoFgHgEhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aric Cyr <aric.cyr@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 047/176] drm/amd/display: Check engine is not NULL before acquiring
Date:   Tue,  3 Mar 2020 18:41:51 +0100
Message-Id: <20200303174309.993512910@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aric Cyr <aric.cyr@amd.com>

[ Upstream commit 2b63d0ec0daf79ba503fa8bfa25e07dc3da274f3 ]

[Why]
Engine can be NULL in some cases, so we must not acquire it.

[How]
Check for NULL engine before acquiring.

Signed-off-by: Aric Cyr <aric.cyr@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_aux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_aux.c b/drivers/gpu/drm/amd/display/dc/dce/dce_aux.c
index 793c0cec407f9..5fcffb29317e3 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_aux.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_aux.c
@@ -398,7 +398,7 @@ static bool acquire(
 {
 	enum gpio_result result;
 
-	if (!is_engine_available(engine))
+	if ((engine == NULL) || !is_engine_available(engine))
 		return false;
 
 	result = dal_ddc_open(ddc, GPIO_MODE_HARDWARE,
-- 
2.20.1



