Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F3E579E2B
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242412AbiGSM6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242490AbiGSM6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:58:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97985D5A0;
        Tue, 19 Jul 2022 05:23:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FDFF618F1;
        Tue, 19 Jul 2022 12:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5097BC341C6;
        Tue, 19 Jul 2022 12:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233402;
        bh=C35YW5OGVExMjOSZqjrwbAh058nF7suNo+uXffy0b2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oGb2d8dtSizYvw7bbRtfARZucSeOHf94T871pWz8887QdqX4tPSonk4f/0eLU8E3b
         Wa+VSsBeiJ/9vo7NLnIPm75PVkgXmp74EkBkl7s9pCTHZQylaEAzz37r5EYvmsTZw+
         Au3k9SCcDiydpNw1lJPYwYE0dccm5WxxEjrU47KI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 110/231] sysctl: Fix data-races in proc_dointvec_ms_jiffies().
Date:   Tue, 19 Jul 2022 13:53:15 +0200
Message-Id: <20220719114723.838662068@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 7d1025e559782b58824b36cb8ad547a69f2e4b31 ]

A sysctl variable is accessed concurrently, and there is always a chance
of data-race.  So, all readers and writers need some basic protection to
avoid load/store-tearing.

This patch changes proc_dointvec_ms_jiffies() to use READ_ONCE() and
WRITE_ONCE() internally to fix data-races on the sysctl side.  For now,
proc_dointvec_ms_jiffies() itself is tolerant to a data-race, but we still
need to add annotations on the other subsystem's side.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sysctl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 54ec36e69907..f165ea67dd33 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1296,9 +1296,9 @@ static int do_proc_dointvec_ms_jiffies_conv(bool *negp, unsigned long *lvalp,
 
 		if (jif > INT_MAX)
 			return 1;
-		*valp = (int)jif;
+		WRITE_ONCE(*valp, (int)jif);
 	} else {
-		int val = *valp;
+		int val = READ_ONCE(*valp);
 		unsigned long lval;
 		if (val < 0) {
 			*negp = true;
@@ -1366,8 +1366,8 @@ int proc_dointvec_userhz_jiffies(struct ctl_table *table, int write,
  * @ppos: the current position in the file
  *
  * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
- * values from/to the user buffer, treated as an ASCII string. 
- * The values read are assumed to be in 1/1000 seconds, and 
+ * values from/to the user buffer, treated as an ASCII string.
+ * The values read are assumed to be in 1/1000 seconds, and
  * are converted into jiffies.
  *
  * Returns 0 on success.
-- 
2.35.1



