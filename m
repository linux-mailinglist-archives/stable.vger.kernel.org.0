Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B08B595069
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbiHPEmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbiHPEk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:40:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5393BD1E0E;
        Mon, 15 Aug 2022 13:33:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE7EFB80EA8;
        Mon, 15 Aug 2022 20:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B150C433C1;
        Mon, 15 Aug 2022 20:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595593;
        bh=imMcvGzzPpr3rWTwGM7Bb11ZJvZPVZIPQT6qdLY3okI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EZcHfPnHehCmb/JWChVOQtAmEEfKBuQBAOAse0mjL7Wlk/b0p9WMafEABatFkAi4f
         Q+3cDCUfWf2QWxriJ3WQvVsy3vAFJAR50KnUa6rlXdPi5PRXxHI3L0L0soACM6ueju
         Lbqhm+KusO5Ghhvv8LhWdNHvlLrOBUWXRTLgy3N0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Serge Semin <fancer.lancer@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0813/1157] eeprom: idt_89hpesx: uninitialized data in idt_dbgfs_csr_write()
Date:   Mon, 15 Aug 2022 20:02:49 +0200
Message-Id: <20220815180512.019919000@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 71d46f1ff2212ced4852c7e77c5176382a1bdcec ]

The simple_write_to_buffer() function will return positive/success if it
is able to write a single byte anywhere within the buffer.  However that
potentially leaves a lot of the buffer uninitialized.

In this code it's better to return 0 if the offset is non-zero.  This
code is not written to support partial writes.  And then return -EFAULT
if the buffer is not completely initialized.

Fixes: cfad6425382e ("eeprom: Add IDT 89HPESx EEPROM/CSR driver")
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/Ysg1Pu/nzSMe3r1q@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/eeprom/idt_89hpesx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/eeprom/idt_89hpesx.c b/drivers/misc/eeprom/idt_89hpesx.c
index b0cff4b152da..7f430742ce2b 100644
--- a/drivers/misc/eeprom/idt_89hpesx.c
+++ b/drivers/misc/eeprom/idt_89hpesx.c
@@ -909,14 +909,18 @@ static ssize_t idt_dbgfs_csr_write(struct file *filep, const char __user *ubuf,
 	u32 csraddr, csrval;
 	char *buf;
 
+	if (*offp)
+		return 0;
+
 	/* Copy data from User-space */
 	buf = kmalloc(count + 1, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-	ret = simple_write_to_buffer(buf, count, offp, ubuf, count);
-	if (ret < 0)
+	if (copy_from_user(buf, ubuf, count)) {
+		ret = -EFAULT;
 		goto free_buf;
+	}
 	buf[count] = 0;
 
 	/* Find position of colon in the buffer */
-- 
2.35.1



