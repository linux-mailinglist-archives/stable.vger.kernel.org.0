Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFAC366C696
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbjAPQVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbjAPQVE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:21:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656C629E04
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:11:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F108460FDF
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB36C433D2;
        Mon, 16 Jan 2023 16:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885496;
        bh=EVKbeqe3sVmz6gPyK4px4cwHaORxjGRRhkXAONP5Kmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wIuru6tWriFSCZsmilsk/Uc8cKLCDWQC8uHLqwlBxVArZvvRElcBFld2e17Xyi3j4
         0t287im//5lhi3hvQmIIgSi+2uais486N0WAPkub5jOUkqhyXo08TqX+yJ0G+6ywfa
         bJIP6RyiEZMc+z0oO+JMNX82NR5QkOa0Jwuyf1pE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/658] docs: fault-injection: fix non-working usage of negative values
Date:   Mon, 16 Jan 2023 16:42:42 +0100
Message-Id: <20230116154913.012061081@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index f51bb21d20e4..e4056dc51e7f 100644
--- a/Documentation/fault-injection/fault-injection.rst
+++ b/Documentation/fault-injection/fault-injection.rst
@@ -74,8 +74,10 @@ configuration of fault-injection capabilities.
 
 - /sys/kernel/debug/fail*/times:
 
-	specifies how many times failures may happen at most.
-	A value of -1 means "no limit".
+	specifies how many times failures may happen at most. A value of -1
+	means "no limit". Note, though, that this file only accepts unsigned
+	values. So, if you want to specify -1, you better use 'printf' instead
+	of 'echo', e.g.: $ printf %#x -1 > times
 
 - /sys/kernel/debug/fail*/space:
 
@@ -163,11 +165,13 @@ configuration of fault-injection capabilities.
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
@@ -250,7 +254,7 @@ Application Examples
     echo Y > /sys/kernel/debug/$FAILTYPE/task-filter
     echo 10 > /sys/kernel/debug/$FAILTYPE/probability
     echo 100 > /sys/kernel/debug/$FAILTYPE/interval
-    echo -1 > /sys/kernel/debug/$FAILTYPE/times
+    printf %#x -1 > /sys/kernel/debug/$FAILTYPE/times
     echo 0 > /sys/kernel/debug/$FAILTYPE/space
     echo 2 > /sys/kernel/debug/$FAILTYPE/verbose
     echo 1 > /sys/kernel/debug/$FAILTYPE/ignore-gfp-wait
@@ -304,7 +308,7 @@ Application Examples
     echo N > /sys/kernel/debug/$FAILTYPE/task-filter
     echo 10 > /sys/kernel/debug/$FAILTYPE/probability
     echo 100 > /sys/kernel/debug/$FAILTYPE/interval
-    echo -1 > /sys/kernel/debug/$FAILTYPE/times
+    printf %#x -1 > /sys/kernel/debug/$FAILTYPE/times
     echo 0 > /sys/kernel/debug/$FAILTYPE/space
     echo 2 > /sys/kernel/debug/$FAILTYPE/verbose
     echo 1 > /sys/kernel/debug/$FAILTYPE/ignore-gfp-wait
@@ -331,11 +335,11 @@ Application Examples
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



