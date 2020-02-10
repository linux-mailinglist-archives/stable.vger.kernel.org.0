Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A362715781A
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbgBJMkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:40:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729622AbgBJMkH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:07 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87D8B208C4;
        Mon, 10 Feb 2020 12:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338406;
        bh=m6cwZzCh2LI5USGwyzzuiZR9EePHbRQEa9N2N2+tT1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n+Irx/hEDRsY6bIaOjB2TUL3tEy+FbMfMrqBEv21PpSBCVPXl7PDiK7Ug62Siyw+V
         nh/RedVvBkQF/hE81umt7X+qUFQllOTdS5oXnxzi+S9hldoXyBXRqxvxNSO9zj+72K
         78oGd+c2NpAsfTXeJEvFSL0ewf6m7JHbewPBy8m0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.5 109/367] ASoC: SOF: core: free trace on errors
Date:   Mon, 10 Feb 2020 04:30:22 -0800
Message-Id: <20200210122434.504307647@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit 37e97e6faeabda405d0c4319f8419dcc3da14b2b upstream.

free_trace() is not called on probe errors, fix

Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200124213625.30186-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/sof/core.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -394,7 +394,7 @@ static int sof_probe_continue(struct snd
 	if (ret < 0) {
 		dev_err(sdev->dev,
 			"error: failed to register DSP DAI driver %d\n", ret);
-		goto fw_run_err;
+		goto fw_trace_err;
 	}
 
 	drv_name = plat_data->machine->drv_name;
@@ -408,7 +408,7 @@ static int sof_probe_continue(struct snd
 
 	if (IS_ERR(plat_data->pdev_mach)) {
 		ret = PTR_ERR(plat_data->pdev_mach);
-		goto fw_run_err;
+		goto fw_trace_err;
 	}
 
 	dev_dbg(sdev->dev, "created machine %s\n",
@@ -420,6 +420,8 @@ static int sof_probe_continue(struct snd
 	return 0;
 
 #if !IS_ENABLED(CONFIG_SND_SOC_SOF_PROBE_WORK_QUEUE)
+fw_trace_err:
+	snd_sof_free_trace(sdev);
 fw_run_err:
 	snd_sof_fw_unload(sdev);
 fw_load_err:
@@ -437,6 +439,7 @@ dbg_err:
 	 * snd_sof_device_remove() when the PCI/ACPI device is removed
 	 */
 
+fw_trace_err:
 fw_run_err:
 fw_load_err:
 ipc_err:


