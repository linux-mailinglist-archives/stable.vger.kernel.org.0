Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 031522F01E
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbfE3EAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729107AbfE3DSO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:14 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1423245AF;
        Thu, 30 May 2019 03:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186294;
        bh=20NGHh9hI3pUhV5NSLVTioijjfVOpQ0vS7J9QaqBhV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B237X1ljmYZ6TQmfDGchEi9vk9aIQutmdC3IHa8veRiVYgfYVKmxBtyymSdNx5xyk
         K/6h5MPLJ4J4KIN81OiOp8iiy7E/oNPRfMLO5U9YpdYLplVrrQeVzRP5PFy7G1f3G2
         tDjdgQD+WLuXVjuqzHCMovy2nPnUGisDNTj/Q5jA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Murton Liu <murton.liu@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Sivapiriyan Kumarasamy <Sivapiriyan.Kumarasamy@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 253/276] drm/amd/display: Fix Divide by 0 in memory calculations
Date:   Wed, 29 May 2019 20:06:51 -0700
Message-Id: <20190530030540.954741678@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 59979bf8be1784ebfc44215031c6c88ca22ae65d ]

Check if we get any values equal to 0, and set to 1 if so.

Signed-off-by: Murton Liu <murton.liu@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Acked-by: Sivapiriyan Kumarasamy <Sivapiriyan.Kumarasamy@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dcn10/dcn10_dpp_dscl.c | 20 ++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_dpp_dscl.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_dpp_dscl.c
index 4a863a5dab417..321af9af95e86 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_dpp_dscl.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_dpp_dscl.c
@@ -406,15 +406,25 @@ void dpp1_dscl_calc_lb_num_partitions(
 		int *num_part_y,
 		int *num_part_c)
 {
+	int lb_memory_size, lb_memory_size_c, lb_memory_size_a, num_partitions_a,
+	lb_bpc, memory_line_size_y, memory_line_size_c, memory_line_size_a;
+
 	int line_size = scl_data->viewport.width < scl_data->recout.width ?
 			scl_data->viewport.width : scl_data->recout.width;
 	int line_size_c = scl_data->viewport_c.width < scl_data->recout.width ?
 			scl_data->viewport_c.width : scl_data->recout.width;
-	int lb_bpc = dpp1_dscl_get_lb_depth_bpc(scl_data->lb_params.depth);
-	int memory_line_size_y = (line_size * lb_bpc + 71) / 72; /* +71 to ceil */
-	int memory_line_size_c = (line_size_c * lb_bpc + 71) / 72; /* +71 to ceil */
-	int memory_line_size_a = (line_size + 5) / 6; /* +5 to ceil */
-	int lb_memory_size, lb_memory_size_c, lb_memory_size_a, num_partitions_a;
+
+	if (line_size == 0)
+		line_size = 1;
+
+	if (line_size_c == 0)
+		line_size_c = 1;
+
+
+	lb_bpc = dpp1_dscl_get_lb_depth_bpc(scl_data->lb_params.depth);
+	memory_line_size_y = (line_size * lb_bpc + 71) / 72; /* +71 to ceil */
+	memory_line_size_c = (line_size_c * lb_bpc + 71) / 72; /* +71 to ceil */
+	memory_line_size_a = (line_size + 5) / 6; /* +5 to ceil */
 
 	if (lb_config == LB_MEMORY_CONFIG_1) {
 		lb_memory_size = 816;
-- 
2.20.1



