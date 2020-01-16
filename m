Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFE0140018
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733131AbgAPXsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:48:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:46856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389714AbgAPXUW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:20:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E56A2072B;
        Thu, 16 Jan 2020 23:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216821;
        bh=Wm62BUT+vMuMnI0P9WkNov+yr3SAdiRPTc7piLuoO0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vQfhrPMo1DQ5a5hUITmRESMB6VlSy1lQ6yU3GHTTsXdSVY6B4uJRH/ZTxZ2Gw5tvx
         y+bLRCi0aANeT4QU9JkuGRW5RL1h/sf8nFcgKM8zNVgH+1jyVLZWymhpJHMiDPfuk9
         gvjQt0E4fzABiuLvpJwv4SpV3xScjUQ7Xh6yPtR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Baluta <daniel.baluta@nxp.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 016/203] ASoC: SOF: imx8: Fix dsp_box offset
Date:   Fri, 17 Jan 2020 00:15:33 +0100
Message-Id: <20200116231746.164130836@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Baluta <daniel.baluta@nxp.com>

commit dcf08d0f8f09081b16f69071dd55d51d5e964e84 upstream.

dsp_box is used to keep DSP initiated messages. The value of dsp_offset
is set by the DSP with the first message, so we need a way to bootstrap
it in order to get the first message.

We do this by setting the correct default dsp_box offset which on i.MX8
is not zero.

Very interesting is why it has worked until now.

On i.MX8, DSP communicates with ARM core using a shared SDRAM memory
area. Actually, there are two shared areas:
	* SDRAM0 - starting at 0x92400000, size 0x800000
	* SDRAM1 - starting at 0x92C00000, size 0x800000

SDRAM0 keeps the data sections, starting with .rodata. By chance
fw_ready structure was placed at the beginning of .rodata.

dsp_box_base is defined as SDRAM0 + dsp_box_offset and it is placed
at the beginning of SDRAM1 (dsp_box_offset should be 0x800000). But
because it is zero initialized by default it points to SDRAM0 where
by chance the fw_ready was placed in the SOF firmware.

Anyhow, SOF commit 7466bee378dd811b ("clk: make freq arrays constant")
fw_ready is no longer at the beginning of SDRAM0 and everything shows
how lucky we were until now.

Fix this by properly setting the default dsp_box offset.

Fixes: 202acc565a1f050 ("ASoC: SOF: imx: Add i.MX8 HW support")
Signed-off-by: Daniel Baluta <daniel.baluta@nxp.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191220170531.10423-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/sof/imx/imx8.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/soc/sof/imx/imx8.c
+++ b/sound/soc/sof/imx/imx8.c
@@ -304,6 +304,9 @@ static int imx8_probe(struct snd_sof_dev
 	}
 	sdev->mailbox_bar = SOF_FW_BLK_TYPE_SRAM;
 
+	/* set default mailbox offset for FW ready message */
+	sdev->dsp_box.offset = MBOX_OFFSET;
+
 	return 0;
 
 exit_pdev_unregister:


