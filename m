Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774674124E0
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353408AbhITSiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:38:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380177AbhITSgY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:36:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2957161360;
        Mon, 20 Sep 2021 17:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158961;
        bh=Ru+MEAzX5O2omW4RBoXa85+qcuUCRwT4xf5WvCKbfnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ns8Cqti5fFECXWUkwtYxa3kPxxNplHRHzH0MDr6+IYQ4RcKKB6F6g1dZuIjhdtKGN
         c9HpcR4VgXK5+w0u44EvHJW2RQhjRbJiPFZxVRah0oowTYVZIgSCFSksI24jmM2hy0
         HlRwx2UFeOdw4r89IA2/5L5nLwOkGBaoax5zvCEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Subject: [PATCH 5.14 013/168] drm/amd/pm: fix runpm hang when amdgpu loaded prior to sound driver
Date:   Mon, 20 Sep 2021 18:42:31 +0200
Message-Id: <20210920163922.088118246@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit 8b514e898ee7f861eb8863c647d258f71053af40 upstream.

Current RUNPM mechanism relies on PMFW to master the timing for BACO
in/exit. And that needs cooperation from sound driver for dstate
change notification for function 1(audio). Otherwise(on sound driver
missing), BACO cannot be kicked in correctly and hang will be observed
on RUNPM exit.

By switching back to legacy message way on sound driver missing,
we are able to fix the runpm hang observed for the scenario below:
amdgpu driver loaded -> runpm suspend kicked -> sound driver loaded

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reported-and-tested-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c         |   24 ++++++++++++++--
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c |    4 +-
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c                  |   21 ++++++++++++++
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h                  |    2 +
 4 files changed, 47 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -2269,7 +2269,27 @@ static int navi10_baco_enter(struct smu_
 {
 	struct amdgpu_device *adev = smu->adev;
 
-	if (adev->in_runpm)
+	/*
+	 * This aims the case below:
+	 *   amdgpu driver loaded -> runpm suspend kicked -> sound driver loaded
+	 *
+	 * For NAVI10 and later ASICs, we rely on PMFW to handle the runpm. To
+	 * make that possible, PMFW needs to acknowledge the dstate transition
+	 * process for both gfx(function 0) and audio(function 1) function of
+	 * the ASIC.
+	 *
+	 * The PCI device's initial runpm status is RUNPM_SUSPENDED. So as the
+	 * device representing the audio function of the ASIC. And that means
+	 * even if the sound driver(snd_hda_intel) was not loaded yet, it's still
+	 * possible runpm suspend kicked on the ASIC. However without the dstate
+	 * transition notification from audio function, pmfw cannot handle the
+	 * BACO in/exit correctly. And that will cause driver hang on runpm
+	 * resuming.
+	 *
+	 * To address this, we revert to legacy message way(driver masters the
+	 * timing for BACO in/exit) on sound driver missing.
+	 */
+	if (adev->in_runpm && smu_cmn_is_audio_func_enabled(adev))
 		return smu_v11_0_baco_set_armd3_sequence(smu, BACO_SEQ_BACO);
 	else
 		return smu_v11_0_baco_enter(smu);
@@ -2279,7 +2299,7 @@ static int navi10_baco_exit(struct smu_c
 {
 	struct amdgpu_device *adev = smu->adev;
 
-	if (adev->in_runpm) {
+	if (adev->in_runpm && smu_cmn_is_audio_func_enabled(adev)) {
 		/* Wait for PMFW handling for the Dstate change */
 		msleep(10);
 		return smu_v11_0_baco_set_armd3_sequence(smu, BACO_SEQ_ULPS);
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -2133,7 +2133,7 @@ static int sienna_cichlid_baco_enter(str
 {
 	struct amdgpu_device *adev = smu->adev;
 
-	if (adev->in_runpm)
+	if (adev->in_runpm && smu_cmn_is_audio_func_enabled(adev))
 		return smu_v11_0_baco_set_armd3_sequence(smu, BACO_SEQ_BACO);
 	else
 		return smu_v11_0_baco_enter(smu);
@@ -2143,7 +2143,7 @@ static int sienna_cichlid_baco_exit(stru
 {
 	struct amdgpu_device *adev = smu->adev;
 
-	if (adev->in_runpm) {
+	if (adev->in_runpm && smu_cmn_is_audio_func_enabled(adev)) {
 		/* Wait for PMFW handling for the Dstate change */
 		msleep(10);
 		return smu_v11_0_baco_set_armd3_sequence(smu, BACO_SEQ_ULPS);
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
@@ -1053,3 +1053,24 @@ int smu_cmn_set_mp1_state(struct smu_con
 
 	return ret;
 }
+
+bool smu_cmn_is_audio_func_enabled(struct amdgpu_device *adev)
+{
+	struct pci_dev *p = NULL;
+	bool snd_driver_loaded;
+
+	/*
+	 * If the ASIC comes with no audio function, we always assume
+	 * it is "enabled".
+	 */
+	p = pci_get_domain_bus_and_slot(pci_domain_nr(adev->pdev->bus),
+			adev->pdev->bus->number, 1);
+	if (!p)
+		return true;
+
+	snd_driver_loaded = pci_is_enabled(p) ? true : false;
+
+	pci_dev_put(p);
+
+	return snd_driver_loaded;
+}
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h
@@ -110,5 +110,7 @@ void smu_cmn_init_soft_gpu_metrics(void
 int smu_cmn_set_mp1_state(struct smu_context *smu,
 			  enum pp_mp1_state mp1_state);
 
+bool smu_cmn_is_audio_func_enabled(struct amdgpu_device *adev);
+
 #endif
 #endif


