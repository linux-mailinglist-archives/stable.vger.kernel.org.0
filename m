Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7F93D61DA
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbhGZPdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231958AbhGZPbO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:31:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8CC560240;
        Mon, 26 Jul 2021 16:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315902;
        bh=BMP9yqayclaUjrE7oyY1ApPRat3U7yplQs7Ss/03OiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mn1Q9OkU1PKxl0LJNMmP19LhBEEqFOA9xsJod5oFgKKkVJKVfriv2i6ZNBeCXuFod
         r9w1FN/vAICzz2X5ClJYedux9mzrfmaL0f4vDjCAo6l1Zu90IG4+0ZY2yzB6P9YuLH
         181rWKaqMBolsx44vj0FKnBPV1QfGqhg7gfm1VaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Sathya Prakash M R <sathya.prakash.m.r@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 076/223] ASoC: SOF: Intel: Update ADL descriptor to use ACPI power states
Date:   Mon, 26 Jul 2021 17:37:48 +0200
Message-Id: <20210726153848.738845815@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sathya Prakash M R <sathya.prakash.m.r@intel.com>

[ Upstream commit aa21548e34c19c12e924c736f3fd9e6a4d0f5419 ]

The ADL descriptor was missing an ACPI power setting, causing the DSP
to enter D3 even with a D0i1-compatible wake-on-voice/hotwording
capture stream.

Fixes: 4ad03f894b3c ('ASoC: SOF: Intel: Update ADL P to use its own descriptor')
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Sathya Prakash M R <sathya.prakash.m.r@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210712201620.44311-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/pci-tgl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/intel/pci-tgl.c b/sound/soc/sof/intel/pci-tgl.c
index 88c3bf404dd7..d1fd0a330554 100644
--- a/sound/soc/sof/intel/pci-tgl.c
+++ b/sound/soc/sof/intel/pci-tgl.c
@@ -89,6 +89,7 @@ static const struct sof_dev_desc adls_desc = {
 static const struct sof_dev_desc adl_desc = {
 	.machines               = snd_soc_acpi_intel_adl_machines,
 	.alt_machines           = snd_soc_acpi_intel_adl_sdw_machines,
+	.use_acpi_target_states = true,
 	.resindex_lpe_base      = 0,
 	.resindex_pcicfg_base   = -1,
 	.resindex_imr_base      = -1,
-- 
2.30.2



