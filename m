Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0A5F1311D7
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 13:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbgAFMMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 07:12:39 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:41683 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725787AbgAFMMj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 07:12:39 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id B79825BC;
        Mon,  6 Jan 2020 07:12:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 06 Jan 2020 07:12:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=8PJnlI
        wxKHc05pck40wsezQmKB2OZpF9V9Dp+XUo3kc=; b=JmXANfWIutkGgEpr5khSQW
        caFbjZC8I/2eixP6k2bpH7HmaWLDTfsgsP0vtz5LaBFS1i2OTVEHG6V5a/8DKTBd
        zqvPtW8GifJpGKqtOYWvf1Fmn2/BYjiERY6m5XXM7cDSfpXz3iMhMyaToOxoIEqG
        XtzVipD46pGpvM/FKlcB/shvQCMQRFAqxmSc4wtjF/fB43InD5/tjgIQPGHPiWBW
        zNig6cDzW7OgGtecE4MjmvrOeDyMQMihDFKmmcZiRyicPvDNxTuP4JBfNV2Dw3kU
        lqDIFQMDoK3D5EYCN1/L6qGtJPZ20xd0vdJ902gD2ZOlqKcEa94y/ptrW4qwNclQ
        ==
X-ME-Sender: <xms:NCQTXpjUfYGipJb_blDYaaBt8rnPXsFxjxp8s-70qsGvvW4mkOvnDw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdehtddgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:NCQTXqHFsvh_teQLRhOEVjf3Y-gh7sUldgMwVHPvKpIDBGgHzQIxVA>
    <xmx:NCQTXkbBh6kVXj96rY2n09hR1kPpQ_tvJTKjLXFsmp4sq0sLC0G1YA>
    <xmx:NCQTXtOLZgukkICPe3ltItUYvZcx1-sDNLbkgRzHNASwH9PxEJrjlg>
    <xmx:NSQTXoOsPR4j7r_X4it9S3cZMb3NtlvK5wyQ3zAt5FitILqkV788NQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8BF2C80059;
        Mon,  6 Jan 2020 07:12:36 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amdgpu: correct RLC firmwares loading sequence" failed to apply to 5.4-stable tree
To:     evan.quan@amd.com, Hawking.Zhang@amd.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jan 2020 13:12:34 +0100
Message-ID: <1578312754165159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 969e11529221a6a2a787cb3b63ccf9402f8d2e37 Mon Sep 17 00:00:00 2001
From: Evan Quan <evan.quan@amd.com>
Date: Mon, 23 Dec 2019 16:13:48 +0800
Subject: [PATCH] drm/amdgpu: correct RLC firmwares loading sequence

Per confirmation with RLC firmware team, the RLC should
be unhalted after all RLC related firmwares uploaded.
However, in fact the RLC is unhalted immediately after
RLCG firmware uploaded. And that may causes unexpected
PSP hang on loading the succeeding RLC save restore
list related firmwares.
So, we correct the firmware loading sequence to load
RLC save restore list related firmwares before RLCG
ucode. That will help to get around this issue.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 44be3a45b25e..e1b8d8daeafc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -1488,7 +1488,7 @@ out:
 
 		/* Start rlc autoload after psp recieved all the gfx firmware */
 		if (psp->autoload_supported && ucode->ucode_id == (amdgpu_sriov_vf(adev) ?
-		    AMDGPU_UCODE_ID_CP_MEC2 : AMDGPU_UCODE_ID_RLC_RESTORE_LIST_SRM_MEM)) {
+		    AMDGPU_UCODE_ID_CP_MEC2 : AMDGPU_UCODE_ID_RLC_G)) {
 			ret = psp_rlc_autoload(psp);
 			if (ret) {
 				DRM_ERROR("Failed to start rlc autoload\n");
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.h
index 410587b950f3..914acecda5cf 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.h
@@ -292,10 +292,10 @@ enum AMDGPU_UCODE_ID {
 	AMDGPU_UCODE_ID_CP_MEC2_JT,
 	AMDGPU_UCODE_ID_CP_MES,
 	AMDGPU_UCODE_ID_CP_MES_DATA,
-	AMDGPU_UCODE_ID_RLC_G,
 	AMDGPU_UCODE_ID_RLC_RESTORE_LIST_CNTL,
 	AMDGPU_UCODE_ID_RLC_RESTORE_LIST_GPM_MEM,
 	AMDGPU_UCODE_ID_RLC_RESTORE_LIST_SRM_MEM,
+	AMDGPU_UCODE_ID_RLC_G,
 	AMDGPU_UCODE_ID_STORAGE,
 	AMDGPU_UCODE_ID_SMC,
 	AMDGPU_UCODE_ID_UVD,

