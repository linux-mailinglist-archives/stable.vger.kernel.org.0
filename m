Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DEA6B0583
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 12:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjCHLKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 06:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjCHLKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 06:10:40 -0500
X-Greylist: delayed 601 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 08 Mar 2023 03:10:31 PST
Received: from sym2.noone.org (sym.noone.org [178.63.92.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C969F058;
        Wed,  8 Mar 2023 03:10:30 -0800 (PST)
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 4PWpyk2zyFzvjfm; Wed,  8 Mar 2023 11:51:26 +0100 (CET)
From:   Tobias Klauser <tklauser@distanz.ch>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrei Vagin <avagin@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] fork: allow CLONE_NEWTIME in clone3 flags
Date:   Wed,  8 Mar 2023 11:51:26 +0100
Message-Id: <20230308105126.10107-1-tklauser@distanz.ch>
X-Mailer: git-send-email 2.11.0
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, calling clone3() with CLONE_NEWTIME in clone_args->flags
fails with -EINVAL. This is because CLONE_NEWTIME intersects with
CSIGNAL. However, CSIGNAL was deprecated when clone3 was introduced in
commit 7f192e3cd316 ("fork: add clone3"), allowing re-use of that part
of clone flags.

Fix this by explicitly allowing CLONE_NEWTIME in clone3_args_valid. This
is also in line with the respective check in check_unshare_flags which
allow CLONE_NEWTIME for unshare().

Fixes: 769071ac9f20 ("ns: Introduce Time Namespace")
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 kernel/fork.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index f68954d05e89..d8cda4c6de6c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2936,7 +2936,7 @@ static bool clone3_args_valid(struct kernel_clone_args *kargs)
 	 * - make the CLONE_DETACHED bit reusable for clone3
 	 * - make the CSIGNAL bits reusable for clone3
 	 */
-	if (kargs->flags & (CLONE_DETACHED | CSIGNAL))
+	if (kargs->flags & (CLONE_DETACHED | (CSIGNAL & (~CLONE_NEWTIME))))
 		return false;
 
 	if ((kargs->flags & (CLONE_SIGHAND | CLONE_CLEAR_SIGHAND)) ==
-- 
2.39.1

