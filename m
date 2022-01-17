Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E84490CEE
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241313AbiAQRAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:00:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49058 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241306AbiAQQ7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 11:59:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29E9C611C8;
        Mon, 17 Jan 2022 16:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A020DC36AEC;
        Mon, 17 Jan 2022 16:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438784;
        bh=cJPgM4GLpjqSaHg5vohVKKh1k0m1iDUXV+RF33JQnf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+l2Py+kcaTU3tBE/G9oO2YJopYzTevjDXZVBQn5NY3pzp1o3XL6gLgzrpKraywKg
         rUC0ryE46FbASTY+RSDF6apoZo9JxRaZLDdD3Nt7HPCEC2VJbtYMfUJ9HOUdgPqYkO
         6fhp56X72UwOGEkfpQWegtYBtT1dPp+vyiZpd2CJEsdyRmi3ChlxT3Qk2wG7EPdHuZ
         mjNYmP5KKJwnzJnzSMuvAffIVSw8HBv4+YozuXZjbxRgbyB0tKx2Gmfi/rgPuWrEzt
         gsi93SXg46Ato4epxepWxLwMFu7VSpmC0dJvD8z5bGG0A98VhTVA7N9euBUhdADnnY
         1R/ihVEcsWDNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ameer Hamza <amhamza.mgc@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, kuninori.morimoto.gx@renesas.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.16 20/52] ASoC: test-component: fix null pointer dereference.
Date:   Mon, 17 Jan 2022 11:58:21 -0500
Message-Id: <20220117165853.1470420-20-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117165853.1470420-1-sashal@kernel.org>
References: <20220117165853.1470420-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ameer Hamza <amhamza.mgc@gmail.com>

[ Upstream commit c686316ec1210d43653c91e104c1e4cd0156dc89 ]

Dereferncing of_id pointer will result in exception in current
implementation since of_match_device() will assign it to NULL.
Adding NULL check for protection.

Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
Link: https://lore.kernel.org/r/20211205204200.7852-1-amhamza.mgc@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/test-component.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/generic/test-component.c b/sound/soc/generic/test-component.c
index 85385a771d807..8fc97d3ff0110 100644
--- a/sound/soc/generic/test-component.c
+++ b/sound/soc/generic/test-component.c
@@ -532,13 +532,16 @@ static int test_driver_probe(struct platform_device *pdev)
 	struct device_node *node = dev->of_node;
 	struct device_node *ep;
 	const struct of_device_id *of_id = of_match_device(test_of_match, &pdev->dev);
-	const struct test_adata *adata = of_id->data;
+	const struct test_adata *adata;
 	struct snd_soc_component_driver *cdriv;
 	struct snd_soc_dai_driver *ddriv;
 	struct test_dai_name *dname;
 	struct test_priv *priv;
 	int num, ret, i;
 
+	if (!of_id)
+		return -EINVAL;
+	adata = of_id->data;
 	num = of_graph_get_endpoint_count(node);
 	if (!num) {
 		dev_err(dev, "no port exits\n");
-- 
2.34.1

