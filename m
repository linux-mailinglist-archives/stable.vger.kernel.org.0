Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A73FFEEEB6
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388454AbfKDWQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:16:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:34262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388847AbfKDWDr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:03:47 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 986FC214D8;
        Mon,  4 Nov 2019 22:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905027;
        bh=b3/mqkS/ti/J3enHFmNvliOAXF3T37A5pGUcpZ2Tf6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Of3dmJ7LGmGluFhc4/RjNxLr5LTtLGU75su1Jimbst/XENaSiq3EIk2Ds2CNrK4Bs
         c/G1E1s/4tkPalVfZWXvpXGfNA62eRd9kwIDt/OnLKTeV8FO52LkZO31nvmsKhyDvE
         3sZr1VTDWndeqloeRWE1QxyhxCu6k99cOGBYcAVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pelle van Gils <pelle@vangils.xyz>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.19 133/149] drm/amdgpu/powerplay/vega10: allow undervolting in p7
Date:   Mon,  4 Nov 2019 22:45:26 +0100
Message-Id: <20191104212146.104726694@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pelle van Gils <pelle@vangils.xyz>

commit e6f4e274c1e52d1f0bfe293fb44ddf59de6c0374 upstream.

The vega10_odn_update_soc_table() function does not allow the SCLK
dependent voltage to be set for power-state 7 to a value below the default
in pptable. Change the for-loop condition to allow undervolting in the
highest state.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=205277
Signed-off-by: Pelle van Gils <pelle@vangils.xyz>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c
@@ -4751,9 +4751,7 @@ static void vega10_odn_update_soc_table(
 
 	if (type == PP_OD_EDIT_SCLK_VDDC_TABLE) {
 		podn_vdd_dep = &data->odn_dpm_table.vdd_dep_on_sclk;
-		for (i = 0; i < podn_vdd_dep->count - 1; i++)
-			od_vddc_lookup_table->entries[i].us_vdd = podn_vdd_dep->entries[i].vddc;
-		if (od_vddc_lookup_table->entries[i].us_vdd < podn_vdd_dep->entries[i].vddc)
+		for (i = 0; i < podn_vdd_dep->count; i++)
 			od_vddc_lookup_table->entries[i].us_vdd = podn_vdd_dep->entries[i].vddc;
 	} else if (type == PP_OD_EDIT_MCLK_VDDC_TABLE) {
 		podn_vdd_dep = &data->odn_dpm_table.vdd_dep_on_mclk;


