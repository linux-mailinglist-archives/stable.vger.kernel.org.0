Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8CD2C78DE
	for <lists+stable@lfdr.de>; Sun, 29 Nov 2020 12:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgK2Lnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Nov 2020 06:43:46 -0500
Received: from mga07.intel.com ([134.134.136.100]:8057 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726780AbgK2Lnp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Nov 2020 06:43:45 -0500
IronPort-SDR: pBJ0TVgvZqVk9urzFqyT96IGg/nOqhrRrtgFM/LF1VkoFLZ63w1c7+gk7xUDTynIXaifBjI37Z
 8hZV40/pKqbg==
X-IronPort-AV: E=McAfee;i="6000,8403,9819"; a="236654204"
X-IronPort-AV: E=Sophos;i="5.78,379,1599548400"; 
   d="scan'208";a="236654204"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2020 03:43:03 -0800
IronPort-SDR: Qawjd+88XOYqtTuNMLZWEm7RyUEyTqRN6yUAYibYEj99MFt03UzyyPEBblOZx9Z7JtRdn+riqY
 BOF/w1uTvs5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,379,1599548400"; 
   d="scan'208";a="480261576"
Received: from crojewsk-ctrl.igk.intel.com ([10.102.9.28])
  by orsmga004.jf.intel.com with ESMTP; 29 Nov 2020 03:43:01 -0800
From:   Cezary Rojewski <cezary.rojewski@intel.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alsa-devel@alsa-project.org, broonie@kernel.org, tiwai@suse.com,
        pierre-louis.bossart@linux.intel.com,
        mateusz.gorski@linux.intel.com,
        Cezary Rojewski <cezary.rojewski@intel.com>
Subject: [PATCH 0/8] ASoC: Intel: Skylake: Fix HDAudio and DMIC for v5.4
Date:   Sun, 29 Nov 2020 12:41:40 +0100
Message-Id: <20201129114148.13772-1-cezary.rojewski@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

First six of the backport address numerous problems troubling HDAudio
configuration users for Skylake driver. Upstream series:
"ASoC: Intel: Skylake: Fix HDaudio and Dmic" [1] provides the
explanation and reasoning behind it. These have been initialy pushed
into v5.7-rc1 via: "sound updates for 5.7-rc1" [2] by Takashi.

Last two patches are from: "Add support for different DMIC
configurations" [3] which focuses on HDAudio with DMIC configuration.
Patch: "ASoC: Intel: Skylake: Add alternative topology binary name"
of the mentioned series has already been merged to v5.4.y -stable and
thus it's not included here.

Fixes target mainly Skylake and Kabylake based platforms, released
in 2015-2016 period.

[1]: https://lore.kernel.org/alsa-devel/20200305145314.32579-1-cezary.rojewski@intel.com/
[2]: https://lore.kernel.org/lkml/s5htv22uso8.wl-tiwai@suse.de/
[3]: https://lore.kernel.org/alsa-devel/20200427132727.24942-1-mateusz.gorski@linux.intel.com/

Cezary Rojewski (6):
  ASoC: Intel: Skylake: Remove superfluous chip initialization
  ASoC: Intel: Skylake: Select hda configuration permissively
  ASoC: Intel: Skylake: Enable codec wakeup during chip init
  ASoC: Intel: Skylake: Shield against no-NHLT configurations
  ASoC: Intel: Allow for ROM init retry on CNL platforms
  ASoC: Intel: Skylake: Await purge request ack on CNL

Mateusz Gorski (2):
  ASoC: Intel: Multiple I/O PCM format support for pipe
  ASoC: Intel: Skylake: Automatic DMIC format configuration according to
    information from NHLT

 include/uapi/sound/skl-tplg-interface.h |   2 +
 sound/soc/intel/skylake/bxt-sst.c       |   3 -
 sound/soc/intel/skylake/cnl-sst.c       |  35 ++++--
 sound/soc/intel/skylake/skl-nhlt.c      |   3 +-
 sound/soc/intel/skylake/skl-sst-dsp.h   |   2 +
 sound/soc/intel/skylake/skl-topology.c  | 159 +++++++++++++++++++++++-
 sound/soc/intel/skylake/skl-topology.h  |   1 +
 sound/soc/intel/skylake/skl.c           |  29 ++---
 8 files changed, 204 insertions(+), 30 deletions(-)

-- 
2.17.1

