Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE6ED681037
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236686AbjA3OB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbjA3OBL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:01:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AEE3B65F
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:00:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DEC3B81154
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90666C433EF;
        Mon, 30 Jan 2023 14:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087248;
        bh=zbNyR9ac8AfycH562zqnh4RBySvQRr7fePuc6DUTXrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bv5SsslvFLfMCkk5yM9Cxva7ZwacsNiVjawepFvA3aYw6MdWuvHtI1TsJTwC4zb5f
         qxqGN2eR/BCXTjK/OjkyMQ8AT2HDQQ0CfiXi/+mTeB1DqVIGhArZH2vHC5ylYGsYU8
         QLEI5/j4DEPQdGfLT6GeD7IECX5po2Pd1KeAwIIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Witold Sadowski <wsadowski@marvell.com>,
        Chandrakala Chavva <cchavva@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 146/313] spi: cadence: Fix busy cycles calculation
Date:   Mon, 30 Jan 2023 14:49:41 +0100
Message-Id: <20230130134343.461266000@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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
2.39.0



