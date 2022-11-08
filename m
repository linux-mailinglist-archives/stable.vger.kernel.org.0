Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBDB162152E
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235062AbiKHOJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235119AbiKHOJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:09:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367B06322
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:09:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1E27615B2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0521C433D6;
        Tue,  8 Nov 2022 14:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916544;
        bh=IG2CQrHAKAY0O5MJUhJv3V6gqN1X3d0MvlONJSSubM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCfEL/uRprq3tLFBHaGYokTBLjlCiA2ofZu+w3/tNBrd8nwvtH9Wq5loALbgt1akc
         fq73PF7HPLyyiUNlq39elutf5yh+LKF6JCfjviu6N2/38egy/oKp5qrpmnGQI+jSoK
         ob2URCbDLud7U2+YszJJQsmq3uQiBu6ah4qoUJyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 026/197] ata: pata_legacy: fix pdc20230_set_piomode()
Date:   Tue,  8 Nov 2022 14:37:44 +0100
Message-Id: <20221108133355.979253899@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit 171a93182eccd6e6835d2c86b40787f9f832efaa ]

Clang gives a warning when compiling pata_legacy.c with 'make W=1' about
the 'rt' local variable in pdc20230_set_piomode() being set but unused.
Quite obviously, there is an outb() call missing to write back the updated
variable. Moreover, checking the docs by Petr Soucek revealed that bitwise
AND should have been done with a negated timing mask and the master/slave
timing masks were swapped while updating...

Fixes: 669a5db411d8 ("[libata] Add a bunch of PATA drivers.")
Reported-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_legacy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 0a8bf09a5c19..03c580625c2c 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -315,9 +315,10 @@ static void pdc20230_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	outb(inb(0x1F4) & 0x07, 0x1F4);
 
 	rt = inb(0x1F3);
-	rt &= 0x07 << (3 * adev->devno);
+	rt &= ~(0x07 << (3 * !adev->devno));
 	if (pio)
-		rt |= (1 + 3 * pio) << (3 * adev->devno);
+		rt |= (1 + 3 * pio) << (3 * !adev->devno);
+	outb(rt, 0x1F3);
 
 	udelay(100);
 	outb(inb(0x1F2) | 0x01, 0x1F2);
-- 
2.35.1



