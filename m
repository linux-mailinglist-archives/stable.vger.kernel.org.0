Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D553720E83E
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391834AbgF2WEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:04:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgF2SfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19A83246A1;
        Mon, 29 Jun 2020 15:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443996;
        bh=yP2iUUsoD9wU6n3FXJD0Asi3/uyg3v8g2KmgWtmx3Mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qW4162CXrxI1ua6gu2B7JJHqra8yY5YRbwcQULF9nahYn10Vm1IfUmc+fkkUY1sj0
         AY+UhnyOsE1R1x1Pkeoag3oHlljBFkaYipc5FrnLNuucMgvv08rn35F95N0IitbzyX
         CGvxGXEE3A9Bksx4G3LWQX3SWVQpORHD55nQ5oIM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 101/265] ASoC: q6asm: handle EOS correctly
Date:   Mon, 29 Jun 2020 11:15:34 -0400
Message-Id: <20200629151818.2493727-102-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 6476b60f32866be49d05e2e0163f337374c55b06 ]

Successful send of EOS command does not indicate that EOS is actually
finished, correct event to wait EOS is finished is EOS_RENDERED event.
EOS_RENDERED means that the DSP has finished processing all the buffers
for that particular session and stream.

This patch fixes EOS handling!

Fixes: 68fd8480bb7b ("ASoC: qdsp6: q6asm: Add support to audio stream apis")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20200611124159.20742-3-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6asm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6asm.c b/sound/soc/qcom/qdsp6/q6asm.c
index 0e0e8f7a460ab..ae4b2cabdf2d6 100644
--- a/sound/soc/qcom/qdsp6/q6asm.c
+++ b/sound/soc/qcom/qdsp6/q6asm.c
@@ -25,6 +25,7 @@
 #define ASM_STREAM_CMD_FLUSH			0x00010BCE
 #define ASM_SESSION_CMD_PAUSE			0x00010BD3
 #define ASM_DATA_CMD_EOS			0x00010BDB
+#define ASM_DATA_EVENT_RENDERED_EOS		0x00010C1C
 #define ASM_NULL_POPP_TOPOLOGY			0x00010C68
 #define ASM_STREAM_CMD_FLUSH_READBUFS		0x00010C09
 #define ASM_STREAM_CMD_SET_ENCDEC_PARAM		0x00010C10
@@ -622,9 +623,6 @@ static int32_t q6asm_stream_callback(struct apr_device *adev,
 		case ASM_SESSION_CMD_SUSPEND:
 			client_event = ASM_CLIENT_EVENT_CMD_SUSPEND_DONE;
 			break;
-		case ASM_DATA_CMD_EOS:
-			client_event = ASM_CLIENT_EVENT_CMD_EOS_DONE;
-			break;
 		case ASM_STREAM_CMD_FLUSH:
 			client_event = ASM_CLIENT_EVENT_CMD_FLUSH_DONE;
 			break;
@@ -727,6 +725,9 @@ static int32_t q6asm_stream_callback(struct apr_device *adev,
 			spin_unlock_irqrestore(&ac->lock, flags);
 		}
 
+		break;
+	case ASM_DATA_EVENT_RENDERED_EOS:
+		client_event = ASM_CLIENT_EVENT_CMD_EOS_DONE;
 		break;
 	}
 
-- 
2.25.1

