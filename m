Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7664B2F4CA
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388293AbfE3Elq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:41:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728980AbfE3DMW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:22 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA7A3244D4;
        Thu, 30 May 2019 03:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185942;
        bh=zcYXCLDHVhGC+NS8oueAupsBWd0nWcs0IvU5yFJNkIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xbg2ozpY7Q7KAh4lmlpCZ9yUjqXOz5S6fDkyEZ1cQPlLvSZsGvtraZD5ibWEvvRk+
         C4AM/xyBdBofSqdWTnvitKlZ6Oci4ylzJAhw2DTlPJYHSrCx3QMYYWBqEQH84lF+F7
         N3JknmOv5idESqLbqcZs9dEZZSacXmpAEtDAZvvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Murton Liu <murton.liu@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Sivapiriyan Kumarasamy <Sivapiriyan.Kumarasamy@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 348/405] drm/amd/display: Fix Divide by 0 in memory calculations
Date:   Wed, 29 May 2019 20:05:46 -0700
Message-Id: <20190530030558.287948873@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
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
index c7642e7482970..ce21a290bf3e4 100644
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



