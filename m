Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9668CD6A9
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731077AbfJFRkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:40:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731064AbfJFRkp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:40:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11C7A20700;
        Sun,  6 Oct 2019 17:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383644;
        bh=bnDghddhGNrXYMm7y7i94nht+NXgCpKvXxgaNq7ZRAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VwEUPPZJaQ1QLXtnIyh5C5QbTih6HB9Mzdm5LIT7ZeK+8kc3Sl4zL73iaSk7LfcZe
         sfNCF883Fam1SnsMIU5dHyjbrLHXbFOXV0zx4QQUc/SpRPmkLU5nl4AZbN2fj8NtVQ
         DAjeKjGg/Rj/MrJyMBwx9ajyI7IyXyknKdF/g6bI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikola Cornij <nikola.cornij@amd.com>,
        Joshua Aberback <Joshua.Aberback@amd.com>,
        Chris Park <Chris.Park@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 009/166] drm/amd/display: Clear FEC_READY shadow register if DPCD write fails
Date:   Sun,  6 Oct 2019 19:19:35 +0200
Message-Id: <20191006171213.432636170@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikola Cornij <nikola.cornij@amd.com>

[ Upstream commit d68a74541735e030dea56f72746cd26d19986f41 ]

[why]
As a fail-safe, in case 'set FEC_READY' DPCD write fails, a HW shadow
register should be cleared and the internal FEC stat should be set to
'not ready'. This is to make sure HW settings will be consistent with
FEC_READY state on the RX.

Signed-off-by: Nikola Cornij <nikola.cornij@amd.com>
Reviewed-by: Joshua Aberback <Joshua.Aberback@amd.com>
Acked-by: Chris Park <Chris.Park@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 2c7aaed907b91..0bf85a7a2cd31 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -3033,6 +3033,8 @@ void dp_set_fec_ready(struct dc_link *link, bool ready)
 				link_enc->funcs->fec_set_ready(link_enc, true);
 				link->fec_state = dc_link_fec_ready;
 			} else {
+				link->link_enc->funcs->fec_set_ready(link->link_enc, false);
+				link->fec_state = dc_link_fec_not_ready;
 				dm_error("dpcd write failed to set fec_ready");
 			}
 		} else if (link->fec_state == dc_link_fec_ready && !ready) {
-- 
2.20.1



