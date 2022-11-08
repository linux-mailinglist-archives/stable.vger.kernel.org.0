Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E9E621311
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbiKHNqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:46:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234524AbiKHNqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:46:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0C05986D
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:46:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EF2FB81AEE
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73BBC433C1;
        Tue,  8 Nov 2022 13:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915168;
        bh=qBov9fG66/qTE/IoGCpz8o8d2PkOzUe+S1cyvVcpNdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nrkm/RFaSx45ukwoIG8oqRxzkPp6VBddR8gHq82lY60suDOYKaNh+mLoINCBAt4i1
         Yr57gtV51zQwbOJ75mnqKalAuqdUcwO6KKJlEgzkQ8jpwZwAjS/Biz8dRhbFCkmyuq
         35WJDGRpcaaXhSn+rYepxNfmKMifn1UVAoiqH1h0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/48] ata: pata_legacy: fix pdc20230_set_piomode()
Date:   Tue,  8 Nov 2022 14:38:54 +0100
Message-Id: <20221108133329.860648526@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133329.533809494@linuxfoundation.org>
References: <20221108133329.533809494@linuxfoundation.org>
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
index 52cea1b3ea70..591778024054 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -292,9 +292,10 @@ static void pdc20230_set_piomode(struct ata_port *ap, struct ata_device *adev)
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



