Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C0949A46E
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369491AbiAYABz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385506AbiAXX17 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:27:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4E9C01D7E9;
        Mon, 24 Jan 2022 13:30:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E1E2B811FB;
        Mon, 24 Jan 2022 21:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BDBC340E4;
        Mon, 24 Jan 2022 21:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059839;
        bh=cJPgM4GLpjqSaHg5vohVKKh1k0m1iDUXV+RF33JQnf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YINHEIXTrUjvPALOip075YZnYCIncvdv5s4Wkk318ySUwQk9rJJMpwFRwhJkIX5EU
         JLbBQSZOHZT86eKHsma28dZZE63HfAaythrf/xoGVLzW0UYAlsIXa5i00IeeeG1aCE
         VpsLKNv+UtN7Wh6f4l3mHH3tOcCzkqF576g2bAsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ameer Hamza <amhamza.mgc@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0751/1039] ASoC: test-component: fix null pointer dereference.
Date:   Mon, 24 Jan 2022 19:42:20 +0100
Message-Id: <20220124184150.581833869@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



