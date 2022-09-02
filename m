Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEAE5AB0BA
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238063AbiIBM5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238240AbiIBM4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:56:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F1820F5C;
        Fri,  2 Sep 2022 05:39:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D32C620FE;
        Fri,  2 Sep 2022 12:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB69C433D7;
        Fri,  2 Sep 2022 12:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121480;
        bh=0VtpXqFvjdzolSkUYnkn3ks1g0xBS+pk9oJcQgLaFCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zDhL7TfXn1V6wmU4MH6DCIvp8qjaooqj+MKMJIr+gTKBsQZfKpaeDy/pOiZhO+aLw
         qMgob9QzcwrtTueMtqRI6S3QRGZHyrYZgejJx4Zn6LmLwy48AX516ACrTFG5wOYwc6
         A+TBI/2rjAW+jNFxuI/FZa60WmUBT99Fp0/99VGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 21/56] ratelimit: Fix data-races in ___ratelimit().
Date:   Fri,  2 Sep 2022 14:18:41 +0200
Message-Id: <20220902121400.922441166@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121400.219861128@linuxfoundation.org>
References: <20220902121400.219861128@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 6bae8ceb90ba76cdba39496db936164fa672b9be ]

While reading rs->interval and rs->burst, they can be changed
concurrently via sysctl (e.g. net_ratelimit_state).  Thus, we
need to add READ_ONCE() to their readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/ratelimit.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/lib/ratelimit.c b/lib/ratelimit.c
index d01f471352390..b805702de84dd 100644
--- a/lib/ratelimit.c
+++ b/lib/ratelimit.c
@@ -27,10 +27,16 @@
  */
 int ___ratelimit(struct ratelimit_state *rs, const char *func)
 {
+	/* Paired with WRITE_ONCE() in .proc_handler().
+	 * Changing two values seperately could be inconsistent
+	 * and some message could be lost.  (See: net_ratelimit_state).
+	 */
+	int interval = READ_ONCE(rs->interval);
+	int burst = READ_ONCE(rs->burst);
 	unsigned long flags;
 	int ret;
 
-	if (!rs->interval)
+	if (!interval)
 		return 1;
 
 	/*
@@ -45,7 +51,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
 	if (!rs->begin)
 		rs->begin = jiffies;
 
-	if (time_is_before_jiffies(rs->begin + rs->interval)) {
+	if (time_is_before_jiffies(rs->begin + interval)) {
 		if (rs->missed) {
 			if (!(rs->flags & RATELIMIT_MSG_ON_RELEASE)) {
 				printk_deferred(KERN_WARNING
@@ -57,7 +63,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
 		rs->begin   = jiffies;
 		rs->printed = 0;
 	}
-	if (rs->burst && rs->burst > rs->printed) {
+	if (burst && burst > rs->printed) {
 		rs->printed++;
 		ret = 1;
 	} else {
-- 
2.35.1



