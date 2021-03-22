Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9018344172
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhCVMdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:33:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229951AbhCVMcj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:32:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8975461994;
        Mon, 22 Mar 2021 12:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416359;
        bh=xgwPyXeFkHc/fnAJk/jrCtotRs7TB/tSNU4lvEDlxo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NubGJEfcOApHcLSPl1vBjxvn2lqciHuTxMgfTCC23EGqdSi+wSfbvTnWdexBvt2Sm
         mPz3EugXwdkNmTim5DlNecXbDOMoYl4upn36Q/8bcJBwZ644Exwx8zOHyzb2pyrN3k
         kc1leb1/h30X44HydIPQSoRaWiXApHNZ4PUjF3lQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.11 031/120] ASoC: SOF: Intel: unregister DMIC device on probe error
Date:   Mon, 22 Mar 2021 13:26:54 +0100
Message-Id: <20210322121930.696212393@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit 5bb0ecddb2a7f638d65e457f3da9fa334c967b14 upstream.

We only unregister the platform device during the .remove operation,
but if the probe fails we will never reach this sequence.

Suggested-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Fixes: dd96daca6c83e ("ASoC: SOF: Intel: Add APL/CNL HW DSP support")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Link: https://lore.kernel.org/r/20210302003410.1178535-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/intel/hda.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -896,6 +896,7 @@ free_streams:
 /* dsp_unmap: not currently used */
 	iounmap(sdev->bar[HDA_DSP_BAR]);
 hdac_bus_unmap:
+	platform_device_unregister(hdev->dmic_dev);
 	iounmap(bus->remap_addr);
 	hda_codec_i915_exit(sdev);
 err:


