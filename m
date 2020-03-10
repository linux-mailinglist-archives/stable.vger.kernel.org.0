Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA22417FCA8
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729692AbgCJNBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730281AbgCJNBn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:01:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD58624649;
        Tue, 10 Mar 2020 13:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845302;
        bh=Z6SzoYpOFURwKBVmc69AbfErpqPGTUr+P5WMVNwatcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V4SaCkf05lnvKN0hPqqLJpxpU++82xMtN3HR/ZCPb/Gs0OyBi+GzDajwNmhtkcndc
         l4r7sHcUj8QXzVXwzIep69EmpUgwa82xB3+NtuzDQVmm0s4tDvXnZ2WfDtg71teQI+
         AZiwIziV8piE0EUUVZKgAf5b9mOGjwiHSAfCEvKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.5 134/189] ASoC: intel: skl: Fix possible buffer overflow in debug outputs
Date:   Tue, 10 Mar 2020 13:39:31 +0100
Message-Id: <20200310123653.368538674@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 549cd0ba04dcfe340c349cd983bd440480fae8ee upstream.

The debugfs output of intel skl driver writes strings with multiple
snprintf() calls with the fixed size.  This was supposed to avoid the
buffer overflow but actually it still would, because snprintf()
returns the expected size to be output, not the actual output size.

Fix it by replacing snprintf() calls with scnprintf().

Fixes: d14700a01f91 ("ASoC: Intel: Skylake: Debugfs facility to dump module config")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20200218111737.14193-3-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/intel/skylake/skl-debug.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/sound/soc/intel/skylake/skl-debug.c
+++ b/sound/soc/intel/skylake/skl-debug.c
@@ -35,7 +35,7 @@ static ssize_t skl_print_pins(struct skl
 	ssize_t ret = 0;
 
 	for (i = 0; i < max_pin; i++) {
-		ret += snprintf(buf + size, MOD_BUF - size,
+		ret += scnprintf(buf + size, MOD_BUF - size,
 				"%s %d\n\tModule %d\n\tInstance %d\n\t"
 				"In-used %s\n\tType %s\n"
 				"\tState %d\n\tIndex %d\n",
@@ -53,7 +53,7 @@ static ssize_t skl_print_pins(struct skl
 static ssize_t skl_print_fmt(struct skl_module_fmt *fmt, char *buf,
 					ssize_t size, bool direction)
 {
-	return snprintf(buf + size, MOD_BUF - size,
+	return scnprintf(buf + size, MOD_BUF - size,
 			"%s\n\tCh %d\n\tFreq %d\n\tBit depth %d\n\t"
 			"Valid bit depth %d\n\tCh config %#x\n\tInterleaving %d\n\t"
 			"Sample Type %d\n\tCh Map %#x\n",
@@ -77,16 +77,16 @@ static ssize_t module_read(struct file *
 	if (!buf)
 		return -ENOMEM;
 
-	ret = snprintf(buf, MOD_BUF, "Module:\n\tUUID %pUL\n\tModule id %d\n"
+	ret = scnprintf(buf, MOD_BUF, "Module:\n\tUUID %pUL\n\tModule id %d\n"
 			"\tInstance id %d\n\tPvt_id %d\n", mconfig->guid,
 			mconfig->id.module_id, mconfig->id.instance_id,
 			mconfig->id.pvt_id);
 
-	ret += snprintf(buf + ret, MOD_BUF - ret,
+	ret += scnprintf(buf + ret, MOD_BUF - ret,
 			"Resources:\n\tCPC %#x\n\tIBS %#x\n\tOBS %#x\t\n",
 			res->cpc, res->ibs, res->obs);
 
-	ret += snprintf(buf + ret, MOD_BUF - ret,
+	ret += scnprintf(buf + ret, MOD_BUF - ret,
 			"Module data:\n\tCore %d\n\tIn queue %d\n\t"
 			"Out queue %d\n\tType %s\n",
 			mconfig->core_id, mconfig->max_in_queue,
@@ -96,38 +96,38 @@ static ssize_t module_read(struct file *
 	ret += skl_print_fmt(mconfig->in_fmt, buf, ret, true);
 	ret += skl_print_fmt(mconfig->out_fmt, buf, ret, false);
 
-	ret += snprintf(buf + ret, MOD_BUF - ret,
+	ret += scnprintf(buf + ret, MOD_BUF - ret,
 			"Fixup:\n\tParams %#x\n\tConverter %#x\n",
 			mconfig->params_fixup, mconfig->converter);
 
-	ret += snprintf(buf + ret, MOD_BUF - ret,
+	ret += scnprintf(buf + ret, MOD_BUF - ret,
 			"Module Gateway:\n\tType %#x\n\tVbus %#x\n\tHW conn %#x\n\tSlot %#x\n",
 			mconfig->dev_type, mconfig->vbus_id,
 			mconfig->hw_conn_type, mconfig->time_slot);
 
-	ret += snprintf(buf + ret, MOD_BUF - ret,
+	ret += scnprintf(buf + ret, MOD_BUF - ret,
 			"Pipeline:\n\tID %d\n\tPriority %d\n\tConn Type %d\n\t"
 			"Pages %#x\n", mconfig->pipe->ppl_id,
 			mconfig->pipe->pipe_priority, mconfig->pipe->conn_type,
 			mconfig->pipe->memory_pages);
 
-	ret += snprintf(buf + ret, MOD_BUF - ret,
+	ret += scnprintf(buf + ret, MOD_BUF - ret,
 			"\tParams:\n\t\tHost DMA %d\n\t\tLink DMA %d\n",
 			mconfig->pipe->p_params->host_dma_id,
 			mconfig->pipe->p_params->link_dma_id);
 
-	ret += snprintf(buf + ret, MOD_BUF - ret,
+	ret += scnprintf(buf + ret, MOD_BUF - ret,
 			"\tPCM params:\n\t\tCh %d\n\t\tFreq %d\n\t\tFormat %d\n",
 			mconfig->pipe->p_params->ch,
 			mconfig->pipe->p_params->s_freq,
 			mconfig->pipe->p_params->s_fmt);
 
-	ret += snprintf(buf + ret, MOD_BUF - ret,
+	ret += scnprintf(buf + ret, MOD_BUF - ret,
 			"\tLink %#x\n\tStream %#x\n",
 			mconfig->pipe->p_params->linktype,
 			mconfig->pipe->p_params->stream);
 
-	ret += snprintf(buf + ret, MOD_BUF - ret,
+	ret += scnprintf(buf + ret, MOD_BUF - ret,
 			"\tState %d\n\tPassthru %s\n",
 			mconfig->pipe->state,
 			mconfig->pipe->passthru ? "true" : "false");
@@ -137,7 +137,7 @@ static ssize_t module_read(struct file *
 	ret += skl_print_pins(mconfig->m_out_pin, buf,
 			mconfig->max_out_queue, ret, false);
 
-	ret += snprintf(buf + ret, MOD_BUF - ret,
+	ret += scnprintf(buf + ret, MOD_BUF - ret,
 			"Other:\n\tDomain %d\n\tHomogeneous Input %s\n\t"
 			"Homogeneous Output %s\n\tIn Queue Mask %d\n\t"
 			"Out Queue Mask %d\n\tDMA ID %d\n\tMem Pages %d\n\t"
@@ -193,7 +193,7 @@ static ssize_t fw_softreg_read(struct fi
 		__ioread32_copy(d->fw_read_buff, fw_reg_addr, w0_stat_sz >> 2);
 
 	for (offset = 0; offset < FW_REG_SIZE; offset += 16) {
-		ret += snprintf(tmp + ret, FW_REG_BUF - ret, "%#.4x: ", offset);
+		ret += scnprintf(tmp + ret, FW_REG_BUF - ret, "%#.4x: ", offset);
 		hex_dump_to_buffer(d->fw_read_buff + offset, 16, 16, 4,
 				   tmp + ret, FW_REG_BUF - ret, 0);
 		ret += strlen(tmp + ret);


