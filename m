Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1108B408F75
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241882AbhIMNnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:43:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236180AbhIMNk6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:40:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 111346124D;
        Mon, 13 Sep 2021 13:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539776;
        bh=oN6mONBcZeGP2JszXEKGJI6AJngr/ZrWPvIY7ZuL394=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VniFun8WJbBdkp9q8Z4TwEbDNcpXKThLDmnEz1jnxNSe5rOObxEfTH6EYjdPdFEtR
         rd3kFIVnQwnpPqnFZYeIZi8sar9EHgGOPOkA/uPW29ei4YOAM9d5DT6h5CeiMR+YXf
         Q6mIpNe6bPWRJOPqMfLWEXy/tSx/zK/F0oHpsA8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juhee Kang <claudiajkang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 156/236] samples: pktgen: add missing IPv6 option to pktgen scripts
Date:   Mon, 13 Sep 2021 15:14:21 +0200
Message-Id: <20210913131105.687797459@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
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
index 2cd6b701400d..9db1ecf8de8b 100755
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
@@ -65,8 +67,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 
     # Single destination
     pg_set $dev "dst_mac $DST_MAC"
-    pg_set $dev "dst_min $DST_MIN"
-    pg_set $dev "dst_max $DST_MAX"
+    pg_set $dev "dst${IP6}_min $DST_MIN"
+    pg_set $dev "dst${IP6}_max $DST_MAX"
 
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
diff --git a/samples/pktgen/pktgen_sample05_flow_per_thread.sh b/samples/pktgen/pktgen_sample05_flow_per_thread.sh
index 4cb6252ade39..9fc6c6da028a 100755
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
@@ -55,8 +57,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 
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



