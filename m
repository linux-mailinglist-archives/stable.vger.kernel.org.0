Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5850A492ABF
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347173AbiARQMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347161AbiARQLN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:11:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97989C0613AD;
        Tue, 18 Jan 2022 08:10:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 377B361325;
        Tue, 18 Jan 2022 16:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1EBC340E5;
        Tue, 18 Jan 2022 16:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522249;
        bh=/uxOlI9z31Oyjq452BPB98/Nzd5AXqAI2zFy6juBHF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DBdFmfF7eO+iwHNtJIW+xneSfeiKJ7kXqTb5RZUgH1O6JFeru2BpKPqEHTHQiqOLv
         7zcMIx5n5w6LMPHtJqmbpJhiz+PCkHPuKBmluEPfCzhoJXW59RuBnbyTFTkAe0i3H9
         9ItgWi6N7GMsUbtKJZwixa+Jti09RhjMO6DOSMVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.16 02/28] drm/amd/display: explicitly set is_dsc_supported to false before use
Date:   Tue, 18 Jan 2022 17:05:57 +0100
Message-Id: <20220118160452.464486698@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160452.384322748@linuxfoundation.org>
References: <20220118160452.384322748@linuxfoundation.org>
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
@@ -6065,6 +6065,7 @@ static void update_dsc_caps(struct amdgp
 							struct dsc_dec_dpcd_caps *dsc_caps)
 {
 	stream->timing.flags.DSC = 0;
+	dsc_caps->is_dsc_supported = false;
 
 	if (aconnector->dc_link && sink->sink_signal == SIGNAL_TYPE_DISPLAY_PORT) {
 		dc_dsc_parse_dsc_dpcd(aconnector->dc_link->ctx->dc,


