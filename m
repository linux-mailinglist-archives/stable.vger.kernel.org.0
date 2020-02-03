Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90EA5150C69
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730793AbgBCQgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:36:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731121AbgBCQgE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:36:04 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2DEE20CC7;
        Mon,  3 Feb 2020 16:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747764;
        bh=9KeJ7yaCGgNg9PgIAjp8U+LArV2ZV5IqK5631pvuGiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zLc+/iFdQ435Wy4S/DOa3qEM3Y3w6sWDFUusIYNucSXAKabRMWVh0p+yQhzPIHrUG
         +XiJ/2DOOoZXj9igUPxp2A7NBmM2c0jom6x8KdQEOjoy4vi2Euau45+XLduifJu66z
         QQgFpOkecoeCp99rJiscdla7olnEJ2uR+Win1+zY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+efea72d4a0a1d03596cd@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 5.4 20/90] tomoyo: Use atomic_t for statistics counter
Date:   Mon,  3 Feb 2020 16:19:23 +0000
Message-Id: <20200203161920.345794713@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit a8772fad0172aeae339144598b809fd8d4823331 upstream.

syzbot is reporting that there is a race at tomoyo_stat_update() [1].
Although it is acceptable to fail to track exact number of times policy
was updated, convert to atomic_t because this is not a hot path.

[1] https://syzkaller.appspot.com/bug?id=a4d7b973972eeed410596e6604580e0133b0fc04

Reported-by: syzbot <syzbot+efea72d4a0a1d03596cd@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/tomoyo/common.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -2322,9 +2322,9 @@ static const char * const tomoyo_memory_
 	[TOMOYO_MEMORY_QUERY]  = "query message:",
 };
 
-/* Timestamp counter for last updated. */
-static unsigned int tomoyo_stat_updated[TOMOYO_MAX_POLICY_STAT];
 /* Counter for number of updates. */
+static atomic_t tomoyo_stat_updated[TOMOYO_MAX_POLICY_STAT];
+/* Timestamp counter for last updated. */
 static time64_t tomoyo_stat_modified[TOMOYO_MAX_POLICY_STAT];
 
 /**
@@ -2336,10 +2336,7 @@ static time64_t tomoyo_stat_modified[TOM
  */
 void tomoyo_update_stat(const u8 index)
 {
-	/*
-	 * I don't use atomic operations because race condition is not fatal.
-	 */
-	tomoyo_stat_updated[index]++;
+	atomic_inc(&tomoyo_stat_updated[index]);
 	tomoyo_stat_modified[index] = ktime_get_real_seconds();
 }
 
@@ -2360,7 +2357,7 @@ static void tomoyo_read_stat(struct tomo
 	for (i = 0; i < TOMOYO_MAX_POLICY_STAT; i++) {
 		tomoyo_io_printf(head, "Policy %-30s %10u",
 				 tomoyo_policy_headers[i],
-				 tomoyo_stat_updated[i]);
+				 atomic_read(&tomoyo_stat_updated[i]));
 		if (tomoyo_stat_modified[i]) {
 			struct tomoyo_time stamp;
 


