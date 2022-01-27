Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F188249EA18
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245533AbiA0SMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245534AbiA0SL1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:11:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BA2C06176F;
        Thu, 27 Jan 2022 10:11:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 976B0B820CA;
        Thu, 27 Jan 2022 18:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C67C340E4;
        Thu, 27 Jan 2022 18:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643307084;
        bh=Hcx5t70cbUAEBzlcTN4NFwG/Qeq3pDOJWWGDTDvPBgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TZmmO5cMn4HpFK9VuLg/ZXImB3CbtEmYYpzIvL4ioWqfY4CHpGk97d4GBWE5G+GnT
         EFiYxtAjdk2L9gtT7GbxMmcrtNClJNClrxhiE1w7d2H6wnnaMTgLr/bcfqTPYGbwVf
         TI7JiCCgIq/kgnaOXvtmfALpI9wNTEcS1sj3jvgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.16 2/9] drm/amd/display: reset dcn31 SMU mailbox on failures
Date:   Thu, 27 Jan 2022 19:09:37 +0100
Message-Id: <20220127180258.972390818@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180258.892788582@linuxfoundation.org>
References: <20220127180258.892788582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit 83293f7f3d15fc56e86bd5067a2c88b6b233ac3a upstream.

Otherwise future commands may fail as well leading to downstream
problems that look like they stemmed from a timeout the first time
but really didn't.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c
@@ -119,6 +119,12 @@ int dcn31_smu_send_msg_with_param(
 
 	result = dcn31_smu_wait_for_response(clk_mgr, 10, 200000);
 
+	if (result == VBIOSSMC_Result_Failed) {
+		ASSERT(0);
+		REG_WRITE(MP1_SMN_C2PMSG_91, VBIOSSMC_Result_OK);
+		return -1;
+	}
+
 	if (IS_SMU_TIMEOUT(result)) {
 		ASSERT(0);
 		dm_helpers_smu_timeout(CTX, msg_id, param, 10 * 200000);


