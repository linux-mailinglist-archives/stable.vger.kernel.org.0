Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7639012C974
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730985AbfL2SIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:08:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:57820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731241AbfL2RrT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:47:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E7E9206A4;
        Sun, 29 Dec 2019 17:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641638;
        bh=/S7NgkOJJuMHUX3GCVpWEEoT9IoElhjA2uIdrmQAJZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTd4AcBwHuTtfcyxha7ob2HPnB/t+sLQKE6grybDOJbPtM5EsPXts0G/wgVmz1xt4
         YpAUlCj55zJ82ITUg0/vUf9E2qLwriCf9OIwP8og9NC/JU+4d2egfDtYo5luqF9nJK
         zOwBJsTZfehtFsvmtJXrbhYKFnrCq0Y/aokBgI3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Daniel T. Lee" <danieltimlee@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 110/434] samples: pktgen: fix proc_cmd command result check logic
Date:   Sun, 29 Dec 2019 18:22:43 +0100
Message-Id: <20191229172708.955863444@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
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
index 4af4046d71be..40873a5d1461 100644
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



