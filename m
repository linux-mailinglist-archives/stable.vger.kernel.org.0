Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A683027C910
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730249AbgI2MHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:07:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730250AbgI2Lhg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 553B123A84;
        Tue, 29 Sep 2020 11:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379394;
        bh=K8YFbiPi9jArRe8RYEmaRUiNBfLLK+iMBy+K9lLk7ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tSeLibh1SPZMYF4u+PkuHrnZSh6PZQ+r8jcG0ulezqdvPmsL182pJVek4mpYWgZmA
         WumE2ACnNgo4AeyH3iFydOImXbAg5H/iGJaXTYYkizZQOe4N0DurzalLubOoSoWRLA
         dcmVPC/OfY5BVwDE4GhF1Q1WfXv9UWgQF8tmcrVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Jaska Uimonen <jaska.uimonen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 143/388] ASoC: SOF: ipc: check ipc return value before data copy
Date:   Tue, 29 Sep 2020 12:57:54 +0200
Message-Id: <20200929110017.397173112@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



