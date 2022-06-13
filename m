Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54CD5480E0
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 09:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiFMHtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 03:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbiFMHtn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 03:49:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F90AAE78
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 00:49:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03E92B80D7F
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 07:49:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D6FC34114;
        Mon, 13 Jun 2022 07:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655106579;
        bh=iN76dHkgEvPZvtaEnYWZ/gsxDAbieJlgWJqhRU43Nsg=;
        h=Subject:To:Cc:From:Date:From;
        b=Vvtia/Vh7m6Ns/kpqq/po+O44+jaBfDlmKx17GM/ZvPPzbZTslxOysMMtusMPPPid
         2XtlvHGOURASxvG+UnLnAgLVF0j3v1H1U4sRt3WunOxZSd2k3wYsX/S2hXtwhVTsym
         CeaDJSDe06hiJA692cQoMjNSqK5PD/wfhlNHHaW4=
Subject: FAILED: patch "[PATCH] drm/amdgpu: enable tmz by default for GC 10.3.7" failed to apply to 5.18-stable tree
To:     sunil.khatri@amd.com, Alexander.Deucher@amd.com,
        alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jun 2022 09:49:37 +0200
Message-ID: <16551065769661@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 371017309a9f1725bfd3283afe61efa4ac34d30c Mon Sep 17 00:00:00 2001
From: Sunil Khatri <sunil.khatri@amd.com>
Date: Mon, 30 May 2022 23:24:09 +0530
Subject: [PATCH] drm/amdgpu: enable tmz by default for GC 10.3.7

Add IP GC 10.3.7 in the list of target to have
tmz enabled by default.

Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Alexander Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.18.x

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
index 798c56214a23..aebc384531ac 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -518,6 +518,8 @@ void amdgpu_gmc_tmz_set(struct amdgpu_device *adev)
 	case IP_VERSION(9, 1, 0):
 	/* RENOIR looks like RAVEN */
 	case IP_VERSION(9, 3, 0):
+	/* GC 10.3.7 */
+	case IP_VERSION(10, 3, 7):
 		if (amdgpu_tmz == 0) {
 			adev->gmc.tmz_enabled = false;
 			dev_info(adev->dev,
@@ -540,8 +542,6 @@ void amdgpu_gmc_tmz_set(struct amdgpu_device *adev)
 	case IP_VERSION(10, 3, 1):
 	/* YELLOW_CARP*/
 	case IP_VERSION(10, 3, 3):
-	/* GC 10.3.7 */
-	case IP_VERSION(10, 3, 7):
 		/* Don't enable it by default yet.
 		 */
 		if (amdgpu_tmz < 1) {

