Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47FED59379C
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245481AbiHOTXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344772AbiHOTVi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:21:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7673C326D2;
        Mon, 15 Aug 2022 11:40:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D810B8108E;
        Mon, 15 Aug 2022 18:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE69C433D6;
        Mon, 15 Aug 2022 18:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588826;
        bh=imMcvGzzPpr3rWTwGM7Bb11ZJvZPVZIPQT6qdLY3okI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QgGRwVDaooqf8DiQKtQYlFkuAJuL6t/Idse9qy1MRDyQ7y2wausnk0x32go4XpQED
         hIZ1HprnyPbUvVVTyXp+SABhlabQ4B8PmkOEyu+nql4RPgrob0WaE8APq90Bt7/GNY
         i34bb0pDmLfR2SRz5gxU1E6oSPCkTqIHZpz+oUtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Serge Semin <fancer.lancer@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 495/779] eeprom: idt_89hpesx: uninitialized data in idt_dbgfs_csr_write()
Date:   Mon, 15 Aug 2022 20:02:19 +0200
Message-Id: <20220815180358.445525049@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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



