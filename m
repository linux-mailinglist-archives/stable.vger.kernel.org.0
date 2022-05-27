Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5F0535F70
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346408AbiE0Lhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345594AbiE0Lhm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:37:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738066540C;
        Fri, 27 May 2022 04:37:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC9D761CE2;
        Fri, 27 May 2022 11:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0485DC34113;
        Fri, 27 May 2022 11:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651452;
        bh=amemK8Q9YbQzV/hIYUpP+5+ychYfZ9KcS9kDPk/te5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIuoGKPcsD4I0+vMHmg/YpdHDERhXAFnOxsdkwULULHPCNVCbHHdDEMS2wsldx311
         iTVWwljACoWNI2JC8Kwt5OMvNcpzJ31WgHPktDXNxWp/iLIOFCi9PnpqKk8RqOptqK
         NAGtTAlZmgSJGMuA09uZNtGg8EnGx3OR6NXbYADo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.17 046/111] random: cleanup UUID handling
Date:   Fri, 27 May 2022 10:49:18 +0200
Message-Id: <20220527084825.965332823@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084819.133490171@linuxfoundation.org>
References: <20220527084819.133490171@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 64276a9939ff414f2f0db38036cf4e1a0a703394 upstream.

Rather than hard coding various lengths, we can use the right constants.
Strings should be `char *` while buffers should be `u8 *`. Rather than
have a nonsensical and unused maxlength, just remove it. Finally, use
snprintf instead of sprintf, just out of good hygiene.

As well, remove the old comment about returning a binary UUID via the
binary sysctl syscall. That syscall was removed from the kernel in 5.5,
and actually, the "uuid_strategy" function and related infrastructure
for even serving it via the binary sysctl syscall was removed with
894d2491153a ("sysctl drivers: Remove dead binary sysctl support") back
in 2.6.33.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1661,22 +1661,25 @@ const struct file_operations urandom_fop
 static int sysctl_random_min_urandom_seed = 60;
 static int sysctl_random_write_wakeup_bits = POOL_MIN_BITS;
 static int sysctl_poolsize = POOL_BITS;
-static char sysctl_bootid[16];
+static u8 sysctl_bootid[UUID_SIZE];
 
 /*
  * This function is used to return both the bootid UUID, and random
- * UUID.  The difference is in whether table->data is NULL; if it is,
+ * UUID. The difference is in whether table->data is NULL; if it is,
  * then a new UUID is generated and returned to the user.
- *
- * If the user accesses this via the proc interface, the UUID will be
- * returned as an ASCII string in the standard UUID format; if via the
- * sysctl system call, as 16 bytes of binary data.
  */
 static int proc_do_uuid(struct ctl_table *table, int write, void *buffer,
 			size_t *lenp, loff_t *ppos)
 {
-	struct ctl_table fake_table;
-	unsigned char buf[64], tmp_uuid[16], *uuid;
+	u8 tmp_uuid[UUID_SIZE], *uuid;
+	char uuid_string[UUID_STRING_LEN + 1];
+	struct ctl_table fake_table = {
+		.data = uuid_string,
+		.maxlen = UUID_STRING_LEN
+	};
+
+	if (write)
+		return -EPERM;
 
 	uuid = table->data;
 	if (!uuid) {
@@ -1691,12 +1694,8 @@ static int proc_do_uuid(struct ctl_table
 		spin_unlock(&bootid_spinlock);
 	}
 
-	sprintf(buf, "%pU", uuid);
-
-	fake_table.data = buf;
-	fake_table.maxlen = sizeof(buf);
-
-	return proc_dostring(&fake_table, write, buffer, lenp, ppos);
+	snprintf(uuid_string, sizeof(uuid_string), "%pU", uuid);
+	return proc_dostring(&fake_table, 0, buffer, lenp, ppos);
 }
 
 static struct ctl_table random_table[] = {
@@ -1731,13 +1730,11 @@ static struct ctl_table random_table[] =
 	{
 		.procname	= "boot_id",
 		.data		= &sysctl_bootid,
-		.maxlen		= 16,
 		.mode		= 0444,
 		.proc_handler	= proc_do_uuid,
 	},
 	{
 		.procname	= "uuid",
-		.maxlen		= 16,
 		.mode		= 0444,
 		.proc_handler	= proc_do_uuid,
 	},


