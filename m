Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6997B119884
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbfLJVdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:33:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729559AbfLJVdC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:33:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C35782073B;
        Tue, 10 Dec 2019 21:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013582;
        bh=9VFmB3M91VcvR1jv7oELq4udsBEvwkKykBaibx02www=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zknwQdGI8hsQw/vOSkDRcSGg3lBodAVi7eQSMrB6ZIFcCgUQpXT5FR5t94Jx/1p5V
         47RDlmP2YpEs+ZayYgdeOX8E1ebBNb6Vtu4Gc860MaxST6eY9bbJQ4phLWEj4OcSrt
         JOj/CqOaxHLEeWx+5H1UnbKeOTNkp+lU/U3D3P+A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 034/177] samples: pktgen: fix proc_cmd command result check logic
Date:   Tue, 10 Dec 2019 16:29:58 -0500
Message-Id: <20191210213221.11921-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Daniel T. Lee" <danieltimlee@gmail.com>

[ Upstream commit 3cad8f911575191fb3b81d8ed0e061e30f922223 ]

Currently, proc_cmd is used to dispatch command to 'pg_ctrl', 'pg_thread',
'pg_set'. proc_cmd is designed to check command result with grep the
"Result:", but this might fail since this string is only shown in
'pg_thread' and 'pg_set'.

This commit fixes this logic by grep-ing the "Result:" string only when
the command is not for 'pg_ctrl'.

For clarity of an execution flow, 'errexit' flag has been set.

To cleanup pktgen on exit, trap has been added for EXIT signal.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/pktgen/functions.sh | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
index f8bb3cd0f4ce6..7d928571b25c4 100644
--- a/samples/pktgen/functions.sh
+++ b/samples/pktgen/functions.sh
@@ -5,6 +5,8 @@
 # Author: Jesper Dangaaard Brouer
 # License: GPL
 
+set -o errexit
+
 ## -- General shell logging cmds --
 function err() {
     local exitcode=$1
@@ -58,6 +60,7 @@ function pg_set() {
 function proc_cmd() {
     local result
     local proc_file=$1
+    local status=0
     # after shift, the remaining args are contained in $@
     shift
     local proc_ctrl=${PROC_DIR}/$proc_file
@@ -73,13 +76,13 @@ function proc_cmd() {
 	echo "cmd: $@ > $proc_ctrl"
     fi
     # Quoting of "$@" is important for space expansion
-    echo "$@" > "$proc_ctrl"
-    local status=$?
+    echo "$@" > "$proc_ctrl" || status=$?
 
-    result=$(grep "Result: OK:" $proc_ctrl)
-    # Due to pgctrl, cannot use exit code $? from grep
-    if [[ "$result" == "" ]]; then
-	grep "Result:" $proc_ctrl >&2
+    if [[ "$proc_file" != "pgctrl" ]]; then
+        result=$(grep "Result: OK:" $proc_ctrl) || true
+        if [[ "$result" == "" ]]; then
+            grep "Result:" $proc_ctrl >&2
+        fi
     fi
     if (( $status != 0 )); then
 	err 5 "Write error($status) occurred cmd: \"$@ > $proc_ctrl\""
@@ -105,6 +108,8 @@ function pgset() {
     fi
 }
 
+[[ $EUID -eq 0 ]] && trap 'pg_ctrl "reset"' EXIT
+
 ## -- General shell tricks --
 
 function root_check_run_with_sudo() {
-- 
2.20.1

