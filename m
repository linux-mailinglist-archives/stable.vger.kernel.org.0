Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6B054A5C4
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353097AbiFNCPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354652AbiFNCO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:14:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9629A3CA51;
        Mon, 13 Jun 2022 19:08:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4FBDB816AC;
        Tue, 14 Jun 2022 02:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2736C341C0;
        Tue, 14 Jun 2022 02:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172512;
        bh=8Qzn7BoD5ZQpLMt2i9GXYEkymXCq5HaMGEz1nkaAPTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hwyjrSWxy98bPb+Vs8aHw1vJQcwPXmW6T5PrEejnnab1y6DAUNPtJq1asIYYOZNkq
         /AYLRBMj6Q9piAiJqIF1P4gBnZ07CGMgwKQMEy0LFVLnkkKSGx7zMb0k+GR4DjQWXA
         cY9ujN/fGpF4ohyVKnl5y3g17TCJPAuo4yjDlDUk54l46tl5K+F0r7cj8F0IbaEai+
         C92ZEmhWZphPIFpLrTMp17t+6aYB2tzccUE6ZiNsBINkqO1gXH65FnzmUfAg4wuna3
         ze7O+o7L3dSk/qngb3OPIcRN+m9kG5WC88qRYQp36WIyLnZGHOgnSkh2CcN0WFT9Ts
         K8F7Si7KJioOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>, tj@kernel.org,
        linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/29] ata: libata-core: fix NULL pointer deref in ata_host_alloc_pinfo()
Date:   Mon, 13 Jun 2022 22:07:56 -0400
Message-Id: <20220614020815.1099999-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020815.1099999-1-sashal@kernel.org>
References: <20220614020815.1099999-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit bf476fe22aa1851bab4728e0c49025a6a0bea307 ]

In an unlikely (and probably wrong?) case that the 'ppi' parameter of
ata_host_alloc_pinfo() points to an array starting with a NULL pointer,
there's going to be a kernel oops as the 'pi' local variable won't get
reassigned from the initial value of NULL. Initialize 'pi' instead to
'&ata_dummy_port_info' to fix the possible kernel oops for good...

Found by Linux Verification Center (linuxtesting.org) with the SVACE static
analysis tool.

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f963a0a7da46..2402fa4d8aa5 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5475,7 +5475,7 @@ struct ata_host *ata_host_alloc_pinfo(struct device *dev,
 				      const struct ata_port_info * const * ppi,
 				      int n_ports)
 {
-	const struct ata_port_info *pi;
+	const struct ata_port_info *pi = &ata_dummy_port_info;
 	struct ata_host *host;
 	int i, j;
 
@@ -5483,7 +5483,7 @@ struct ata_host *ata_host_alloc_pinfo(struct device *dev,
 	if (!host)
 		return NULL;
 
-	for (i = 0, j = 0, pi = NULL; i < host->n_ports; i++) {
+	for (i = 0, j = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 
 		if (ppi[j])
-- 
2.35.1

