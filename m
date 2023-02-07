Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE7968D875
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbjBGNJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbjBGNJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:09:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED3A3B0FC
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:09:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B267613E2
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667FBC433D2;
        Tue,  7 Feb 2023 13:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775321;
        bh=vxRVJVFsg3ha/9AJLdmNdeyF3VTK/hlw1dKoKN2CMzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVcmwMfm83u8D1caKzV/Ijj0bgZXJRWp5yt5UiunIuuMCh8dCzfoJV8pG6aVi4GvQ
         GNVlMTdNRyFJafEvjs7Yjs0hUFSzehtomP6AREnpm/KiVJH9kWnX/qmTRFbrSyKTrI
         nKmaWTdkRMezRu7Zuc35qJMuDD/58aponc9UPUWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tim Huang <tim.huang@amd.com>,
        Yifan Zhang <yifan1.zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 182/208] drm/amd/pm: drop unneeded dpm features disablement for SMU 13.0.4/11
Date:   Tue,  7 Feb 2023 13:57:16 +0100
Message-Id: <20230207125642.713925190@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Huang <tim.huang@amd.com>

commit 1538709c9f1c207d30afd95ea41b3aeb973f67e7 upstream.

PMFW will handle the features disablement properly for gpu reset case,
driver involvement may cause some unexpected issues.

Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Tim Huang <tim.huang@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1499,6 +1499,20 @@ static int smu_disable_dpms(struct smu_c
 	}
 
 	/*
+	 * For SMU 13.0.4/11, PMFW will handle the features disablement properly
+	 * for gpu reset case. Driver involvement is unnecessary.
+	 */
+	if (amdgpu_in_reset(adev)) {
+		switch (adev->ip_versions[MP1_HWIP][0]) {
+		case IP_VERSION(13, 0, 4):
+		case IP_VERSION(13, 0, 11):
+			return 0;
+		default:
+			break;
+		}
+	}
+
+	/*
 	 * For gpu reset, runpm and hibernation through BACO,
 	 * BACO feature has to be kept enabled.
 	 */


