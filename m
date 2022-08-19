Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDB859A1E3
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352378AbiHSQWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352455AbiHSQVA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:21:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C851CFCC;
        Fri, 19 Aug 2022 09:02:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06B1261644;
        Fri, 19 Aug 2022 16:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98C6C433D6;
        Fri, 19 Aug 2022 16:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924931;
        bh=K3jT4bpSWHks/tue1hf72aNqnJ+kaIVlkiqmYAbEJuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJ8MOk8WV2wFT8V8/hV35Jwr5jofs1LTGwpLcvSoFFzMreJtESFkHk/dSf8BFgViD
         2NtVlnNWOEvh4owOTxlGg5GI6vNvt1GSz9UQzCC1JxZr54HEy9i7zo15m2fnTNUFcp
         KVF5fFqt0pPCvEjlzyTOTWm3zfmbI8tEYMz3XuL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Serge Semin <fancer.lancer@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 329/545] eeprom: idt_89hpesx: uninitialized data in idt_dbgfs_csr_write()
Date:   Fri, 19 Aug 2022 17:41:39 +0200
Message-Id: <20220819153844.096017262@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index 3e4a594c110b..6a456645efb0 100644
--- a/drivers/misc/eeprom/idt_89hpesx.c
+++ b/drivers/misc/eeprom/idt_89hpesx.c
@@ -940,14 +940,18 @@ static ssize_t idt_dbgfs_csr_write(struct file *filep, const char __user *ubuf,
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



