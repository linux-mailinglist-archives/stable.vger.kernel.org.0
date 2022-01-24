Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5717049839D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 16:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235688AbiAXPd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 10:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234218AbiAXPd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 10:33:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCC5C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 07:33:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD83E6148B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 15:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31603C340E7;
        Mon, 24 Jan 2022 15:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643038436;
        bh=jkhjis8H6JqAp1zJ1gh7YAG/4kx66gcS8datCwYFgUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NF9JisuHo2ZCNe3U38f3R4mDx/1hyTFPO8bRzd9LPn2FvdP6QP3qolR8dHHB22c3A
         C0JeglThuxvyUSa0iTaT7YMFlZOCCSPDGsZ1Ilq7Y3nnNPVfqiYtE/uEkkI0u+AsKo
         D5mdcY79vZ1OZA6TBgDhcPXjiQnzxvYSx09FkBSLOYuSrwxSinSdeO8lgEg+S10iuU
         AgWLoyNkznRU1/G23BVk6iUtUdkBuZG9CUMY8DgsZ67cSMjlNhmfjUnAG6BER9vkO/
         cTj51zb4srg0d8XFK8odwhPtE7Q9/IFWzojYOErYe3bKn258o5EWTH/Ah9/SB0mKZk
         zB5BXU1egV82A==
From:   Mark Brown <broonie@kernel.org>
To:     Liam Girdwood <lgirdwood@gmail.com>
Cc:     alsa-devel@alsa-project.org, Mark Brown <broonie@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH v1 3/3] ASoC: ops: Reject out of bounds values in snd_soc_put_xr_sx()
Date:   Mon, 24 Jan 2022 15:32:53 +0000
Message-Id: <20220124153253.3548853-4-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220124153253.3548853-1-broonie@kernel.org>
References: <20220124153253.3548853-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=739; h=from:subject; bh=jkhjis8H6JqAp1zJ1gh7YAG/4kx66gcS8datCwYFgUU=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh7sakWbsihUi6ivlHyc+XDsV04Zi7JuDjensfPO4K IJ8b9UeJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYe7GpAAKCRAk1otyXVSH0DJIB/ 96C0pXVD2VI++KwpJCPmOEZH7OklDsEyIV++4ozRLs6NggCnOdvVfFSP2FFPntTDvO27bLrkNk+gH8 FPmc8QUTKpJjEO9r/G2i0XrZM618h8rsIzrqAvzapM8/Z9vi2OJczP2BisdQ9w4pu1Ok9+kXiWbBWt ubXmxDDVrQ3ZQsv+qNZQqB1mDE4+gZJVQGIhK2ezPpxgQWWLFb1LkltvX9WSdcjuxoT7vhjTBpqJkf DcxrVQuoTDP8PoLqSH/I2ZYutH3TOXAJCTi3vMcGl8u+1XZJ95NOldqMcAaFU1DN5I3g/vVJqbnB/p wEpqaYNJymuor3+GM1Ub9Iye1wCHZE
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We don't currently validate that the values being set are within the range
we advertised to userspace as being valid, do so and reject any values
that are out of range.

Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
---
 sound/soc/soc-ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index c31e63b27193..dc0e7c8d31f3 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -879,6 +879,8 @@ int snd_soc_put_xr_sx(struct snd_kcontrol *kcontrol,
 	long val = ucontrol->value.integer.value[0];
 	unsigned int i;
 
+	if (val < mc->min || val > mc->max)
+		return -EINVAL;
 	if (invert)
 		val = max - val;
 	val &= mask;
-- 
2.30.2

