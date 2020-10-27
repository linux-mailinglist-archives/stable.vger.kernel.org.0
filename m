Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750E329B809
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799202AbgJ0PaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:30:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799199AbgJ0PaL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:30:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C10222202;
        Tue, 27 Oct 2020 15:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812610;
        bh=E2tosvWYeDbDB3f4v1bu0MBL+y6EscdFDGP6WxYL1LI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k7zHHFvoDrjfjiegyTUPkDAKBD4Am/nQHrTqW/7Eqlm6hDs0hMUFKortl/Mi5oY4e
         pEe8hlbfL20m5sumoLzggFRSbNcP9sTZvur6Qwy5lfJacrYBDduZph5uQ4PfyiSBhh
         Vmx9yW9VgqI7OCRYyfVHmrTRGBOUMLQ8duRhauyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Jaska Uimonen <jaska.uimonen@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 269/757] ASoC: topology: disable size checks for bytes_ext controls if needed
Date:   Tue, 27 Oct 2020 14:48:39 +0100
Message-Id: <20201027135503.190277747@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 6788fc1a66a0c1d1cec7a0f84f94b517eae8611c ]

When CONFIG_SND_CTL_VALIDATION is set, accesses to extended bytes
control generate spurious error messages when the size exceeds 512
bytes, such as

[ 11.224223] sof_sdw sof_sdw: control 2:0:0:EQIIR5.0 eqiir_coef_5:0:
invalid count 1024

In addition the error check returns -EINVAL which has the nasty side
effect of preventing applications accessing controls from working,
e.g.

root@plb:~# alsamixer
cannot load mixer controls: Invalid argument

It's agreed that the control interface has been abused since 2014, but
forcing a check should not prevent existing solutions from working.

This patch skips the checks conditionally if CONFIG_SND_CTL_VALIDATION
is set and the byte array provided by topology is > 512. This
preserves the checks for all other cases.

Fixes: 1a3232d2f61d2 ('ASoC: topology: Add support for TLV bytes controls')
BugLink: https://github.com/thesofproject/linux/issues/2430
Reported-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Jaska Uimonen <jaska.uimonen@intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200917103912.2565907-1-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index 5b60379237bff..d1e7dbb9fea36 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -592,6 +592,17 @@ static int soc_tplg_kcontrol_bind_io(struct snd_soc_tplg_ctl_hdr *hdr,
 		k->info = snd_soc_bytes_info_ext;
 		k->tlv.c = snd_soc_bytes_tlv_callback;
 
+		/*
+		 * When a topology-based implementation abuses the
+		 * control interface and uses bytes_ext controls of
+		 * more than 512 bytes, we need to disable the size
+		 * checks, otherwise accesses to such controls will
+		 * return an -EINVAL error and prevent the card from
+		 * being configured.
+		 */
+		if (IS_ENABLED(CONFIG_SND_CTL_VALIDATION) && sbe->max > 512)
+			k->access |= SNDRV_CTL_ELEM_ACCESS_SKIP_CHECK;
+
 		ext_ops = tplg->bytes_ext_ops;
 		num_ops = tplg->bytes_ext_ops_count;
 		for (i = 0; i < num_ops; i++) {
-- 
2.25.1



