Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B410409241
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235467AbhIMOKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:10:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344233AbhIMOHQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:07:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62FEF61A86;
        Mon, 13 Sep 2021 13:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540430;
        bh=d6Yzb7A+pcDBNq4OXFFHr6q/+jUdHInhJyJh/qMEhGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BpgGaY3vAoEIDGhOpcVBywYNenxNRI4c5yDk/gxE4HLP96GKRjMeA3wOz1ImD4f4k
         6/mRDyIaXmzAQQU+MwXm6lNVSTbMHdngfgrYOOLhEHPyqDimFT76YilgC/FnBO4Bfz
         i1tXCdkzDfbQ3xqKjnirJaR1zVEcKYlTbc+oiIaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juhee Kang <claudiajkang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 189/300] samples: pktgen: add missing IPv6 option to pktgen scripts
Date:   Mon, 13 Sep 2021 15:14:10 +0200
Message-Id: <20210913131115.768948008@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juhee Kang <claudiajkang@gmail.com>

[ Upstream commit 0f0c4f1b72e090b23131700bb155944cc28b2a7b ]

Currently, "sample04" and "sample05" are not working properly when
running with an IPv6 option("-6"). The commit 0f06a6787e05 ("samples:
Add an IPv6 "-6" option to the pktgen scripts") has omitted the addition
of this option at "sample04" and "sample05".

In order to support IPv6 option, this commit adds logic related to IPv6
option.

Fixes: 0f06a6787e05 ("samples: Add an IPv6 "-6" option to the pktgen scripts")

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/pktgen/pktgen_sample04_many_flows.sh      | 12 +++++++-----
 samples/pktgen/pktgen_sample05_flow_per_thread.sh | 12 +++++++-----
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/samples/pktgen/pktgen_sample04_many_flows.sh b/samples/pktgen/pktgen_sample04_many_flows.sh
index ddce876635aa..507c1143eb96 100755
--- a/samples/pktgen/pktgen_sample04_many_flows.sh
+++ b/samples/pktgen/pktgen_sample04_many_flows.sh
@@ -13,13 +13,15 @@ root_check_run_with_sudo "$@"
 # Parameter parsing via include
 source ${basedir}/parameters.sh
 # Set some default params, if they didn't get set
-[ -z "$DEST_IP" ]   && DEST_IP="198.18.0.42"
+if [ -z "$DEST_IP" ]; then
+    [ -z "$IP6" ] && DEST_IP="198.18.0.42" || DEST_IP="FD00::1"
+fi
 [ -z "$DST_MAC" ]   && DST_MAC="90:e2:ba:ff:ff:ff"
 [ -z "$CLONE_SKB" ] && CLONE_SKB="0"
 [ -z "$COUNT" ]     && COUNT="0" # Zero means indefinitely
 if [ -n "$DEST_IP" ]; then
-    validate_addr $DEST_IP
-    read -r DST_MIN DST_MAX <<< $(parse_addr $DEST_IP)
+    validate_addr${IP6} $DEST_IP
+    read -r DST_MIN DST_MAX <<< $(parse_addr${IP6} $DEST_IP)
 fi
 if [ -n "$DST_PORT" ]; then
     read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
@@ -62,8 +64,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 
     # Single destination
     pg_set $dev "dst_mac $DST_MAC"
-    pg_set $dev "dst_min $DST_MIN"
-    pg_set $dev "dst_max $DST_MAX"
+    pg_set $dev "dst${IP6}_min $DST_MIN"
+    pg_set $dev "dst${IP6}_max $DST_MAX"
 
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
diff --git a/samples/pktgen/pktgen_sample05_flow_per_thread.sh b/samples/pktgen/pktgen_sample05_flow_per_thread.sh
index 4a65fe2fcee9..160143ebcdd0 100755
--- a/samples/pktgen/pktgen_sample05_flow_per_thread.sh
+++ b/samples/pktgen/pktgen_sample05_flow_per_thread.sh
@@ -17,14 +17,16 @@ root_check_run_with_sudo "$@"
 # Parameter parsing via include
 source ${basedir}/parameters.sh
 # Set some default params, if they didn't get set
-[ -z "$DEST_IP" ]   && DEST_IP="198.18.0.42"
+if [ -z "$DEST_IP" ]; then
+    [ -z "$IP6" ] && DEST_IP="198.18.0.42" || DEST_IP="FD00::1"
+fi
 [ -z "$DST_MAC" ]   && DST_MAC="90:e2:ba:ff:ff:ff"
 [ -z "$CLONE_SKB" ] && CLONE_SKB="0"
 [ -z "$BURST" ]     && BURST=32
 [ -z "$COUNT" ]     && COUNT="0" # Zero means indefinitely
 if [ -n "$DEST_IP" ]; then
-    validate_addr $DEST_IP
-    read -r DST_MIN DST_MAX <<< $(parse_addr $DEST_IP)
+    validate_addr${IP6} $DEST_IP
+    read -r DST_MIN DST_MAX <<< $(parse_addr${IP6} $DEST_IP)
 fi
 if [ -n "$DST_PORT" ]; then
     read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
@@ -52,8 +54,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 
     # Single destination
     pg_set $dev "dst_mac $DST_MAC"
-    pg_set $dev "dst_min $DST_MIN"
-    pg_set $dev "dst_max $DST_MAX"
+    pg_set $dev "dst${IP6}_min $DST_MIN"
+    pg_set $dev "dst${IP6}_max $DST_MAX"
 
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
-- 
2.30.2



