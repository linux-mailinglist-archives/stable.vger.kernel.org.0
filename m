Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F4455815B
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiFWQ7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbiFWQ5m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:57:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FD84D63C;
        Thu, 23 Jun 2022 09:53:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C448461FC2;
        Thu, 23 Jun 2022 16:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5DDC3411B;
        Thu, 23 Jun 2022 16:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003196;
        bh=7430oTTUQqiKv+OG9VsykxknV6Vufulp3bf/aPDVebo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lq4HnZg7vg6i7LBx2YR2wj65x1gvVpJ7mPeo5FVjlcJTyurZsDYvTvgLHOPU5BpNm
         F6nXrqjpSduMyexp3htlBRAJ0oxhee9ntH3WYxRY2IcKe+mXSpSGaNiP4iaL2jBA+v
         TAQFhdpA00mqrOckU7QOJQBJt0rBBxo4uN7/jYmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 160/264] random: dont let 644 read-only sysctls be written to
Date:   Thu, 23 Jun 2022 18:42:33 +0200
Message-Id: <20220623164348.589759301@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 77553cf8f44863b31da242cf24671d76ddb61597 upstream.

We leave around these old sysctls for compatibility, and we keep them
"writable" for compatibility, but even after writing, we should keep
reporting the same value. This is consistent with how userspaces tend to
use sysctl_random_write_wakeup_bits, writing to it, and then later
reading from it and using the value.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1663,6 +1663,13 @@ static int proc_do_uuid(struct ctl_table
 	return proc_dostring(&fake_table, 0, buffer, lenp, ppos);
 }
 
+/* The same as proc_dointvec, but writes don't change anything. */
+static int proc_do_rointvec(struct ctl_table *table, int write, void __user *buffer,
+			    size_t *lenp, loff_t *ppos)
+{
+	return write ? 0 : proc_dointvec(table, 0, buffer, lenp, ppos);
+}
+
 extern struct ctl_table random_table[];
 struct ctl_table random_table[] = {
 	{
@@ -1684,14 +1691,14 @@ struct ctl_table random_table[] = {
 		.data		= &sysctl_random_write_wakeup_bits,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_do_rointvec,
 	},
 	{
 		.procname	= "urandom_min_reseed_secs",
 		.data		= &sysctl_random_min_urandom_seed,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_do_rointvec,
 	},
 	{
 		.procname	= "boot_id",


