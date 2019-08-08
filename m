Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCB6186A4E
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404323AbfHHTIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:08:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404840AbfHHTIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:08:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B8CD2173E;
        Thu,  8 Aug 2019 19:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291289;
        bh=CUF0Gohx7c3dZQvPvrbrwwn/4m6ke1fBY+li/C7lnTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybQDAcxluHpB+kI6U9gLb2XBhuIn3cIywVSvBWhgpFHl6P/4MtrAD3yoD9ArFGx3P
         GbfpWNpv0AIM2c9oU7tyOWNpTUlnrtMiYvVSi/zwgfFkt75A42ehTEQU7ijk7lZmeg
         SSFaDgXpWug/XqZv5S+uLqIZxM0U9ZWiGey0mbeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 43/56] selftests/bpf: add wrapper scripts for test_xdp_vlan.sh
Date:   Thu,  8 Aug 2019 21:05:09 +0200
Message-Id: <20190808190454.847959086@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

[ Upstream commit d35661fcf95d8818c1f9acc818a1bad23dda4e1c ]

In-order to test both native-XDP (xdpdrv) and generic-XDP (xdpgeneric)
create two wrapper test scripts, that start the test_xdp_vlan.sh script
with these modes.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/Makefile                      |    3 ++-
 tools/testing/selftests/bpf/test_xdp_vlan.sh              |    5 ++++-
 tools/testing/selftests/bpf/test_xdp_vlan_mode_generic.sh |    9 +++++++++
 tools/testing/selftests/bpf/test_xdp_vlan_mode_native.sh  |    9 +++++++++
 4 files changed, 24 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/test_xdp_vlan_mode_generic.sh
 create mode 100755 tools/testing/selftests/bpf/test_xdp_vlan_mode_native.sh

--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -51,7 +51,8 @@ TEST_PROGS := test_kmod.sh \
 	test_lirc_mode2.sh \
 	test_skb_cgroup_id.sh \
 	test_flow_dissector.sh \
-	test_xdp_vlan.sh \
+	test_xdp_vlan_mode_generic.sh \
+	test_xdp_vlan_mode_native.sh \
 	test_lwt_ip_encap.sh \
 	test_tcp_check_syncookie.sh \
 	test_tc_tunnel.sh \
--- a/tools/testing/selftests/bpf/test_xdp_vlan.sh
+++ b/tools/testing/selftests/bpf/test_xdp_vlan.sh
@@ -2,7 +2,10 @@
 # SPDX-License-Identifier: GPL-2.0
 # Author: Jesper Dangaard Brouer <hawk@kernel.org>
 
-TESTNAME=xdp_vlan
+# Allow wrapper scripts to name test
+if [ -z "$TESTNAME" ]; then
+    TESTNAME=xdp_vlan
+fi
 
 # Default XDP mode
 XDP_MODE=xdpgeneric
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xdp_vlan_mode_generic.sh
@@ -0,0 +1,9 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Exit on failure
+set -e
+
+# Wrapper script to test generic-XDP
+export TESTNAME=xdp_vlan_mode_generic
+./test_xdp_vlan.sh --mode=xdpgeneric
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xdp_vlan_mode_native.sh
@@ -0,0 +1,9 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Exit on failure
+set -e
+
+# Wrapper script to test native-XDP
+export TESTNAME=xdp_vlan_mode_native
+./test_xdp_vlan.sh --mode=xdpdrv


