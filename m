Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3FB9344311
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhCVMsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:48:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230253AbhCVMox (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:44:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4A88619D2;
        Mon, 22 Mar 2021 12:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416915;
        bh=ybMZVrEphn59srJLI+dF5biWFVLv7V5QxYGdotaJHNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8fsyHHIyhakr7fO6IhiWmYCN3Y/ykbvczPgbvERsmHaT+JkQDQwpJxR8CCt7KMEP
         De/usMm66VcigwA7Yj0UxTEzbiMtLfUNu8Yo1usnR8fBhKQ5WagIdhkwWZoNYBScPF
         9zgQjVXWC2qlSdS5ffVGRAt8FsHwK7/qnriorw2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rander Wang <rander.wang@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pan Xiuli <xiuli.pan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 15/60] ASoC: SOF: intel: fix wrong poll bits in dsp power down
Date:   Mon, 22 Mar 2021 13:28:03 +0100
Message-Id: <20210322121922.884707923@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Xiuli <xiuli.pan@linux.intel.com>

commit fd8299181995093948ec6ca75432e797b4a39143 upstream.

The ADSPCS_SPA is Set Power Active bit. To check if DSP is powered
down, we need to check ADSPCS_CPA, the Current Power Active bit.

Fixes: 747503b1813a3 ("ASoC: SOF: Intel: Add Intel specific HDA DSP HW operations")
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Pan Xiuli <xiuli.pan@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210309004127.4940-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/intel/hda-dsp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/sof/intel/hda-dsp.c
+++ b/sound/soc/sof/intel/hda-dsp.c
@@ -179,7 +179,7 @@ int hda_dsp_core_power_down(struct snd_s
 
 	return snd_sof_dsp_read_poll_timeout(sdev, HDA_DSP_BAR,
 				HDA_DSP_REG_ADSPCS, adspcs,
-				!(adspcs & HDA_DSP_ADSPCS_SPA_MASK(core_mask)),
+				!(adspcs & HDA_DSP_ADSPCS_CPA_MASK(core_mask)),
 				HDA_DSP_REG_POLL_INTERVAL_US,
 				HDA_DSP_PD_TIMEOUT * USEC_PER_MSEC);
 }


