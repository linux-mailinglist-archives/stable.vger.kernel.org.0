Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C80C58DF0C
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345267AbiHISaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344078AbiHIS3I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:29:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C11E0DB;
        Tue,  9 Aug 2022 11:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 563DAB81A28;
        Tue,  9 Aug 2022 18:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BD6C433D7;
        Tue,  9 Aug 2022 18:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068493;
        bh=/r/vSlJypZ8OUr7CvbZM/sbsoGVTzCnQS+HjWsLDgjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rBfgcNoa3iQFeT7mPOhhuP+QbxJiFw1dHazNTflclnbQZTIwFIQ5T8pzqRBz1JSwv
         rOisqjkWB3xQ/AVAeVZX1tEpbWy/khL5iz3ZszTrVFe5hUSy/EgJ7ZDKpdv/BNKIN1
         lLQ9czxz+kFJMnwN/pXXFe0zxvonl/pqUH48FLts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 5.19 07/21] ata: sata_mv: Fixes expected number of resources now IRQs are gone
Date:   Tue,  9 Aug 2022 20:00:59 +0200
Message-Id: <20220809175513.573942177@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175513.345597655@linuxfoundation.org>
References: <20220809175513.345597655@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

commit b3b2bec9646eb1d3f43c85f6d0d2211d6f8af42b upstream.

The commit a1a2b7125e10 ("of/platform: Drop static setup of IRQ
resource from DT core") stopped IRQ resources being available as
platform resources. This broke the sanity check for the expected
number of resources in the Marvell SATA driver which expected two
resources, the IO memory and the interrupt.

Change the sanity check to only expect the IO memory.

Cc: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Fixes: a1a2b7125e10 ("of/platform: Drop static setup of IRQ resource from DT core")
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/sata_mv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -4057,7 +4057,7 @@ static int mv_platform_probe(struct plat
 	/*
 	 * Simple resource validation ..
 	 */
-	if (unlikely(pdev->num_resources != 2)) {
+	if (unlikely(pdev->num_resources != 1)) {
 		dev_err(&pdev->dev, "invalid number of resources\n");
 		return -EINVAL;
 	}


