Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083606BE13C
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 07:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjCQG2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 02:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjCQG2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 02:28:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EE74D2AB
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 23:28:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D3A29CE1F55
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 06:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7228C433D2;
        Fri, 17 Mar 2023 06:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679034488;
        bh=2SxOdzm+r3/sPGp8ge5VqXjBoGywFgq+J+bF4fiT+9g=;
        h=From:To:Cc:Subject:Date:From;
        b=S5Y7ErLY7iKaRCzRLtpCdaWalRCgqodMisu1pTjrAdKLvnZDcaf/WXovvkUDmHQMo
         VDu+8gyhtmJEKqGD291pOiwzJuoA7q1c2t/R8EuR5ne0jxyyhiPl8lMPCfK2Wz5nGM
         PIYbp443w6HzWGomEzRXWbzZbyI21m9CmJ/p3rYU7PP52M7NJQ4OqiztE+ZIG26aFX
         gQta0rYAsIvSNFKdIge03+2nFg8qD8DQHbctwUnN8iL589+31NG6xV7l2RI6xka/ZM
         gqrSMQZXZwMPq5dBuhknmooOaQhrdY6mjKd31uCO76ykje3zexTyjC+Uqs5CLuQGbi
         B/A8wcylTOWsQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     Joe Perches <joe@perches.com>, Lucas Wei <lucaswei@google.com>,
        linux-mm@kvack.org, kernel test robot <yujie.liu@intel.com>
Subject: [PATCH 4.14] fs: sysfs_emit_at: Remove PAGE_SIZE alignment check
Date:   Thu, 16 Mar 2023 23:28:01 -0700
Message-Id: <20230317062801.313217-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[No upstream commit because this fixes a bug in a backport.]

Before upstream commit 59bb47985c1d ("mm, sl[aou]b: guarantee natural
alignment for kmalloc(power-of-two)") which went into v5.4, kmalloc did
*not* always guarantee that PAGE_SIZE allocations are PAGE_SIZE-aligned.

Upstream commit 2efc459d06f1 ("sysfs: Add sysfs_emit and sysfs_emit_at
to format sysfs output") added two WARN()s that trigger when PAGE_SIZE
allocations are not PAGE_SIZE-aligned.  This was backported to old
kernels that don't guarantee PAGE_SIZE alignment.

Commit 10ddfb495232 ("fs: sysfs_emit: Remove PAGE_SIZE alignment check")
in 4.19.y, and its equivalent in 4.14.y and 4.9.y, tried to fix this
bug.  However, only it handled sysfs_emit(), not sysfs_emit_at().

Fix it in sysfs_emit_at() too.

A reproducer is to build the kernel with the following options:

	CONFIG_SLUB=y
	CONFIG_SLUB_DEBUG=y
	CONFIG_SLUB_DEBUG_ON=y
	CONFIG_PM=y
	CONFIG_SUSPEND=y
	CONFIG_PM_WAKELOCKS=y

Then run:

	echo foo > /sys/power/wake_lock && cat /sys/power/wake_lock

Fixes: 390881843b4f ("sysfs: Add sysfs_emit and sysfs_emit_at to format sysfs output")
Reported-by: kernel test robot <yujie.liu@intel.com>
Link: https://lore.kernel.org/r/202303141634.1e64fd76-yujie.liu@intel.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/sysfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index c41e7f51150fc..cef9a469f73a8 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -592,7 +592,7 @@ int sysfs_emit_at(char *buf, int at, const char *fmt, ...)
 	va_list args;
 	int len;
 
-	if (WARN(!buf || offset_in_page(buf) || at < 0 || at >= PAGE_SIZE,
+	if (WARN(!buf || at < 0 || at >= PAGE_SIZE,
 		 "invalid sysfs_emit_at: buf:%p at:%d\n", buf, at))
 		return 0;
 
-- 
2.39.2

