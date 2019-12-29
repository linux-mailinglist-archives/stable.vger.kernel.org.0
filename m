Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA1A412C3E2
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbfL2RYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:24:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:42942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727695AbfL2RYU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:24:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5C7C20722;
        Sun, 29 Dec 2019 17:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640260;
        bh=av8gZuq+0abHRu6UaGoeAMPxv9tgYdnnG/MRCOMyuMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EU6q+qKqp5ua3nkNY+dil1qRcJmkF213d7cZSFP10PVPw330xgTrBzOCzSPl3jKLs
         PZSEfJHkfLSoFR0PjfewN2e2zCMntLAgTjK/8W9BfWvFXMs7AtoZi5gv4C9YjOk3vI
         vcyUO9wtU7nVxiq9ytHzx672b7Hb73JOScWo3zDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Daniel T. Lee" <danieltimlee@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 046/161] samples: pktgen: fix proc_cmd command result check logic
Date:   Sun, 29 Dec 2019 18:18:14 +0100
Message-Id: <20191229162413.268801453@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel T. Lee <danieltimlee@gmail.com>

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
index 205e4cde4601..065a7e296ee3 100644
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



