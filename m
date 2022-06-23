Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD8D55805E
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbiFWQqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232450AbiFWQqL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:46:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62AF648899;
        Thu, 23 Jun 2022 09:46:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED52761F99;
        Thu, 23 Jun 2022 16:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2B9C3411B;
        Thu, 23 Jun 2022 16:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002766;
        bh=zfjYakhufALYOcCw1/8OMrfMmpo4S54sJyp1TLq0JQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJRTnd3kWZgHeyzyXfJ1k+BhignxF2tnOlsRpCUIgY8kOQGe8rxXbMAwV6nRggC7k
         B8AvFIf1NTWBeC1t3ipD4ZTipqmoXZ8f3i1i1SVjfSy//OAgxAT/SUePuUtdfRi6np
         taN0yfkPSvSQwJwgVdmbAz4tNTm83uFn7J94HhyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot+9de458f6a5e713ee8c1a@syzkaller.appspotmail.com,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.9 019/264] random: fix possible sleeping allocation from irq context
Date:   Thu, 23 Jun 2022 18:40:12 +0200
Message-Id: <20220623164344.609507273@linuxfoundation.org>
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

From: Theodore Ts'o <tytso@mit.edu>

commit 6c1e851c4edc13a43adb3ea4044e3fc8f43ccf7d upstream.

We can do a sleeping allocation from an irq context when CONFIG_NUMA
is enabled.  Fix this by initializing the NUMA crng instances in a
workqueue.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: syzbot+9de458f6a5e713ee8c1a@syzkaller.appspotmail.com
Fixes: 8ef35c866f8862df ("random: set up the NUMA crng instances...")
Cc: stable@vger.kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -800,7 +800,7 @@ static void crng_initialize(struct crng_
 }
 
 #ifdef CONFIG_NUMA
-static void numa_crng_init(void)
+static void do_numa_crng_init(struct work_struct *work)
 {
 	int i;
 	struct crng_state *crng;
@@ -821,6 +821,13 @@ static void numa_crng_init(void)
 		kfree(pool);
 	}
 }
+
+static DECLARE_WORK(numa_crng_init_work, do_numa_crng_init);
+
+static void numa_crng_init(void)
+{
+	schedule_work(&numa_crng_init_work);
+}
 #else
 static void numa_crng_init(void) {}
 #endif


