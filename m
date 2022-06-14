Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7090A54A620
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354229AbiFNCWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353661AbiFNCUg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:20:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7547A3FBF7;
        Mon, 13 Jun 2022 19:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 591EEB80AC1;
        Tue, 14 Jun 2022 02:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41880C341C5;
        Tue, 14 Jun 2022 02:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172602;
        bh=2NaLsw+VKS3gezcd5noKb0OnET71MfjOfMTBsv/wb2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jh0B1tp3WBA2kzUjTskfCJIDynKriDxhRVZC1GIpYjoOgMnPHlnQjJMBv9WcGn+8m
         N9RlNq0TmXwN2r7O26en8czusWuwjE01C6YeJaW4oE6bBvV5hEjfqln8DaKGASJ4Q7
         VxrBgMDA14eOeZvZ0SS138XHvZqDF7eM4nIr/aME8oNHUDPFCK/vBl5GQGUrNmLaUU
         yKC0XUItU6pskZM47gKXLqPFljQqlskGAmEiqvJ3vOPwchGJ0mdIiprIrZbr/yJuoU
         9YpAgF2zSqQp2jNbE/gj6GGuxU0twSvadg8Z7p/DOmeygbHNldEv8JIo0E7hCfCOev
         0Yy5GAuUsmlKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>, tj@kernel.org,
        linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/18] ata: libata-core: fix NULL pointer deref in ata_host_alloc_pinfo()
Date:   Mon, 13 Jun 2022 22:09:29 -0400
Message-Id: <20220614020941.1100702-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020941.1100702-1-sashal@kernel.org>
References: <20220614020941.1100702-1-sashal@kernel.org>
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
index 0c10d9557754..b0dea0702c74 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6253,7 +6253,7 @@ struct ata_host *ata_host_alloc_pinfo(struct device *dev,
 				      const struct ata_port_info * const * ppi,
 				      int n_ports)
 {
-	const struct ata_port_info *pi;
+	const struct ata_port_info *pi = &ata_dummy_port_info;
 	struct ata_host *host;
 	int i, j;
 
@@ -6261,7 +6261,7 @@ struct ata_host *ata_host_alloc_pinfo(struct device *dev,
 	if (!host)
 		return NULL;
 
-	for (i = 0, j = 0, pi = NULL; i < host->n_ports; i++) {
+	for (i = 0, j = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 
 		if (ppi[j])
-- 
2.35.1

