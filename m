Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9752C5583A9
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbiFWRdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234471AbiFWRcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:32:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC0C86AC3;
        Thu, 23 Jun 2022 10:05:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FFB3B82499;
        Thu, 23 Jun 2022 17:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF622C3411B;
        Thu, 23 Jun 2022 17:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003927;
        bh=fBU7IPs0E+Na+OQLrUJRsGKxqjI7vklE+yq1nJxbwYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZBGrqn/QVyUNQx5MsukRs4s+7Yy3mhskyRqtgVPjL9dp4xtVJguAS5kr5E5zh/KZ
         /kbWLBlp0hXQdq3Z/PvTLXNLZLwFFMOJfrL2XV4zFHTl5++bFZRo1WDJ+YZICxmYuo
         7quCCAyRNuf+5jHEJuv3wUDFGBNeA3RdivkQ33hQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 130/237] random: dont let 644 read-only sysctls be written to
Date:   Thu, 23 Jun 2022 18:42:44 +0200
Message-Id: <20220623164346.894479540@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
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
@@ -1662,6 +1662,13 @@ static int proc_do_uuid(struct ctl_table
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
@@ -1683,14 +1690,14 @@ struct ctl_table random_table[] = {
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


