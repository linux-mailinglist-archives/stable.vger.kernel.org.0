Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0FF26F33F
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbgIRCET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:04:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51525 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727267AbgIRCET (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:04:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3E1723600;
        Fri, 18 Sep 2020 02:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394652;
        bh=K8YFbiPi9jArRe8RYEmaRUiNBfLLK+iMBy+K9lLk7ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uK8PWcInO1WMeNq4wtmczq5BxJY/IVrRnyjZz+qD6f5qJYQL2EY/erK6eU+GpFmHL
         oF5TurkOxi8Lu1Zoritgc995r0Tzxw1tOSQEyKMfgvi0Ajr0CHLhX7wozWA8ZPM1E5
         tm4RyvKhKgDPbqGIHoGoCt8B3PkYvt/d9+lIZSoc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaska Uimonen <jaska.uimonen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 149/330] ASoC: SOF: ipc: check ipc return value before data copy
Date:   Thu, 17 Sep 2020 21:58:09 -0400
Message-Id: <20200918020110.2063155-149-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaska Uimonen <jaska.uimonen@linux.intel.com>

[ Upstream commit 1919b42ca4ad75a2397081164661af3ce5a7b8f4 ]

In tx_wait_done the ipc payload is copied before the DSP transaction
error code is checked. This might lead to corrupted data in kernel side
even though the error would be handled later. It is also pointless to
copy the data in case of error. So change the order of error check and
copy.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Jaska Uimonen <jaska.uimonen@linux.intel.com>
Link: https://lore.kernel.org/r/20200228231850.9226-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/sound/soc/sof/ipc.c b/sound/soc/sof/ipc.c
index e7b1a80e2a14c..f38f651da2246 100644
--- a/sound/soc/sof/ipc.c
+++ b/sound/soc/sof/ipc.c
@@ -215,15 +215,17 @@ static int tx_wait_done(struct snd_sof_ipc *ipc, struct snd_sof_ipc_msg *msg,
 		snd_sof_trace_notify_for_error(ipc->sdev);
 		ret = -ETIMEDOUT;
 	} else {
-		/* copy the data returned from DSP */
 		ret = msg->reply_error;
-		if (msg->reply_size)
-			memcpy(reply_data, msg->reply_data, msg->reply_size);
-		if (ret < 0)
+		if (ret < 0) {
 			dev_err(sdev->dev, "error: ipc error for 0x%x size %zu\n",
 				hdr->cmd, msg->reply_size);
-		else
+		} else {
 			ipc_log_header(sdev->dev, "ipc tx succeeded", hdr->cmd);
+			if (msg->reply_size)
+				/* copy the data returned from DSP */
+				memcpy(reply_data, msg->reply_data,
+				       msg->reply_size);
+		}
 	}
 
 	return ret;
-- 
2.25.1

