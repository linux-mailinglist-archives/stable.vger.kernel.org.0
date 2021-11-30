Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7137F463720
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237285AbhK3OvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:51:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45144 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbhK3OvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:51:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29823B81A1A;
        Tue, 30 Nov 2021 14:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83E2C53FD0;
        Tue, 30 Nov 2021 14:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283675;
        bh=y8cz4/DIakiLjkY7BXYyXZxQsEHrnuVnY9Qv+AzozWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwUiw8hC8hvmmtkwAuM2H7jyx4+cnIM9CMyUgUdmkF7HBD/QC5mW5f3jY4YJGsjpp
         4I4pnm7FVa89t58vZPpyF0QOGzPb7eY0e+ZzIXZxbI5AEJTXXP0RsQJUZ8dtPSOKpG
         G9H4uFfcrJM4Auoxu9/PumEYCuuGNvcT6Ofo9QW9UlsZZrBHYs85f5OIF0XtUguQqj
         Dkx9WvCE6wyDrzqTJrF/THXn7pRrsmSyBOZOxOaLMJx5xvbLd0S93qcSgtzvEWUSfm
         RSzTl0IVk7Aa0/A4Vy8QPp6VnuZuEksTte0wC9IiKxxdvjja25FQH2mkGkXfjc8qEX
         3pByb29frzqcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, bgoswami@codeaurora.org,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 14/68] ASoC: qdsp6: q6adm: improve error reporting
Date:   Tue, 30 Nov 2021 09:46:10 -0500
Message-Id: <20211130144707.944580-14-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 0a270471d68533f59c5cfd631a3fce31a3b17144 ]

reset value for port is -1 so printing an hex would not give us very
useful debug information, so use %d instead.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20211116114721.12517-5-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6adm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6adm.c b/sound/soc/qcom/qdsp6/q6adm.c
index 3d831b635524f..72c5719f1d253 100644
--- a/sound/soc/qcom/qdsp6/q6adm.c
+++ b/sound/soc/qcom/qdsp6/q6adm.c
@@ -390,7 +390,7 @@ struct q6copp *q6adm_open(struct device *dev, int port_id, int path, int rate,
 	int ret = 0;
 
 	if (port_id < 0) {
-		dev_err(dev, "Invalid port_id 0x%x\n", port_id);
+		dev_err(dev, "Invalid port_id %d\n", port_id);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -508,7 +508,7 @@ int q6adm_matrix_map(struct device *dev, int path,
 		int port_idx = payload_map.port_id[i];
 
 		if (port_idx < 0) {
-			dev_err(dev, "Invalid port_id 0x%x\n",
+			dev_err(dev, "Invalid port_id %d\n",
 				payload_map.port_id[i]);
 			kfree(pkt);
 			return -EINVAL;
-- 
2.33.0

