Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8153D5767E4
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 22:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiGOT7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 15:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbiGOT7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 15:59:45 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED53E753B1;
        Fri, 15 Jul 2022 12:59:44 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id p9so6530298pjd.3;
        Fri, 15 Jul 2022 12:59:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HL4YqkhHTZulmVGkQ727X6hpWd2MP1vP+U3JHn48XIg=;
        b=yHuwHoyYr6cZ5w+uU6rGl9fUGgxOhS6/kma3F2Ov01SCRLQrwu1ehCADoeMsGv27J7
         p1csZJFX8PI29SK8hrNC8FKlNieNpOMuJbhZpDaxcPgYG8ISOIJhTsF3EP5fXpaxkY13
         1NIUEZliLSIXdmNhcrg235nAxNyir7MsgOiWQokhR5inJePbZIVQ53te2EgECbv9kpC4
         f1HGWFmeFzXpScKzmf+Zf/1Svv87gQ5Xth3hwhhQjZDnIPtRatdQWWC4jP3XERujs4hb
         OaV6T61OkF3LQZGUpK6Si+TX2ivmNx3l26RBfL+IyDiRIyIwnqW29Mfc9nBnWOa8Wi6x
         2euQ==
X-Gm-Message-State: AJIora/17vwzhWoCPFf3uyL9VdWsHfnQ/FYm13/g1uN4JO0s0ze4AcDr
        RH62wSwxhxr1Cvh6UtF+QhEu25LAzaM=
X-Google-Smtp-Source: AGRyM1ukmZfUzuo48kaMe5GDLlJagmXC8YovtfPvTQyT4c6UyqIKlUNyVjgw7YKbJ1QDyS4v2d0GSQ==
X-Received: by 2002:a17:902:d2c8:b0:16c:58d:7278 with SMTP id n8-20020a170902d2c800b0016c058d7278mr15621362plc.45.1657915184160;
        Fri, 15 Jul 2022 12:59:44 -0700 (PDT)
Received: from sean-ThinkPad-T450s.lan (c-73-71-21-1.hsd1.ca.comcast.net. [73.71.21.1])
        by smtp.gmail.com with ESMTPSA id y1-20020a62ce01000000b00528bc6d8939sm4224629pfg.157.2022.07.15.12.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 12:59:43 -0700 (PDT)
From:   sean.wang@kernel.org
To:     stable@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH v2 5.15 5/5] mt76: mt7921: Fix the error handling path of mt7921_pci_probe()
Date:   Fri, 15 Jul 2022 12:59:26 -0700
Message-Id: <768b04c445f39ad1fc166b98be8154bd413f978a.1657915079.git.sean.wang@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <27b8ccd411f2c51e2b8193a4eb1fa7e6f416a2f0.1657915079.git.sean.wang@kernel.org>
References: <27b8ccd411f2c51e2b8193a4eb1fa7e6f416a2f0.1657915079.git.sean.wang@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 4e90db5e21eb3bb272fe47386dc3506755e209e9 upstream.

In case of error, some resources must be freed, as already done above and
below the devm_kmemdup() and __mt7921e_mcu_drv_pmctrl() calls added in the
commit in Fixes:.

Fixes: 602cc0c9618a ("mt76: mt7921e: fix possible probe failure after reboot")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
v2: no changed
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index 815b926e52e9..36e6495ae658 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -254,8 +254,10 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 	dev->bus_ops = dev->mt76.bus;
 	bus_ops = devm_kmemdup(dev->mt76.dev, dev->bus_ops, sizeof(*bus_ops),
 			       GFP_KERNEL);
-	if (!bus_ops)
-		return -ENOMEM;
+	if (!bus_ops) {
+		ret = -ENOMEM;
+		goto err_free_dev;
+	}
 
 	bus_ops->rr = mt7921_rr;
 	bus_ops->wr = mt7921_wr;
@@ -264,7 +266,7 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 
 	ret = __mt7921e_mcu_drv_pmctrl(dev);
 	if (ret)
-		return ret;
+		goto err_free_dev;
 
 	mdev->rev = (mt7921_l1_rr(dev, MT_HW_CHIPID) << 16) |
 		    (mt7921_l1_rr(dev, MT_HW_REV) & 0xff);
-- 
2.25.1

