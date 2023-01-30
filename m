Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE2F96811C0
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237396AbjA3OQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237381AbjA3OQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:16:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24CF3C2AE
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:16:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E0ADB8117E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BDEC433A1;
        Mon, 30 Jan 2023 14:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088187;
        bh=2HL7tmYeypnH4DJsHPNWadjD7bhnmDe9C97S3FrTmWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CYL0O5118J9DUFImOvJI5iUY0htKLrMyXMvkHoQCSxrkQws/c2ipqpaX0/glHgVrZ
         E5uPqvjELyGwIL5bAJMAbeHf22LLRvBsmDPT8cwD4hHlIdGkGnZrI/05bZJeYz2IOZ
         6kXZxAq4vZG78wm8w6h/8ngf9K22+OKPXj9HFXQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Alexey V. Vissarionov" <gremlin@altlinux.org>,
        Don Brace <don.brace@microchip.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/204] scsi: hpsa: Fix allocation size for scsi_host_alloc()
Date:   Mon, 30 Jan 2023 14:51:50 +0100
Message-Id: <20230130134322.924726426@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey V. Vissarionov <gremlin@altlinux.org>

[ Upstream commit bbbd25499100c810ceaf5193c3cfcab9f7402a33 ]

The 'h' is a pointer to struct ctlr_info, so it's just 4 or 8 bytes, while
the structure itself is much bigger.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: edd163687ea5 ("hpsa: add driver for HP Smart Array controllers.")
Link: https://lore.kernel.org/r/20230118031255.GE15213@altlinux.org
Signed-off-by: Alexey V. Vissarionov <gremlin@altlinux.org>
Acked-by: Don Brace <don.brace@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index cf7988de7b90..8aa5c22ae3ff 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5848,7 +5848,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 {
 	struct Scsi_Host *sh;
 
-	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(h));
+	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(struct ctlr_info));
 	if (sh == NULL) {
 		dev_err(&h->pdev->dev, "scsi_host_alloc failed\n");
 		return -ENOMEM;
-- 
2.39.0



