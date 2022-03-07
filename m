Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D834CF70F
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237961AbiCGJoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241043AbiCGJlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B64C6D86F;
        Mon,  7 Mar 2022 01:39:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E94F2B80F9F;
        Mon,  7 Mar 2022 09:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AF7C340E9;
        Mon,  7 Mar 2022 09:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645969;
        bh=KZ+PuEy7mAb5pB9eyH1/wpOvcih8ATnl/GdjS9UgtVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JibjPwX3FSAD/HjA14AYvOlf9aI2sUbTP8bDdtwT/FpZKv9pDZodrrFNicHl2oZoL
         wUevBcxgmyngGT1PR7wS2Moiwym9WUZ0cd22fwEmuosrBHIXhQ/mDP/7R/1dV4ww4F
         CAyH8B134qKxifh0qhwg9/ab8f9L0UfXvG2rMEus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Mina Almasry <almasrymina@google.com>,
        Shuah Khan <shuah@kernel.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/262] selftests/vm: make charge_reserved_hugetlb.sh work with existing cgroup setting
Date:   Mon,  7 Mar 2022 10:17:18 +0100
Message-Id: <20220307091705.127621717@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit 209376ed2a8431ccb4c40fdcef11194fc1e749b0 ]

The hugetlb cgroup reservation test charge_reserved_hugetlb.sh assume
that no cgroup filesystems are mounted before running the test.  That is
not true in many cases.  As a result, the test fails to run.  Fix that
by querying the current cgroup mount setting and using the existing
cgroup setup instead before attempting to freshly mount a cgroup
filesystem.

Similar change is also made for hugetlb_reparenting_test.sh as well,
though it still has problem if cgroup v2 isn't used.

The patched test scripts were run on a centos 8 based system to verify
that they ran properly.

Link: https://lkml.kernel.org/r/20220106201359.1646575-1-longman@redhat.com
Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Mina Almasry <almasrymina@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/vm/charge_reserved_hugetlb.sh   | 34 +++++++++++--------
 .../selftests/vm/hugetlb_reparenting_test.sh  | 21 +++++++-----
 .../selftests/vm/write_hugetlb_memory.sh      |  2 +-
 3 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/vm/charge_reserved_hugetlb.sh b/tools/testing/selftests/vm/charge_reserved_hugetlb.sh
index fe8fcfb334e06..a5cb4b09a46c4 100644
--- a/tools/testing/selftests/vm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/vm/charge_reserved_hugetlb.sh
@@ -24,19 +24,23 @@ if [[ "$1" == "-cgroup-v2" ]]; then
   reservation_usage_file=rsvd.current
 fi
 
-cgroup_path=/dev/cgroup/memory
-if [[ ! -e $cgroup_path ]]; then
-  mkdir -p $cgroup_path
-  if [[ $cgroup2 ]]; then
+if [[ $cgroup2 ]]; then
+  cgroup_path=$(mount -t cgroup2 | head -1 | awk -e '{print $3}')
+  if [[ -z "$cgroup_path" ]]; then
+    cgroup_path=/dev/cgroup/memory
     mount -t cgroup2 none $cgroup_path
-  else
+    do_umount=1
+  fi
+  echo "+hugetlb" >$cgroup_path/cgroup.subtree_control
+else
+  cgroup_path=$(mount -t cgroup | grep ",hugetlb" | awk -e '{print $3}')
+  if [[ -z "$cgroup_path" ]]; then
+    cgroup_path=/dev/cgroup/memory
     mount -t cgroup memory,hugetlb $cgroup_path
+    do_umount=1
   fi
 fi
-
-if [[ $cgroup2 ]]; then
-  echo "+hugetlb" >/dev/cgroup/memory/cgroup.subtree_control
-fi
+export cgroup_path
 
 function cleanup() {
   if [[ $cgroup2 ]]; then
@@ -108,7 +112,7 @@ function setup_cgroup() {
 
 function wait_for_hugetlb_memory_to_get_depleted() {
   local cgroup="$1"
-  local path="/dev/cgroup/memory/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
+  local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
   # Wait for hugetlbfs memory to get depleted.
   while [ $(cat $path) != 0 ]; do
     echo Waiting for hugetlb memory to get depleted.
@@ -121,7 +125,7 @@ function wait_for_hugetlb_memory_to_get_reserved() {
   local cgroup="$1"
   local size="$2"
 
-  local path="/dev/cgroup/memory/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
+  local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
   # Wait for hugetlbfs memory to get written.
   while [ $(cat $path) != $size ]; do
     echo Waiting for hugetlb memory reservation to reach size $size.
@@ -134,7 +138,7 @@ function wait_for_hugetlb_memory_to_get_written() {
   local cgroup="$1"
   local size="$2"
 
-  local path="/dev/cgroup/memory/$cgroup/hugetlb.${MB}MB.$fault_usage_file"
+  local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$fault_usage_file"
   # Wait for hugetlbfs memory to get written.
   while [ $(cat $path) != $size ]; do
     echo Waiting for hugetlb memory to reach size $size.
@@ -574,5 +578,7 @@ for populate in "" "-o"; do
   done     # populate
 done       # method
 
-umount $cgroup_path
-rmdir $cgroup_path
+if [[ $do_umount ]]; then
+  umount $cgroup_path
+  rmdir $cgroup_path
+fi
diff --git a/tools/testing/selftests/vm/hugetlb_reparenting_test.sh b/tools/testing/selftests/vm/hugetlb_reparenting_test.sh
index 4a9a3afe9fd4d..bf2d2a684edfd 100644
--- a/tools/testing/selftests/vm/hugetlb_reparenting_test.sh
+++ b/tools/testing/selftests/vm/hugetlb_reparenting_test.sh
@@ -18,19 +18,24 @@ if [[ "$1" == "-cgroup-v2" ]]; then
   usage_file=current
 fi
 
-CGROUP_ROOT='/dev/cgroup/memory'
-MNT='/mnt/huge/'
 
-if [[ ! -e $CGROUP_ROOT ]]; then
-  mkdir -p $CGROUP_ROOT
-  if [[ $cgroup2 ]]; then
+if [[ $cgroup2 ]]; then
+  CGROUP_ROOT=$(mount -t cgroup2 | head -1 | awk -e '{print $3}')
+  if [[ -z "$CGROUP_ROOT" ]]; then
+    CGROUP_ROOT=/dev/cgroup/memory
     mount -t cgroup2 none $CGROUP_ROOT
-    sleep 1
-    echo "+hugetlb +memory" >$CGROUP_ROOT/cgroup.subtree_control
-  else
+    do_umount=1
+  fi
+  echo "+hugetlb +memory" >$CGROUP_ROOT/cgroup.subtree_control
+else
+  CGROUP_ROOT=$(mount -t cgroup | grep ",hugetlb" | awk -e '{print $3}')
+  if [[ -z "$CGROUP_ROOT" ]]; then
+    CGROUP_ROOT=/dev/cgroup/memory
     mount -t cgroup memory,hugetlb $CGROUP_ROOT
+    do_umount=1
   fi
 fi
+MNT='/mnt/huge/'
 
 function get_machine_hugepage_size() {
   hpz=$(grep -i hugepagesize /proc/meminfo)
diff --git a/tools/testing/selftests/vm/write_hugetlb_memory.sh b/tools/testing/selftests/vm/write_hugetlb_memory.sh
index d3d0d108924d4..70a02301f4c27 100644
--- a/tools/testing/selftests/vm/write_hugetlb_memory.sh
+++ b/tools/testing/selftests/vm/write_hugetlb_memory.sh
@@ -14,7 +14,7 @@ want_sleep=$8
 reserve=$9
 
 echo "Putting task in cgroup '$cgroup'"
-echo $$ > /dev/cgroup/memory/"$cgroup"/cgroup.procs
+echo $$ > ${cgroup_path:-/dev/cgroup/memory}/"$cgroup"/cgroup.procs
 
 echo "Method is $method"
 
-- 
2.34.1



