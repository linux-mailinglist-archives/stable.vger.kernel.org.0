Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC29492A65
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243041AbiARQJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:09:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39512 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346846AbiARQIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:08:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 427836128A;
        Tue, 18 Jan 2022 16:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04418C00446;
        Tue, 18 Jan 2022 16:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522131;
        bh=qju8o6XoyuGz22CvsF0euEAzaQbEcSDw/wMlTLltAoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VSOffEJqdtvc9WAWxlkK5Mbh3IWPDViFye/0Ly7rDbYHO1OVfZBc16e2fbkHeTdkL
         9l83sFs9/IPWpDt4PP2Flcccks3XwDAnaB7MXTPCCEHrPpcyZHIvVb9WFc8td4cL2P
         dEKGCQdT6FtfAuKkJysMId89R5VWBSAa1oLi5V5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 02/28] drm/amd/display: explicitly set is_dsc_supported to false before use
Date:   Tue, 18 Jan 2022 17:05:48 +0100
Message-Id: <20220118160451.957799245@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160451.879092022@linuxfoundation.org>
References: <20220118160451.879092022@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit 63ad5371cd1e379519395c49a4b6a652c36c98e5 upstream.

When UBSAN is enabled a case is shown on unplugging the display that
this variable hasn't been initialized by `update_dsc_caps`, presumably
when the display was unplugged it wasn't copied from the DPCD.

Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1956497
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5604,6 +5604,7 @@ static void update_dsc_caps(struct amdgp
 							struct dsc_dec_dpcd_caps *dsc_caps)
 {
 	stream->timing.flags.DSC = 0;
+	dsc_caps->is_dsc_supported = false;
 
 	if (aconnector->dc_link && sink->sink_signal == SIGNAL_TYPE_DISPLAY_PORT) {
 		dc_dsc_parse_dsc_dpcd(aconnector->dc_link->ctx->dc,


