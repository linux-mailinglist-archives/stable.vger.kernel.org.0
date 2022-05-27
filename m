Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F032C536187
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352070AbiE0L45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352733AbiE0Lzi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:55:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1097F14B67F;
        Fri, 27 May 2022 04:49:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F6C0B824CA;
        Fri, 27 May 2022 11:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB40CC385A9;
        Fri, 27 May 2022 11:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652139;
        bh=112rpqfBHZG5Knz4Q5D4qmKKkDWxTkkyP+SwPAWWXkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RTQ+9cjM+XQAd3Kgnv7RxPu6G5FdYtulZDil1QQvhYNlnYs8A/tzSQXDNTp3kbFgB
         Y76v2jtlTmS4qnkqwdYbNDCw3vrCE3GyIM/xnBR0VbzS8bo3tO/GoaYOZYtPUM03+w
         DHlo1P0bQAv4bJ3cZJquJNc4YCCYUXWww6wHF6qI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 103/163] random: dont let 644 read-only sysctls be written to
Date:   Fri, 27 May 2022 10:49:43 +0200
Message-Id: <20220527084842.344288009@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
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
@@ -1669,6 +1669,13 @@ static int proc_do_uuid(struct ctl_table
 	return proc_dostring(&fake_table, 0, buffer, lenp, ppos);
 }
 
+/* The same as proc_dointvec, but writes don't change anything. */
+static int proc_do_rointvec(struct ctl_table *table, int write, void *buffer,
+			    size_t *lenp, loff_t *ppos)
+{
+	return write ? 0 : proc_dointvec(table, 0, buffer, lenp, ppos);
+}
+
 extern struct ctl_table random_table[];
 struct ctl_table random_table[] = {
 	{
@@ -1690,14 +1697,14 @@ struct ctl_table random_table[] = {
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


