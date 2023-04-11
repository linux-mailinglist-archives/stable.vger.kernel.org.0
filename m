Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33F96DDBF5
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 15:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjDKNU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 09:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjDKNUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 09:20:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004D54EE7
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 06:20:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FF1062643
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 13:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABACC433D2;
        Tue, 11 Apr 2023 13:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681219250;
        bh=DfgU7waEjvgFumDfZ3Hp+z4c/XRUR747wXTf2QF4Hf0=;
        h=Subject:To:Cc:From:Date:From;
        b=pDAPRme3X/RWvSldmio/tfVO/VvHVvZWgbZLTDGviACmI2w24FIiR4NcN5VAqKj/r
         phWBPIhhZKk71F93N3qN7xtoseBEPMXentiaIr5SMz38y3JJZxeAfX2JRE/AaS2qfg
         uZnOiDtqCXwrsvS3WAWLdz3ds3awa6oik6EHRmzo=
Subject: FAILED: patch "[PATCH] zsmalloc: document new fullness grouping" failed to apply to 6.2-stable tree
To:     senozhatsky@chromium.org, akpm@linux-foundation.org,
        minchan@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 Apr 2023 15:20:48 +0200
Message-ID: <2023041147-extent-trinity-907f@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.2.y
git checkout FETCH_HEAD
git cherry-pick -x 119b57eaf09478ce9e2a8f88a12749c2658b0ed5
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041147-extent-trinity-907f@gregkh' --subject-prefix 'PATCH 6.2.y' HEAD^..

Possible dependencies:

119b57eaf094 ("zsmalloc: document new fullness grouping")
4ff93b292c0b ("zsmalloc: make zspage chain size configurable")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 119b57eaf09478ce9e2a8f88a12749c2658b0ed5 Mon Sep 17 00:00:00 2001
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Date: Sat, 25 Mar 2023 11:46:30 +0900
Subject: [PATCH] zsmalloc: document new fullness grouping

Patch series "zsmalloc: minor documentation updates".

Two minor patches that bring zsmalloc documentation up to date.


This patch (of 2):

Update documentation and reflect new zspages fullness grouping (we don't
use almost_empty and almost_full anymore).

Link: https://lkml.kernel.org/r/20230325024631.2817153-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20230325024631.2817153-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Fixes: 67e157eb3639 ("zsmalloc: show per fullness group class stats")
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/Documentation/mm/zsmalloc.rst b/Documentation/mm/zsmalloc.rst
index 64d127bfc221..3c6bf639887f 100644
--- a/Documentation/mm/zsmalloc.rst
+++ b/Documentation/mm/zsmalloc.rst
@@ -39,13 +39,12 @@ With CONFIG_ZSMALLOC_STAT, we could see zsmalloc internal information via
 
  # cat /sys/kernel/debug/zsmalloc/zram0/classes
 
- class  size almost_full almost_empty obj_allocated   obj_used pages_used pages_per_zspage
+ class  size       10%       20%       30%       40%       50%       60%       70%       80%       90%       99%      100% obj_allocated   obj_used pages_used pages_per_zspage freeable
     ...
     ...
-     9   176           0            1           186        129          8                4
-    10   192           1            0          2880       2872        135                3
-    11   208           0            1           819        795         42                2
-    12   224           0            1           219        159         12                4
+    30   512         0        12         4         1         0         1         0         0         1         0       414          3464       3346        433                1       14
+    31   528         2         7         2         2         1         0         1         0         0         2       117          4154       3793        536                4       44
+    32   544         6         3         4         1         2         1         0         0         0         1       260          4170       3965        556                2       26
     ...
     ...
 
@@ -54,10 +53,28 @@ class
 	index
 size
 	object size zspage stores
-almost_empty
-	the number of ZS_ALMOST_EMPTY zspages(see below)
-almost_full
-	the number of ZS_ALMOST_FULL zspages(see below)
+10%
+	the number of zspages with usage ratio less than 10% (see below)
+20%
+	the number of zspages with usage ratio between 10% and 20%
+30%
+	the number of zspages with usage ratio between 20% and 30%
+40%
+	the number of zspages with usage ratio between 30% and 40%
+50%
+	the number of zspages with usage ratio between 40% and 50%
+60%
+	the number of zspages with usage ratio between 50% and 60%
+70%
+	the number of zspages with usage ratio between 60% and 70%
+80%
+	the number of zspages with usage ratio between 70% and 80%
+90%
+	the number of zspages with usage ratio between 80% and 90%
+99%
+	the number of zspages with usage ratio between 90% and 99%
+100%
+	the number of zspages with usage ratio 100%
 obj_allocated
 	the number of objects allocated
 obj_used
@@ -67,18 +84,11 @@ pages_used
 pages_per_zspage
 	the number of 0-order pages to make a zspage
 
-We assign a zspage to ZS_ALMOST_EMPTY fullness group when n <= N / f, where
-
-* n = number of allocated objects
-* N = total number of objects zspage can store
-* f = fullness_threshold_frac(ie, 4 at the moment)
-
-Similarly, we assign zspage to:
-
-* ZS_ALMOST_FULL  when n > N / f
-* ZS_EMPTY        when n == 0
-* ZS_FULL         when n == N
-
+Each zspage maintains inuse counter which keeps track of the number of
+objects stored in the zspage.  The inuse counter determines the zspage's
+"fullness group" which is calculated as the ratio of the "inuse" objects to
+the total number of objects the zspage can hold (objs_per_zspage). The
+closer the inuse counter is to objs_per_zspage, the better.
 
 Internals
 =========
@@ -94,10 +104,10 @@ of objects that each zspage can store.
 
 For instance, consider the following size classes:::
 
-  class  size almost_full almost_empty obj_allocated   obj_used pages_used pages_per_zspage freeable
+  class  size       10%   ....    100% obj_allocated   obj_used pages_used pages_per_zspage freeable
   ...
-     94  1536           0            0             0          0          0                3        0
-    100  1632           0            0             0          0          0                2        0
+     94  1536        0    ....       0             0          0          0                3        0
+    100  1632        0    ....       0             0          0          0                2        0
   ...
 
 
@@ -134,10 +144,11 @@ reduces memory wastage.
 
 Let's take a closer look at the bottom of `/sys/kernel/debug/zsmalloc/zramX/classes`:::
 
-  class  size almost_full almost_empty obj_allocated   obj_used pages_used pages_per_zspage freeable
+  class  size       10%   ....    100% obj_allocated   obj_used pages_used pages_per_zspage freeable
+
   ...
-    202  3264           0            0             0          0          0                4        0
-    254  4096           0            0             0          0          0                1        0
+    202  3264         0   ..         0             0          0          0                4        0
+    254  4096         0   ..         0             0          0          0                1        0
   ...
 
 Size class #202 stores objects of size 3264 bytes and has a maximum of 4 pages
@@ -151,40 +162,42 @@ efficient storage of large objects.
 
 For zspage chain size of 8, huge class watermark becomes 3632 bytes:::
 
-  class  size almost_full almost_empty obj_allocated   obj_used pages_used pages_per_zspage freeable
+  class  size       10%   ....    100% obj_allocated   obj_used pages_used pages_per_zspage freeable
+
   ...
-    202  3264           0            0             0          0          0                4        0
-    211  3408           0            0             0          0          0                5        0
-    217  3504           0            0             0          0          0                6        0
-    222  3584           0            0             0          0          0                7        0
-    225  3632           0            0             0          0          0                8        0
-    254  4096           0            0             0          0          0                1        0
+    202  3264         0   ..         0             0          0          0                4        0
+    211  3408         0   ..         0             0          0          0                5        0
+    217  3504         0   ..         0             0          0          0                6        0
+    222  3584         0   ..         0             0          0          0                7        0
+    225  3632         0   ..         0             0          0          0                8        0
+    254  4096         0   ..         0             0          0          0                1        0
   ...
 
 For zspage chain size of 16, huge class watermark becomes 3840 bytes:::
 
-  class  size almost_full almost_empty obj_allocated   obj_used pages_used pages_per_zspage freeable
+  class  size       10%   ....    100% obj_allocated   obj_used pages_used pages_per_zspage freeable
+
   ...
-    202  3264           0            0             0          0          0                4        0
-    206  3328           0            0             0          0          0               13        0
-    207  3344           0            0             0          0          0                9        0
-    208  3360           0            0             0          0          0               14        0
-    211  3408           0            0             0          0          0                5        0
-    212  3424           0            0             0          0          0               16        0
-    214  3456           0            0             0          0          0               11        0
-    217  3504           0            0             0          0          0                6        0
-    219  3536           0            0             0          0          0               13        0
-    222  3584           0            0             0          0          0                7        0
-    223  3600           0            0             0          0          0               15        0
-    225  3632           0            0             0          0          0                8        0
-    228  3680           0            0             0          0          0                9        0
-    230  3712           0            0             0          0          0               10        0
-    232  3744           0            0             0          0          0               11        0
-    234  3776           0            0             0          0          0               12        0
-    235  3792           0            0             0          0          0               13        0
-    236  3808           0            0             0          0          0               14        0
-    238  3840           0            0             0          0          0               15        0
-    254  4096           0            0             0          0          0                1        0
+    202  3264         0   ..         0             0          0          0                4        0
+    206  3328         0   ..         0             0          0          0               13        0
+    207  3344         0   ..         0             0          0          0                9        0
+    208  3360         0   ..         0             0          0          0               14        0
+    211  3408         0   ..         0             0          0          0                5        0
+    212  3424         0   ..         0             0          0          0               16        0
+    214  3456         0   ..         0             0          0          0               11        0
+    217  3504         0   ..         0             0          0          0                6        0
+    219  3536         0   ..         0             0          0          0               13        0
+    222  3584         0   ..         0             0          0          0                7        0
+    223  3600         0   ..         0             0          0          0               15        0
+    225  3632         0   ..         0             0          0          0                8        0
+    228  3680         0   ..         0             0          0          0                9        0
+    230  3712         0   ..         0             0          0          0               10        0
+    232  3744         0   ..         0             0          0          0               11        0
+    234  3776         0   ..         0             0          0          0               12        0
+    235  3792         0   ..         0             0          0          0               13        0
+    236  3808         0   ..         0             0          0          0               14        0
+    238  3840         0   ..         0             0          0          0               15        0
+    254  4096         0   ..         0             0          0          0                1        0
   ...
 
 Overall the combined zspage chain size effect on zsmalloc pool configuration:::
@@ -214,9 +227,10 @@ zram as a build artifacts storage (Linux kernel compilation).
 
   zsmalloc classes stats:::
 
-    class  size almost_full almost_empty obj_allocated   obj_used pages_used pages_per_zspage freeable
+    class  size       10%   ....    100% obj_allocated   obj_used pages_used pages_per_zspage freeable
+
     ...
-    Total                13           51        413836     412973     159955                         3
+    Total              13   ..        51        413836     412973     159955                         3
 
   zram mm_stat:::
 
@@ -227,9 +241,10 @@ zram as a build artifacts storage (Linux kernel compilation).
 
   zsmalloc classes stats:::
 
-    class  size almost_full almost_empty obj_allocated   obj_used pages_used pages_per_zspage freeable
+    class  size       10%   ....    100% obj_allocated   obj_used pages_used pages_per_zspage freeable
+
     ...
-    Total                18           87        414852     412978     156666                         0
+    Total              18   ..        87        414852     412978     156666                         0
 
   zram mm_stat:::
 

