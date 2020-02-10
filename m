Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E40D2157A65
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729940AbgBJNWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:22:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:58894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728728AbgBJMhX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:23 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D1FF2080C;
        Mon, 10 Feb 2020 12:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338242;
        bh=JfXKu8WXGJyEit29+Aoq5/chrUYHnfbqSuTC+mIif14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=147iBZzOf0fLBSd3uXs68FbEf+qQIkWC6Y2QcJZZrWuY+BogHQtu9xqhlIDE6IHFQ
         8l42xOc18F68eQ5ccHScVd9XXKQ4t+z6a/jdA2Ld5UHmhEynL8VV52YNNGJDWJOZna
         1bW8JgQTXeRa6Exs+QBhR4QobZStKogsb0UHFniE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 097/309] ASoC: SOF: core: free trace on errors
Date:   Mon, 10 Feb 2020 04:30:53 -0800
Message-Id: <20200210122415.477479844@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
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
@@ -368,7 +368,7 @@ static int sof_probe_continue(struct snd
 	if (ret < 0) {
 		dev_err(sdev->dev,
 			"error: failed to register DSP DAI driver %d\n", ret);
-		goto fw_run_err;
+		goto fw_trace_err;
 	}
 
 	drv_name = plat_data->machine->drv_name;
@@ -382,7 +382,7 @@ static int sof_probe_continue(struct snd
 
 	if (IS_ERR(plat_data->pdev_mach)) {
 		ret = PTR_ERR(plat_data->pdev_mach);
-		goto fw_run_err;
+		goto fw_trace_err;
 	}
 
 	dev_dbg(sdev->dev, "created machine %s\n",
@@ -394,6 +394,8 @@ static int sof_probe_continue(struct snd
 	return 0;
 
 #if !IS_ENABLED(CONFIG_SND_SOC_SOF_PROBE_WORK_QUEUE)
+fw_trace_err:
+	snd_sof_free_trace(sdev);
 fw_run_err:
 	snd_sof_fw_unload(sdev);
 fw_load_err:
@@ -411,6 +413,7 @@ dbg_err:
 	 * snd_sof_device_remove() when the PCI/ACPI device is removed
 	 */
 
+fw_trace_err:
 fw_run_err:
 fw_load_err:
 ipc_err:


