Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B265F205F88
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390947AbgFWUdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:33:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391409AbgFWUdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:33:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23218206C3;
        Tue, 23 Jun 2020 20:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944401;
        bh=0isMCShVUmt0PgznSHcfZZBMuds+0OqhFhci1HPEPVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=18Raxs/PuzJ1x5hQggaGQuCzppFkNmSpHl1FAIReb1L8XTCA1ctpcvrpEw39c1U7n
         gw1/ZZZxrllt7VSCu2HYGJPacovQaqxfBJH3w5ah+1jWXe4FWLHxzdgNiIlfvx10zA
         CoWRF2drNVYKS2lJ6R0jfffMmnx96PVVJJ9CJIWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "David (ChunMing) Zhou" <David1.Zhou@amd.com>,
        amd-gfx@lists.freedesktop.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 290/314] drm/amd/display: Use swap() where appropriate
Date:   Tue, 23 Jun 2020 21:58:05 +0200
Message-Id: <20200623195352.809162782@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 34b86b75dfc90ab3d996c224314ce51772a3b351 ]

Mostly a cocci-job, but it flat out refused to remove the
declaration in drivers/gpu/drm/amd/display/dc/core/dc.c so
had to do that part manually.

@swap@
identifier TEMP;
expression A,B;
@@
- TEMP = A;
- A = B;
- B = TEMP;
+ swap(A, B);

@@
type T;
identifier swap.TEMP;
@@
(
- T TEMP;
|
- T TEMP = {...};
)
... when != TEMP

Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Leo Li <sunpeng.li@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: "David (ChunMing) Zhou" <David1.Zhou@amd.com>
Cc: amd-gfx@lists.freedesktop.org
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/bios/bios_parser.c  | 7 ++-----
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c | 8 ++------
 drivers/gpu/drm/amd/display/dc/core/dc.c           | 6 +-----
 3 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c b/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c
index 221e0f56389f3..823843cd26133 100644
--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c
@@ -2543,7 +2543,6 @@ static enum bp_result construct_integrated_info(
 
 	/* Sort voltage table from low to high*/
 	if (result == BP_RESULT_OK) {
-		struct clock_voltage_caps temp = {0, 0};
 		uint32_t i;
 		uint32_t j;
 
@@ -2553,10 +2552,8 @@ static enum bp_result construct_integrated_info(
 						info->disp_clk_voltage[j].max_supported_clk <
 						info->disp_clk_voltage[j-1].max_supported_clk) {
 					/* swap j and j - 1*/
-					temp = info->disp_clk_voltage[j-1];
-					info->disp_clk_voltage[j-1] =
-							info->disp_clk_voltage[j];
-					info->disp_clk_voltage[j] = temp;
+					swap(info->disp_clk_voltage[j - 1],
+					     info->disp_clk_voltage[j]);
 				}
 			}
 		}
diff --git a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
index dff65c0fe82f8..7873abea4112b 100644
--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -1613,8 +1613,6 @@ static enum bp_result construct_integrated_info(
 
 	struct atom_common_table_header *header;
 	struct atom_data_revision revision;
-
-	struct clock_voltage_caps temp = {0, 0};
 	uint32_t i;
 	uint32_t j;
 
@@ -1644,10 +1642,8 @@ static enum bp_result construct_integrated_info(
 				info->disp_clk_voltage[j-1].max_supported_clk
 				) {
 				/* swap j and j - 1*/
-				temp = info->disp_clk_voltage[j-1];
-				info->disp_clk_voltage[j-1] =
-					info->disp_clk_voltage[j];
-				info->disp_clk_voltage[j] = temp;
+				swap(info->disp_clk_voltage[j - 1],
+				     info->disp_clk_voltage[j]);
 			}
 		}
 	}
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index b95a58aa82d91..47e7d11ca0c9c 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -907,15 +907,11 @@ static void program_timing_sync(
 
 		/* set first pipe with plane as master */
 		for (j = 0; j < group_size; j++) {
-			struct pipe_ctx *temp;
-
 			if (pipe_set[j]->plane_state) {
 				if (j == 0)
 					break;
 
-				temp = pipe_set[0];
-				pipe_set[0] = pipe_set[j];
-				pipe_set[j] = temp;
+				swap(pipe_set[0], pipe_set[j]);
 				break;
 			}
 		}
-- 
2.25.1



