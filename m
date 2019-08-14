Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFA78DABC
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730531AbfHNRKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:10:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730524AbfHNRKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:10:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24EA9214DA;
        Wed, 14 Aug 2019 17:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802651;
        bh=3hcUrXBwLYEFvDHHf+GYMkiPTXNi7elwJUIL1TIduhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WtBFL4CRS1usCjgm8z7q1BGbkZ2Hcn5GyX2Pi5fKVtkXTrJ7wt2rNkmIMwvOvTzLq
         /hJfx1yF9jjI+vjJQiparFdQI5T78Nt1tIRNAXLE376bVuVuuKuJbE9qmedlwqx5/L
         nq+2fGalIxNb285hTb1YfMIrhInmmBaTsZGmdkvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        SivapiriyanKumarasamy <sivapiriyan.kumarasamy@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/91] drm/amd/display: Wait for backlight programming completion in set backlight level
Date:   Wed, 14 Aug 2019 19:01:02 +0200
Message-Id: <20190814165751.313309758@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c7990daebe71d11a9e360b5c3b0ecd1846a3a4bb ]

[WHY]
Currently we don't wait for blacklight programming completion in DMCU
when setting backlight level. Some sequences such as PSR static screen
event trigger reprogramming requires it to be complete.

[How]
Add generic wait for dmcu command completion in set backlight level.

Signed-off-by: SivapiriyanKumarasamy <sivapiriyan.kumarasamy@amd.com>
Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_abm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_abm.c b/drivers/gpu/drm/amd/display/dc/dce/dce_abm.c
index 070ab56a8aca7..da8b198538e5f 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_abm.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_abm.c
@@ -242,6 +242,10 @@ static void dmcu_set_backlight_level(
 	s2 |= (level << ATOM_S2_CURRENT_BL_LEVEL_SHIFT);
 
 	REG_WRITE(BIOS_SCRATCH_2, s2);
+
+	/* waitDMCUReadyForCmd */
+	REG_WAIT(MASTER_COMM_CNTL_REG, MASTER_COMM_INTERRUPT,
+			0, 1, 80000);
 }
 
 static void dce_abm_init(struct abm *abm)
-- 
2.20.1



