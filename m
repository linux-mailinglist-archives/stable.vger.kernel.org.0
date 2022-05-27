Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C88535F81
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351442AbiE0LjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351542AbiE0LiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:38:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD676131F1D;
        Fri, 27 May 2022 04:38:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35E2861CE7;
        Fri, 27 May 2022 11:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46974C385A9;
        Fri, 27 May 2022 11:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651491;
        bh=tRdguKMsCMb3cgWGW47OTk5Q8fgyO7J3GqqlMWdLRDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KCFRwMZsUmJcR4f8A7+fhzrNGyj6jAn9JSGD0d7NklE6qTzQTPw2wYHxx7ZetR6t4
         ROoTQMxSFro7xbqPaLXmgLCdcDMl3AnDrSWjjW7fhG54NKHTPAlxmgDOgrs/cDrBI/
         fGz1lUT6k9SNiCK/rpoXuwwXmNeYLa5FvGTgLMgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.17 050/111] random: dont let 644 read-only sysctls be written to
Date:   Fri, 27 May 2022 10:49:22 +0200
Message-Id: <20220527084826.508704032@linuxfoundation.org>
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
 static struct ctl_table random_table[] = {
 	{
 		.procname	= "poolsize",
@@ -1689,14 +1696,14 @@ static struct ctl_table random_table[] =
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


