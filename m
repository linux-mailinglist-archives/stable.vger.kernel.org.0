Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5E91FE51A
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbgFRCXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:23:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728129AbgFRBSD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:18:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96672221EB;
        Thu, 18 Jun 2020 01:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443082;
        bh=AiQgvc3iTsXpKFLgHM8VmdFtVAO76hfay4A/RQCe6u4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G36D2MEqcA9zQgs3YryT5fhBdjc1gDgKU4y6S968n2pgxuB185wySU+gKPTKapC2D
         b3JWI6NoWN7gqyu60a43/tZrcHH4rrGATjmZG3GxRAspQUujgI9LGpLWtZAMNUYGy5
         rEFNssV8ojW+y/J0c/B5+aqzSQLt1ffQ4tE/PYgg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Stultz <john.stultz@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Patrick Lai <plai@codeaurora.org>,
        Banajit Goswami <bgoswami@codeaurora.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Vinod Koul <vkoul@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Sami Tolvanen <samitolvanen@google.com>,
        Todd Kjos <tkjos@google.com>,
        Alistair Delva <adelva@google.com>,
        Amit Pundir <amit.pundir@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        alsa-devel@alsa-project.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 067/266] ASoC: qcom: q6asm-dai: kCFI fix
Date:   Wed, 17 Jun 2020 21:13:12 -0400
Message-Id: <20200618011631.604574-67-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

[ Upstream commit a6b675a89e51a1cdad0481b809b7840d3f86e4b5 ]

Fixes the following kCFI crash seen on db845c, caused
by the function prototypes not matching the callback
function prototype.

[   82.585661] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000001
[   82.595387] Mem abort info:
[   82.599463]   ESR = 0x96000005
[   82.602658]   EC = 0x25: DABT (current EL), IL = 32 bits
[   82.608177]   SET = 0, FnV = 0
[   82.611829]   EA = 0, S1PTW = 0
[   82.615369] Data abort info:
[   82.618751]   ISV = 0, ISS = 0x00000005
[   82.622641]   CM = 0, WnR = 0
[   82.625774] user pgtable: 4k pages, 39-bit VAs, pgdp=0000000174259000
[   82.632292] [0000000000000001] pgd=0000000000000000, pud=0000000000000000
[   82.639167] Internal error: Oops: 96000005 [#1] PREEMPT SMP
[   82.644795] Modules linked in: hci_uart btqca xhci_plat_hcd xhci_pci_renesas xhci_pci xhci_hcd wcn36xx wcnss_ctrl wcd934x vctrl_regulator ufs_qcom syscon_reboot_e
[   82.644927]  qcom_apcs_ipc_mailbox q6asm_dai q6routing q6asm q6afe_dai q6adm q6afe q6core q6dsp_common pm8941_pwrkey pm8916_wdt platform_mhu pinctrl_spmi_mpp pine
[   82.812982] CPU: 3 PID: 240 Comm: kworker/u16:4 Tainted: G        W         5.6.0-rc7-mainline-00960-g0c34353d11b9-dirty #1
[   82.824201] Hardware name: Thundercomm Dragonboard 845c (DT)
[   82.829937] Workqueue: qcom_apr_rx apr_rxwq [apr]
[   82.834698] pstate: 80c00005 (Nzcv daif +PAN +UAO)
[   82.839553] pc : __cfi_check_fail+0x4/0x1c [q6asm_dai]
[   82.844754] lr : __cfi_check+0x3a8/0x3b0 [q6asm_dai]
[   82.849767] sp : ffffffc0105f3c20
[   82.853123] x29: ffffffc0105f3c30 x28: 0000000000000020
[   82.858489] x27: ffffff80f4588400 x26: ffffff80f458ec94
[   82.863854] x25: ffffff80f458ece8 x24: ffffffe3670c7000
[   82.869220] x23: ffffff8094bb7b34 x22: ffffffe367137000
[   82.874585] x21: bd07909b332eada6 x20: 0000000000000001
[   82.879950] x19: ffffffe36713863c x18: ffffff80f8df4430
[   82.885316] x17: 0000000000000001 x16: ffffffe39d15e660
[   82.890681] x15: 0000000000000001 x14: 0000000000000027
[   82.896047] x13: 0000000000000000 x12: ffffffe39e6465a0
[   82.901413] x11: 0000000000000051 x10: 000000000000ffff
[   82.906779] x9 : 000ffffffe366c19 x8 : c3c5f18762d1ceef
[   82.912145] x7 : 0000000000000000 x6 : ffffffc010877698
[   82.917511] x5 : ffffffc0105f3c00 x4 : 0000000000000000
[   82.922877] x3 : 0000000000000000 x2 : 0000000000000001
[   82.928243] x1 : ffffffe36713863c x0 : 0000000000000001
[   82.933610] Call trace:
[   82.936099]  __cfi_check_fail+0x4/0x1c [q6asm_dai]
[   82.940955]  q6asm_srvc_callback+0x22c/0x618 [q6asm]
[   82.945973]  apr_rxwq+0x1a8/0x27c [apr]
[   82.949861]  process_one_work+0x2e8/0x54c
[   82.953919]  worker_thread+0x27c/0x4d4
[   82.957715]  kthread+0x144/0x154
[   82.960985]  ret_from_fork+0x10/0x18
[   82.964603] Code: a8c37bfd f85f8e5e d65f03c0 b40000a0 (39400008)
[   82.970762] ---[ end trace 410accb839617143 ]---
[   82.975429] Kernel panic - not syncing: Fatal exception

Signed-off-by: John Stultz <john.stultz@linaro.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Patrick Lai <plai@codeaurora.org>
Cc: Banajit Goswami <bgoswami@codeaurora.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Stephan Gerhold <stephan@gerhold.net>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Todd Kjos <tkjos@google.com>
Cc: Alistair Delva <adelva@google.com>
Cc: Amit Pundir <amit.pundir@linaro.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: alsa-devel@alsa-project.org
Link: https://lore.kernel.org/r/20200529213823.98812-1-john.stultz@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6asm-dai.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6asm-dai.c b/sound/soc/qcom/qdsp6/q6asm-dai.c
index 548eb4fa2da6..9f0ffdcef637 100644
--- a/sound/soc/qcom/qdsp6/q6asm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6asm-dai.c
@@ -171,7 +171,7 @@ static const struct snd_compr_codec_caps q6asm_compr_caps = {
 };
 
 static void event_handler(uint32_t opcode, uint32_t token,
-			  uint32_t *payload, void *priv)
+			  void *payload, void *priv)
 {
 	struct q6asm_dai_rtd *prtd = priv;
 	struct snd_pcm_substream *substream = prtd->substream;
@@ -494,7 +494,7 @@ static struct snd_pcm_ops q6asm_dai_ops = {
 };
 
 static void compress_event_handler(uint32_t opcode, uint32_t token,
-				   uint32_t *payload, void *priv)
+				   void *payload, void *priv)
 {
 	struct q6asm_dai_rtd *prtd = priv;
 	struct snd_compr_stream *substream = prtd->cstream;
-- 
2.25.1

