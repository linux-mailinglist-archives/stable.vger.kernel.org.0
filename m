Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABCCE66C090
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbjAPOCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbjAPOCQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:02:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2A62201C;
        Mon, 16 Jan 2023 06:02:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AD8460FCC;
        Mon, 16 Jan 2023 14:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125DEC433F1;
        Mon, 16 Jan 2023 14:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877728;
        bh=m72/lmeDWoeurM8J6PdzApB0o2AteNM4N6zXSwPK74Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DphgzQp2SLZCQAh5VbCQYAdaRuui+anOrKlOwHtUS/Oo5NJgxHFx4NIY/UC58smV4
         QywUQVb1Rm7Lya8IjN+QDTIgwlIOB+EAwXKK3xyn1UNbzRgN+CmPEk+4WAPPytUJgQ
         qM8YhfJCDnewPVVlw+j2it4B4M+LWG71PKTAvdYZLbt9nyx07B0MwgIownKmKOG1Gu
         4pjtF9a1x1a4/aYIZ+f2NH+shZ6J/RnEorq9l6Lx/32oR+VX/9nplLsc8VLSXvP2iV
         7FjvSN0bCou1gVILNj42G7ZIZQ79lprProNNyBaZ5rjfdMhjoRXNHKxd2Kyq0FIt45
         COmLIEWWtKTRQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Witold Sadowski <wsadowski@marvell.com>,
        Chandrakala Chavva <cchavva@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 06/53] spi: cadence: Fix busy cycles calculation
Date:   Mon, 16 Jan 2023 09:01:06 -0500
Message-Id: <20230116140154.114951-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Witold Sadowski <wsadowski@marvell.com>

[ Upstream commit e8bb8f19e73a1e855e54788f8673b9b49e46b5cd ]

If xSPI is in x2/x4/x8 mode to calculate busy
cycles, busy bits count must be divided by the number
of lanes.
If opcommand is using 8 busy bits, but SPI is
in x4 mode, there will be only 2 busy cycles.

Signed-off-by: Witold Sadowski <wsadowski@marvell.com>
Reviewed-by: Chandrakala Chavva <cchavva@marvell.com>
Reviewed-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Link: https://lore.kernel.org/r/20221219144254.20883-2-wsadowski@marvell.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-xspi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-cadence-xspi.c b/drivers/spi/spi-cadence-xspi.c
index 9e187f9c6c95..d28b8bd5b70b 100644
--- a/drivers/spi/spi-cadence-xspi.c
+++ b/drivers/spi/spi-cadence-xspi.c
@@ -177,7 +177,10 @@
 #define CDNS_XSPI_CMD_FLD_DSEQ_CMD_3(op) ( \
 	FIELD_PREP(CDNS_XSPI_CMD_DSEQ_R3_DCNT_H, \
 		((op)->data.nbytes >> 16) & 0xffff) | \
-	FIELD_PREP(CDNS_XSPI_CMD_DSEQ_R3_NUM_OF_DUMMY, (op)->dummy.nbytes * 8))
+	FIELD_PREP(CDNS_XSPI_CMD_DSEQ_R3_NUM_OF_DUMMY, \
+		  (op)->dummy.buswidth != 0 ? \
+		  (((op)->dummy.nbytes * 8) / (op)->dummy.buswidth) : \
+		  0))
 
 #define CDNS_XSPI_CMD_FLD_DSEQ_CMD_4(op, chipsel) ( \
 	FIELD_PREP(CDNS_XSPI_CMD_DSEQ_R4_BANK, chipsel) | \
-- 
2.35.1

