Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1709F797B6
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390175AbfG2Ts6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:48:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390457AbfG2Ts5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:48:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 823B22054F;
        Mon, 29 Jul 2019 19:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429736;
        bh=HJFjq2UfmQyHbylLZ3M1AcIZTVsvoJQTNcts5rruxQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DAXNGuMi0/IxlomFGa+nlc3J0VKxkkmXHL6vnzdOYF5JEhl6JMO9Pj8auRZI8zEF8
         Iw/uVNWC4jKubB1u3wKeDalKwib4FUfqo1LppH/o2ijFbjagEN1Ar0TFIb1OwNleHO
         k/8Tfb9X88VKW/qU+47xRZoWK4UOThmJTCyqEOA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eryk Brol <eryk.brol@amd.com>,
        Jun Lei <Jun.Lei@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 039/215] drm/amd/display: Increase Backlight Gain Step Size
Date:   Mon, 29 Jul 2019 21:20:35 +0200
Message-Id: <20190729190747.272234360@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e25228b02e4833e5b0fdd262801a2ae6cc72b39d ]

[Why]
Some backlight tests fail due to backlight settling
taking too long. This happens because the step
size used to change backlight levels is too small.

[How]
1. Change the size of the backlight gain step size
2. Change how DMCU firmware gets the step size value
   so that it is passed in by driver during DMCU initn

Signed-off-by: Eryk Brol <eryk.brol@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c | 3 +++
 drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c b/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c
index 818536eea00a..c6a607cd0e4b 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c
@@ -388,6 +388,9 @@ static bool dcn10_dmcu_init(struct dmcu *dmcu)
 		/* Set initialized ramping boundary value */
 		REG_WRITE(MASTER_COMM_DATA_REG1, 0xFFFF);
 
+		/* Set backlight ramping stepsize */
+		REG_WRITE(MASTER_COMM_DATA_REG2, abm_gain_stepsize);
+
 		/* Set command to initialize microcontroller */
 		REG_UPDATE(MASTER_COMM_CMD_REG, MASTER_COMM_CMD_REG_BYTE0,
 			MCP_INIT_DMCU);
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.h b/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.h
index 60ce56f60ae3..5bd0df55aa5d 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.h
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.h
@@ -263,4 +263,6 @@ struct dmcu *dcn10_dmcu_create(
 
 void dce_dmcu_destroy(struct dmcu **dmcu);
 
+static const uint32_t abm_gain_stepsize = 0x0060;
+
 #endif /* _DCE_ABM_H_ */
-- 
2.20.1



