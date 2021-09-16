Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F4540E458
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343697AbhIPQ5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:57:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344179AbhIPQyK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:54:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF4AF61374;
        Thu, 16 Sep 2021 16:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809791;
        bh=35mbzRvU6JfJ7yvh2CXrenvC6BWUwLp9YJcEV3nMwhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ga30uxutSVVe9G8u8Ue0tqpdrw/sCTkx+IMdgDXnaPdupiL5a7+AlmSNrZoQCaMTb
         xNhHQ0MlcWEPirqGEqTKF23fa7PSqR3OoHN3b4g2P/bMpgEAX8Z7E5taB8f9BJe3us
         1NE1w4nhbqACHf+7LAMw+S0WuqowbksEusAO78zI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jussi Maki <joamaki@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 253/380] selftests/bpf: Fix xdp_tx.c prog section name
Date:   Thu, 16 Sep 2021 18:00:10 +0200
Message-Id: <20210916155812.690258404@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jussi Maki <joamaki@gmail.com>

[ Upstream commit 95413846cca37f20000dd095cf6d91f8777129d7 ]

The program type cannot be deduced from 'tx' which causes an invalid
argument error when trying to load xdp_tx.o using the skeleton.
Rename the section name to "xdp" so that libbpf can deduce the type.

Signed-off-by: Jussi Maki <joamaki@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210731055738.16820-7-joamaki@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/xdp_tx.c   | 2 +-
 tools/testing/selftests/bpf/test_xdp_veth.sh | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/xdp_tx.c b/tools/testing/selftests/bpf/progs/xdp_tx.c
index 94e6c2b281cb..5f725c720e00 100644
--- a/tools/testing/selftests/bpf/progs/xdp_tx.c
+++ b/tools/testing/selftests/bpf/progs/xdp_tx.c
@@ -3,7 +3,7 @@
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 
-SEC("tx")
+SEC("xdp")
 int xdp_tx(struct xdp_md *xdp)
 {
 	return XDP_TX;
diff --git a/tools/testing/selftests/bpf/test_xdp_veth.sh b/tools/testing/selftests/bpf/test_xdp_veth.sh
index ba8ffcdaac30..995278e684b6 100755
--- a/tools/testing/selftests/bpf/test_xdp_veth.sh
+++ b/tools/testing/selftests/bpf/test_xdp_veth.sh
@@ -108,7 +108,7 @@ ip link set dev veth2 xdp pinned $BPF_DIR/progs/redirect_map_1
 ip link set dev veth3 xdp pinned $BPF_DIR/progs/redirect_map_2
 
 ip -n ns1 link set dev veth11 xdp obj xdp_dummy.o sec xdp_dummy
-ip -n ns2 link set dev veth22 xdp obj xdp_tx.o sec tx
+ip -n ns2 link set dev veth22 xdp obj xdp_tx.o sec xdp
 ip -n ns3 link set dev veth33 xdp obj xdp_dummy.o sec xdp_dummy
 
 trap cleanup EXIT
-- 
2.30.2



