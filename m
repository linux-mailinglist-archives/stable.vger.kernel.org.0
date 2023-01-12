Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62C5F66745D
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234070AbjALOGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234868AbjALOFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:05:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6A054DBD
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:04:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBC1D62030
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F66C433F1;
        Thu, 12 Jan 2023 14:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532259;
        bh=hWLTob0lBU1E/N9Lb1t/BDJoVddh6CY495jSnOwh1rI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RhobhyPQ59/ggNmy5892A2SJTxgW/UjZwKHn2upyQ6/QsFWw/1HdSyIUG2hqt9Nw1
         +k3Bch13iApAcMzMhGEurchJL1ubl0u4vGb39gAtA+xE7lvHaMQVJaXB/xpQ3d9ukt
         QGC58/p8rA9rN+4TptcQQ/lb4XgNeUd6Xvo05UF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/783] docs: fault-injection: fix non-working usage of negative values
Date:   Thu, 12 Jan 2023 14:46:29 +0100
Message-Id: <20230112135527.538017220@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 005747526d4f3c2ec995891e95cb7625161022f9 ]

Fault injection uses debugfs in a way that the provided values via sysfs
are interpreted as u64. Providing negative numbers results in an error:

/sys/kernel/debug/fail_function# echo -1 > times
sh: write error: Invalid argument

Update the docs and examples to use "printf %#x <val>" in these cases.
For "retval", reword the paragraph a little and fix a typo.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/20210603125841.27436-1-wsa+renesas@sang-engineering.com
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Stable-dep-of: d472cf797c4e ("debugfs: fix error when writing negative value to atomic_t debugfs file")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../fault-injection/fault-injection.rst       | 24 +++++++++++--------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/Documentation/fault-injection/fault-injection.rst b/Documentation/fault-injection/fault-injection.rst
index 31ecfe44e5b4..f47d05ed0d94 100644
--- a/Documentation/fault-injection/fault-injection.rst
+++ b/Documentation/fault-injection/fault-injection.rst
@@ -78,8 +78,10 @@ configuration of fault-injection capabilities.
 
 - /sys/kernel/debug/fail*/times:
 
-	specifies how many times failures may happen at most.
-	A value of -1 means "no limit".
+	specifies how many times failures may happen at most. A value of -1
+	means "no limit". Note, though, that this file only accepts unsigned
+	values. So, if you want to specify -1, you better use 'printf' instead
+	of 'echo', e.g.: $ printf %#x -1 > times
 
 - /sys/kernel/debug/fail*/space:
 
@@ -167,11 +169,13 @@ configuration of fault-injection capabilities.
 	- ERRNO: retval must be -1 to -MAX_ERRNO (-4096).
 	- ERR_NULL: retval must be 0 or -1 to -MAX_ERRNO (-4096).
 
-- /sys/kernel/debug/fail_function/<functiuon-name>/retval:
+- /sys/kernel/debug/fail_function/<function-name>/retval:
 
-	specifies the "error" return value to inject to the given
-	function for given function. This will be created when
-	user specifies new injection entry.
+	specifies the "error" return value to inject to the given function.
+	This will be created when the user specifies a new injection entry.
+	Note that this file only accepts unsigned values. So, if you want to
+	use a negative errno, you better use 'printf' instead of 'echo', e.g.:
+	$ printf %#x -12 > retval
 
 Boot option
 ^^^^^^^^^^^
@@ -255,7 +259,7 @@ Application Examples
     echo Y > /sys/kernel/debug/$FAILTYPE/task-filter
     echo 10 > /sys/kernel/debug/$FAILTYPE/probability
     echo 100 > /sys/kernel/debug/$FAILTYPE/interval
-    echo -1 > /sys/kernel/debug/$FAILTYPE/times
+    printf %#x -1 > /sys/kernel/debug/$FAILTYPE/times
     echo 0 > /sys/kernel/debug/$FAILTYPE/space
     echo 2 > /sys/kernel/debug/$FAILTYPE/verbose
     echo 1 > /sys/kernel/debug/$FAILTYPE/ignore-gfp-wait
@@ -309,7 +313,7 @@ Application Examples
     echo N > /sys/kernel/debug/$FAILTYPE/task-filter
     echo 10 > /sys/kernel/debug/$FAILTYPE/probability
     echo 100 > /sys/kernel/debug/$FAILTYPE/interval
-    echo -1 > /sys/kernel/debug/$FAILTYPE/times
+    printf %#x -1 > /sys/kernel/debug/$FAILTYPE/times
     echo 0 > /sys/kernel/debug/$FAILTYPE/space
     echo 2 > /sys/kernel/debug/$FAILTYPE/verbose
     echo 1 > /sys/kernel/debug/$FAILTYPE/ignore-gfp-wait
@@ -336,11 +340,11 @@ Application Examples
     FAILTYPE=fail_function
     FAILFUNC=open_ctree
     echo $FAILFUNC > /sys/kernel/debug/$FAILTYPE/inject
-    echo -12 > /sys/kernel/debug/$FAILTYPE/$FAILFUNC/retval
+    printf %#x -12 > /sys/kernel/debug/$FAILTYPE/$FAILFUNC/retval
     echo N > /sys/kernel/debug/$FAILTYPE/task-filter
     echo 100 > /sys/kernel/debug/$FAILTYPE/probability
     echo 0 > /sys/kernel/debug/$FAILTYPE/interval
-    echo -1 > /sys/kernel/debug/$FAILTYPE/times
+    printf %#x -1 > /sys/kernel/debug/$FAILTYPE/times
     echo 0 > /sys/kernel/debug/$FAILTYPE/space
     echo 1 > /sys/kernel/debug/$FAILTYPE/verbose
 
-- 
2.35.1



