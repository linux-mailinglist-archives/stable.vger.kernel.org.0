Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50960553CDF
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355006AbiFUU4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 16:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354880AbiFUUz3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:55:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C2A2EA0A;
        Tue, 21 Jun 2022 13:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C88F4B81B2F;
        Tue, 21 Jun 2022 20:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DD6C3411C;
        Tue, 21 Jun 2022 20:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844586;
        bh=fhvJE/MOPjuPqFu5fB7/aejLFfTugL1Dz3jS91mlPco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pS7jK9SKJu/iUqcy3ZVB/MtA7IvOH4YeDUwzxIJ0AIxwFTLgACEy6kHbqWTvkd73j
         W6kTPXqfYXYVPpD1gag/XzWhINrMugtPAJ5q11a1dEp5VlfiWA7W7FfAABa3ztP3ax
         +BFLHcjFrDCQ3vzUVX8LXyoTZOcRw1jYjqeaz5yogSUVRnza1mjI2phwS3g9G25IIu
         znk9Dm1Smtjh3aI2mItCeenjMZAol6Or6HEOYd6xaTRtTRElXqOl6Cqh2QmFkFZ/h1
         NzCzT1yaW98GPyaTu/7tzjjNbitljpKI02PlpMkADjDxc9hOePD8gdaI9TGcfr/q5W
         xZMq3ZfHVN9Bw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brad Bishop <bradleyb@fuzziesquirrel.com>,
        Eddie James <eajames@linux.ibm.com>,
        Joel Stanley <joel@jms.id.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        andriy.shevchenko@linux.intel.com, keescook@chromium.org,
        christophe.leroy@csgroup.eu, ralph.siemsen@linaro.org,
        broonie@kernel.org
Subject: [PATCH AUTOSEL 5.18 05/22] eeprom: at25: Split reads into chunks and cap write size
Date:   Tue, 21 Jun 2022 16:49:11 -0400
Message-Id: <20220621204928.249907-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621204928.249907-1-sashal@kernel.org>
References: <20220621204928.249907-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Brad Bishop <bradleyb@fuzziesquirrel.com>

[ Upstream commit 0a35780c755ccec097d15c6b4ff8b246a89f1689 ]

Make use of spi_max_transfer_size to avoid requesting transfers that are
too large for some spi controllers.

Signed-off-by: Brad Bishop <bradleyb@fuzziesquirrel.com>
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20220524215142.60047-1-eajames@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/eeprom/at25.c | 93 ++++++++++++++++++++++----------------
 1 file changed, 53 insertions(+), 40 deletions(-)

diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index 8d169a35cf13..c9c56fd194c1 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -79,6 +79,11 @@ static int at25_ee_read(void *priv, unsigned int offset,
 {
 	struct at25_data *at25 = priv;
 	char *buf = val;
+	size_t max_chunk = spi_max_transfer_size(at25->spi);
+	size_t num_msgs = DIV_ROUND_UP(count, max_chunk);
+	size_t nr_bytes = 0;
+	unsigned int msg_offset;
+	size_t msg_count;
 	u8			*cp;
 	ssize_t			status;
 	struct spi_transfer	t[2];
@@ -92,54 +97,59 @@ static int at25_ee_read(void *priv, unsigned int offset,
 	if (unlikely(!count))
 		return -EINVAL;
 
-	cp = at25->command;
+	msg_offset = (unsigned int)offset;
+	msg_count = min(count, max_chunk);
+	while (num_msgs) {
+		cp = at25->command;
 
-	instr = AT25_READ;
-	if (at25->chip.flags & EE_INSTR_BIT3_IS_ADDR)
-		if (offset >= BIT(at25->addrlen * 8))
-			instr |= AT25_INSTR_BIT3;
+		instr = AT25_READ;
+		if (at25->chip.flags & EE_INSTR_BIT3_IS_ADDR)
+			if (msg_offset >= BIT(at25->addrlen * 8))
+				instr |= AT25_INSTR_BIT3;
 
-	mutex_lock(&at25->lock);
+		mutex_lock(&at25->lock);
 
-	*cp++ = instr;
-
-	/* 8/16/24-bit address is written MSB first */
-	switch (at25->addrlen) {
-	default:	/* case 3 */
-		*cp++ = offset >> 16;
-		fallthrough;
-	case 2:
-		*cp++ = offset >> 8;
-		fallthrough;
-	case 1:
-	case 0:	/* can't happen: for better code generation */
-		*cp++ = offset >> 0;
-	}
+		*cp++ = instr;
 
-	spi_message_init(&m);
-	memset(t, 0, sizeof(t));
+		/* 8/16/24-bit address is written MSB first */
+		switch (at25->addrlen) {
+		default:	/* case 3 */
+			*cp++ = msg_offset >> 16;
+			fallthrough;
+		case 2:
+			*cp++ = msg_offset >> 8;
+			fallthrough;
+		case 1:
+		case 0:	/* can't happen: for better code generation */
+			*cp++ = msg_offset >> 0;
+		}
 
-	t[0].tx_buf = at25->command;
-	t[0].len = at25->addrlen + 1;
-	spi_message_add_tail(&t[0], &m);
+		spi_message_init(&m);
+		memset(t, 0, sizeof(t));
 
-	t[1].rx_buf = buf;
-	t[1].len = count;
-	spi_message_add_tail(&t[1], &m);
+		t[0].tx_buf = at25->command;
+		t[0].len = at25->addrlen + 1;
+		spi_message_add_tail(&t[0], &m);
 
-	/*
-	 * Read it all at once.
-	 *
-	 * REVISIT that's potentially a problem with large chips, if
-	 * other devices on the bus need to be accessed regularly or
-	 * this chip is clocked very slowly.
-	 */
-	status = spi_sync(at25->spi, &m);
-	dev_dbg(&at25->spi->dev, "read %zu bytes at %d --> %zd\n",
-		count, offset, status);
+		t[1].rx_buf = buf + nr_bytes;
+		t[1].len = msg_count;
+		spi_message_add_tail(&t[1], &m);
 
-	mutex_unlock(&at25->lock);
-	return status;
+		status = spi_sync(at25->spi, &m);
+
+		mutex_unlock(&at25->lock);
+
+		if (status)
+			return status;
+
+		--num_msgs;
+		msg_offset += msg_count;
+		nr_bytes += msg_count;
+	}
+
+	dev_dbg(&at25->spi->dev, "read %zu bytes at %d\n",
+		count, offset);
+	return 0;
 }
 
 /* Read extra registers as ID or serial number */
@@ -190,6 +200,7 @@ ATTRIBUTE_GROUPS(sernum);
 static int at25_ee_write(void *priv, unsigned int off, void *val, size_t count)
 {
 	struct at25_data *at25 = priv;
+	size_t maxsz = spi_max_transfer_size(at25->spi);
 	const char *buf = val;
 	int			status = 0;
 	unsigned		buf_size;
@@ -253,6 +264,8 @@ static int at25_ee_write(void *priv, unsigned int off, void *val, size_t count)
 		segment = buf_size - (offset % buf_size);
 		if (segment > count)
 			segment = count;
+		if (segment > maxsz)
+			segment = maxsz;
 		memcpy(cp, buf, segment);
 		status = spi_write(at25->spi, bounce,
 				segment + at25->addrlen + 1);
-- 
2.35.1

