Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE26419C9C
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237289AbhI0Ra3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:30:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237635AbhI0R2F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:28:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D79C6141B;
        Mon, 27 Sep 2021 17:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763030;
        bh=YMhWQq6D4WKHyk8ymfH2x+FucXjzzqzFYBFwV6QThUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vL/TSM4n0UAys2HMwHhpi0Lx0RWhvDk/DxFxla6od0PW0I5NhFtSYT/Fr8VUiXKyY
         lxdBXkiPvoF8Y3YQEVISmbWAUjfA7R/zA6TR+WjGPg4E/zIA28GWtDckrRZCIm8s7V
         iDdlfRS5QR47PTQTuT4kYGT/HGjWYErs01pshiHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Kizito <Jimmy.Kizito@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 142/162] drm/amd/display: Link training retry fix for abort case
Date:   Mon, 27 Sep 2021 19:03:08 +0200
Message-Id: <20210927170238.344869351@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>

[ Upstream commit 71ae30997a8f1791835167d3ceb8d1fab32407db ]

[Why]
If link training is aborted, it shall be retried if sink is present.

[How]
Check hpd status to find out whether sink is present or not. If sink is
present, then link training shall be tried again with same settings.
Otherwise, link training shall be aborted.

Reviewed-by: Jimmy Kizito <Jimmy.Kizito@amd.com>
Acked-by: Mikita Lipski <mikita.lipski@amd.com>
Signed-off-by: Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index a6d0fd24fd02..83ef72a3ebf4 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -1849,9 +1849,13 @@ bool perform_link_training_with_retries(
 		dp_disable_link_phy(link, signal);
 
 		/* Abort link training if failure due to sink being unplugged. */
-		if (status == LINK_TRAINING_ABORT)
-			break;
-		else if (do_fallback) {
+		if (status == LINK_TRAINING_ABORT) {
+			enum dc_connection_type type = dc_connection_none;
+
+			dc_link_detect_sink(link, &type);
+			if (type == dc_connection_none)
+				break;
+		} else if (do_fallback) {
 			decide_fallback_link_setting(*link_setting, &current_setting, status);
 			/* Fail link training if reduced link bandwidth no longer meets
 			 * stream requirements.
-- 
2.33.0



