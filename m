Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1AA46383C
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243305AbhK3O6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhK3O4y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:56:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE6DC061D7B;
        Tue, 30 Nov 2021 06:50:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 793ACB81A52;
        Tue, 30 Nov 2021 14:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C2EC53FC7;
        Tue, 30 Nov 2021 14:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283851;
        bh=Z/tw+q0KjEN4a3fO7zZN2tqAT9jijX8ngH7qsDGJvnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCBv9zieRWlD3Y7Se4pInUb+HueJMnXPrXFwwoRcYQAr9XWitCL3Z004uOG7ONMYo
         M3zow58LJm4Vhtjd5tSfbSV7SyBhCmWiM6fqvmHlNB2MxLwEUSr52AYtnuWgeghDM1
         RnEWwSXB9se74CZ2UrRjCOUEu8ev0wE6ixIho7tOjpWOO24t7KaFRFlT2JucmEbquu
         wBXK54lVsWiomhTLm2vPZVm4Xa9W04AQxNBxnhbpA0KR+LdghpdasV+k45m0odfIXB
         C1pfpjPzbcS+uOsmzcA3+3MmwI5ZkUjROTG9ghrRXpHbfKZOUiOuRUEj9X/bqIrIEK
         IoHQOptRjbUnA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, bgoswami@codeaurora.org,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 09/43] ASoC: qdsp6: q6adm: improve error reporting
Date:   Tue, 30 Nov 2021 09:49:46 -0500
Message-Id: <20211130145022.945517-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145022.945517-1-sashal@kernel.org>
References: <20211130145022.945517-1-sashal@kernel.org>
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
index 72f29720398cd..9316775a882a3 100644
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

