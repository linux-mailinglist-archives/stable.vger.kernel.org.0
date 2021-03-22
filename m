Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A73344113
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhCVMad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:30:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231136AbhCVMaS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:30:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88CEA6198E;
        Mon, 22 Mar 2021 12:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416218;
        bh=/jmJOyPPxMpLbz49aPHEIbiMQv7cDEVyq9c0nyYbbqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ohf3aMFiKwP74vEm7+BCOiG9iMaUzAu/F2obze9F6GFumfh4qM5j3qw5ptxMIoeg0
         oNadLxAaV4mJvXDmDnZZqFlZGVuYPaSrX8q23+vrUTWgD+W7knMy4/qeV8or5AeuYK
         d6Lo6vjwotV+rMtcStVfUXxZlu/30OoRZ0qNh1ZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sung Lee <sung.lee@amd.com>,
        Tony Cheng <Tony.Cheng@amd.com>,
        Yongqiang Sun <yongqiang.sun@amd.com>,
        Qingqing Zhuo <Qingqing.Zhuo@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 023/120] drm/amd/display: Copy over soc values before bounding box creation
Date:   Mon, 22 Mar 2021 13:26:46 +0100
Message-Id: <20210322121930.435513406@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sung Lee <sung.lee@amd.com>

commit 73076790e25717b7d452c2eab0bfb118826e5b61 upstream.

[Why]
With certain fclock overclocks, state 1 may be chosen
as the closest clock level. This may result in this state
being empty if not populated beforehand, resulting in
black screens and screen corruption.

[How]
Copy over all soc states to clock_limits before bounding
box creation to avoid any cases with empty states.

Fixes: f2459c52c84449 ("drm/amd/display: Add Bounding Box State for Low DF PState but High Voltage State")
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1514
Signed-off-by: Sung Lee <sung.lee@amd.com>
Reviewed-by: Tony Cheng <Tony.Cheng@amd.com>
Reviewed-by: Yongqiang Sun <yongqiang.sun@amd.com>
Acked-by: Qingqing Zhuo <Qingqing.Zhuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -1595,6 +1595,11 @@ static void update_bw_bounding_box(struc
 	dcn2_1_soc.num_chans = bw_params->num_channels;
 
 	ASSERT(clk_table->num_entries);
+	/* Copy dcn2_1_soc.clock_limits to clock_limits to avoid copying over null states later */
+	for (i = 0; i < dcn2_1_soc.num_states + 1; i++) {
+		clock_limits[i] = dcn2_1_soc.clock_limits[i];
+	}
+
 	for (i = 0; i < clk_table->num_entries; i++) {
 		/* loop backwards*/
 		for (closest_clk_lvl = 0, j = dcn2_1_soc.num_states - 1; j >= 0; j--) {


