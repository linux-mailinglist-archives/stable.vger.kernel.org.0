Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29CE4CF737
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbiCGJpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239012AbiCGJjI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:39:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B494E70332;
        Mon,  7 Mar 2022 01:34:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4091CB810B6;
        Mon,  7 Mar 2022 09:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F85BC340F3;
        Mon,  7 Mar 2022 09:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645606;
        bh=1zPQ1h+JVqvtBMyT8pf3fIRvne3QVF7gguqyCR2aGf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AD/w47Aj1HDLoaaY8OAUvsKz2jtbFjvHcunDipJPDrgdnWzkKSwCmyQIlbPCKoaVt
         K0RvMsaxgyenWhKe+hKxoDrCFF8Gti9Djnbq3Q0a5ISSDGsanpP3UCJf3H380Om66b
         szrUdP1Jw83c6bLFvLV2SRDzGWHJutPAoqcMKTgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Li Yang <leoyang.li@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/105] soc: fsl: guts: Add a missing memory allocation failure check
Date:   Mon,  7 Mar 2022 10:19:28 +0100
Message-Id: <20220307091646.571002433@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
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

[ Upstream commit b9abe942cda43a1d46a0fd96efb54f1aa909f757 ]

If 'devm_kstrdup()' fails, we should return -ENOMEM.

While at it, move the 'of_node_put()' call in the error handling path and
after the 'machine' has been copied.
Better safe than sorry.

Fixes: a6fc3b698130 ("soc: fsl: add GUTS driver for QorIQ platforms")
Depends-on: fddacc7ff4dd ("soc: fsl: guts: Revert commit 3c0d64e867ed")
Suggested-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/guts.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/fsl/guts.c b/drivers/soc/fsl/guts.c
index 6d7465afd6fd..091e94c04f30 100644
--- a/drivers/soc/fsl/guts.c
+++ b/drivers/soc/fsl/guts.c
@@ -160,9 +160,14 @@ static int fsl_guts_probe(struct platform_device *pdev)
 	root = of_find_node_by_path("/");
 	if (of_property_read_string(root, "model", &machine))
 		of_property_read_string_index(root, "compatible", 0, &machine);
-	of_node_put(root);
-	if (machine)
+	if (machine) {
 		soc_dev_attr.machine = devm_kstrdup(dev, machine, GFP_KERNEL);
+		if (!soc_dev_attr.machine) {
+			of_node_put(root);
+			return -ENOMEM;
+		}
+	}
+	of_node_put(root);
 
 	svr = fsl_guts_get_svr();
 	soc_die = fsl_soc_die_match(svr, fsl_soc_die);
-- 
2.34.1



