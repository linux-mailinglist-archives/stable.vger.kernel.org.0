Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961AB1D84B7
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732397AbgERSBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731865AbgERSBT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:01:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB082207C4;
        Mon, 18 May 2020 18:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824879;
        bh=qNHYMA83Jgcv+K+raxRtQrHGkwV/3IYbnkegAaQqcg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x8YozzdYChTLXjemojapjA98kmg9C3p7odY/mNycFWiGTduOM6deDjuFhBefF/xFi
         oKUY72y6XdokKphFDtS0sXa54WC/sdLoHcUA1F5XXNiDneO9Zry7gxlLG997HiQKyF
         WJPM2VQHkQ0bdl88YCkojpysLO8TEnW58Ub3+dwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 006/194] drm/i915/tgl: TBT AUX should use TC power well ops
Date:   Mon, 18 May 2020 19:34:56 +0200
Message-Id: <20200518173532.128190901@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 335f62e7606a7921775d7cc73f0ad8ffd899bc22 ]

As on ICL, we want to use the Type-C aux handlers for the TBT aux wells
to ensure the DP_AUX_CH_CTL_TBT_IO flag is set properly.

Fixes: 656409bbaf87 ("drm/i915/tgl: Add power well support")
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200415233435.3064257-1-matthew.d.roper@intel.com
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
(cherry picked from commit 3cbdb97564a39020262e62b655e788b63cf426cb)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_display_power.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display_power.c b/drivers/gpu/drm/i915/display/intel_display_power.c
index 46c40db992dd7..5895b8c7662e3 100644
--- a/drivers/gpu/drm/i915/display/intel_display_power.c
+++ b/drivers/gpu/drm/i915/display/intel_display_power.c
@@ -4068,7 +4068,7 @@ static const struct i915_power_well_desc tgl_power_wells[] = {
 	{
 		.name = "AUX D TBT1",
 		.domains = TGL_AUX_D_TBT1_IO_POWER_DOMAINS,
-		.ops = &hsw_power_well_ops,
+		.ops = &icl_tc_phy_aux_power_well_ops,
 		.id = DISP_PW_ID_NONE,
 		{
 			.hsw.regs = &icl_aux_power_well_regs,
@@ -4079,7 +4079,7 @@ static const struct i915_power_well_desc tgl_power_wells[] = {
 	{
 		.name = "AUX E TBT2",
 		.domains = TGL_AUX_E_TBT2_IO_POWER_DOMAINS,
-		.ops = &hsw_power_well_ops,
+		.ops = &icl_tc_phy_aux_power_well_ops,
 		.id = DISP_PW_ID_NONE,
 		{
 			.hsw.regs = &icl_aux_power_well_regs,
@@ -4090,7 +4090,7 @@ static const struct i915_power_well_desc tgl_power_wells[] = {
 	{
 		.name = "AUX F TBT3",
 		.domains = TGL_AUX_F_TBT3_IO_POWER_DOMAINS,
-		.ops = &hsw_power_well_ops,
+		.ops = &icl_tc_phy_aux_power_well_ops,
 		.id = DISP_PW_ID_NONE,
 		{
 			.hsw.regs = &icl_aux_power_well_regs,
@@ -4101,7 +4101,7 @@ static const struct i915_power_well_desc tgl_power_wells[] = {
 	{
 		.name = "AUX G TBT4",
 		.domains = TGL_AUX_G_TBT4_IO_POWER_DOMAINS,
-		.ops = &hsw_power_well_ops,
+		.ops = &icl_tc_phy_aux_power_well_ops,
 		.id = DISP_PW_ID_NONE,
 		{
 			.hsw.regs = &icl_aux_power_well_regs,
@@ -4112,7 +4112,7 @@ static const struct i915_power_well_desc tgl_power_wells[] = {
 	{
 		.name = "AUX H TBT5",
 		.domains = TGL_AUX_H_TBT5_IO_POWER_DOMAINS,
-		.ops = &hsw_power_well_ops,
+		.ops = &icl_tc_phy_aux_power_well_ops,
 		.id = DISP_PW_ID_NONE,
 		{
 			.hsw.regs = &icl_aux_power_well_regs,
@@ -4123,7 +4123,7 @@ static const struct i915_power_well_desc tgl_power_wells[] = {
 	{
 		.name = "AUX I TBT6",
 		.domains = TGL_AUX_I_TBT6_IO_POWER_DOMAINS,
-		.ops = &hsw_power_well_ops,
+		.ops = &icl_tc_phy_aux_power_well_ops,
 		.id = DISP_PW_ID_NONE,
 		{
 			.hsw.regs = &icl_aux_power_well_regs,
-- 
2.20.1



