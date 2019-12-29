Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 923FA12C970
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbfL2SH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:07:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:58458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731032AbfL2Rrl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:47:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24AD721D7E;
        Sun, 29 Dec 2019 17:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641660;
        bh=k/9AU8rU7PPXycXy/NxsVp7MyrhVU8fpATF7xvi+yII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BbtzbkhTh+h80wzwth7C5BHzcj7XjIWoJxKvmqjKmRpCWuAX80rlIKg0aBoxEMnxP
         g7dAkhIUYzUEqiLUinP7YV7lLsbzlc6P2WVC7BF93jQB3+sJT02euC6k34lsu2JouU
         5KRbJk2GlIPz4/ynHtIKwODZsN0b/9byqNARw/dM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, joseph gravenor <joseph.gravenor@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Roman Li <Roman.Li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 159/434] drm/amd/display: fix header for RN clk mgr
Date:   Sun, 29 Dec 2019 18:23:32 +0100
Message-Id: <20191229172712.331862774@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: joseph gravenor <joseph.gravenor@amd.com>

[ Upstream commit cd83fa1ea9b9431cf1d57ac4179a11bc4393a5b6 ]

[why]
Should always MP0_BASE for any register definition from MP per-IP header files.
I belive the reason the linux version of MP1_BASE works is The 0th element of the 0th table
of that is identical to the corrisponding value of MP0_BASE in the renoir offset header file.
The reason we should only use MP0_BASE is There is only one set of per-IP headers MP
that includes all register definitions related to SMU IP block. This IP includes MP0, MP1, MP2
and  an ecryption engine that can be used only by MP0. As a result all register definitions from
MP file should be based only on MP0_BASE data.

[How]
Change MP1_BASE to MP0_BASE

Signed-off-by: joseph gravenor <joseph.gravenor@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Reviewed-by: Roman Li <Roman.Li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr_vbios_smu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr_vbios_smu.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr_vbios_smu.c
index 50984c1811bb..468c6bb0e311 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr_vbios_smu.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr_vbios_smu.c
@@ -33,7 +33,7 @@
 #include "mp/mp_12_0_0_sh_mask.h"
 
 #define REG(reg_name) \
-	(MP1_BASE.instance[0].segment[mm ## reg_name ## _BASE_IDX] + mm ## reg_name)
+	(MP0_BASE.instance[0].segment[mm ## reg_name ## _BASE_IDX] + mm ## reg_name)
 
 #define FN(reg_name, field) \
 	FD(reg_name##__##field)
-- 
2.20.1



