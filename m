Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63FE14CFA02
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238541AbiCGKMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242418AbiCGKLc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:11:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38808AE4C;
        Mon,  7 Mar 2022 01:55:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A534A60A25;
        Mon,  7 Mar 2022 09:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70DFC340E9;
        Mon,  7 Mar 2022 09:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646907;
        bh=/XWQ9igvXNOF1TOD5kOlX/Rg4BH8sV/ES53ZuzWFtrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fd58QLywOvh9UTQPrXaIFvMMQLg4GxXrDk0PL8p4jjr4QMqI00hIu3iAoNb+YAOZB
         psjoWK8ZMU2ueZQz42ICk+6o0pYzEQp/uYzTAxio6TOqM7R1vG1OsxKSnWsEu73Rxb
         1SvSXJddLu6hZyZptnMtfhze68FrJFxv7gaOjQO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Li Yang <leoyang.li@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 130/186] soc: fsl: guts: Revert commit 3c0d64e867ed
Date:   Mon,  7 Mar 2022 10:19:28 +0100
Message-Id: <20220307091657.714709887@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b113737cf12964a20cc3ba1ddabe6229099661c6 ]

This reverts commit 3c0d64e867ed
("soc: fsl: guts: reuse machine name from device tree").

A following patch will fix the missing memory allocation failure check
instead.

Suggested-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/guts.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/fsl/guts.c b/drivers/soc/fsl/guts.c
index 072473a16f4d..af7741eafc57 100644
--- a/drivers/soc/fsl/guts.c
+++ b/drivers/soc/fsl/guts.c
@@ -28,7 +28,6 @@ struct fsl_soc_die_attr {
 static struct guts *guts;
 static struct soc_device_attribute soc_dev_attr;
 static struct soc_device *soc_dev;
-static struct device_node *root;
 
 
 /* SoC die attribute definition for QorIQ platform */
@@ -138,7 +137,7 @@ static u32 fsl_guts_get_svr(void)
 
 static int fsl_guts_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
+	struct device_node *root, *np = pdev->dev.of_node;
 	struct device *dev = &pdev->dev;
 	const struct fsl_soc_die_attr *soc_die;
 	const char *machine;
@@ -159,8 +158,9 @@ static int fsl_guts_probe(struct platform_device *pdev)
 	root = of_find_node_by_path("/");
 	if (of_property_read_string(root, "model", &machine))
 		of_property_read_string_index(root, "compatible", 0, &machine);
+	of_node_put(root);
 	if (machine)
-		soc_dev_attr.machine = machine;
+		soc_dev_attr.machine = devm_kstrdup(dev, machine, GFP_KERNEL);
 
 	svr = fsl_guts_get_svr();
 	soc_die = fsl_soc_die_match(svr, fsl_soc_die);
@@ -195,7 +195,6 @@ static int fsl_guts_probe(struct platform_device *pdev)
 static int fsl_guts_remove(struct platform_device *dev)
 {
 	soc_device_unregister(soc_dev);
-	of_node_put(root);
 	return 0;
 }
 
-- 
2.34.1



