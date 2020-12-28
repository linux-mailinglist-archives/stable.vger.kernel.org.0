Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4C02E63A2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405600AbgL1NrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:47:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:48394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405589AbgL1NrT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:47:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 537AD22AAA;
        Mon, 28 Dec 2020 13:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163199;
        bh=b4HI2o2L0UGgvI4NCxWbGluFCSpvWLmEED1AhU6H+18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jecoy7HJxnuO3hq40rClqwn1AUWXExnNmtRmp3vsjnU+BnNVLev74Aam6/mG25iqT
         Mea9iJXfPuPSjQyEViyFCQpkkbk+aZ0uMu3RfrQ0O1D2021475b//MoTwFevf9RP39
         /XtqK8o1c37r9VL2ICfe9IraEZYADkyApLrFV0tc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Daniel T. Lee" <danieltimlee@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 174/453] samples: bpf: Fix lwt_len_hist reusing previous BPF map
Date:   Mon, 28 Dec 2020 13:46:50 +0100
Message-Id: <20201228124945.571481645@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel T. Lee <danieltimlee@gmail.com>

[ Upstream commit 0afe0a998c40085a6342e1aeb4c510cccba46caf ]

Currently, lwt_len_hist's map lwt_len_hist_map is uses pinning, and the
map isn't cleared on test end. This leds to reuse of that map for
each test, which prevents the results of the test from being accurate.

This commit fixes the problem by removing of pinned map from bpffs.
Also, this commit add the executable permission to shell script
files.

Fixes: f74599f7c5309 ("bpf: Add tests and samples for LWT-BPF")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20201124090310.24374-7-danieltimlee@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/lwt_len_hist.sh | 2 ++
 samples/bpf/test_lwt_bpf.sh | 0
 2 files changed, 2 insertions(+)
 mode change 100644 => 100755 samples/bpf/lwt_len_hist.sh
 mode change 100644 => 100755 samples/bpf/test_lwt_bpf.sh

diff --git a/samples/bpf/lwt_len_hist.sh b/samples/bpf/lwt_len_hist.sh
old mode 100644
new mode 100755
index 090b96eaf7f76..0eda9754f50b8
--- a/samples/bpf/lwt_len_hist.sh
+++ b/samples/bpf/lwt_len_hist.sh
@@ -8,6 +8,8 @@ VETH1=tst_lwt1b
 TRACE_ROOT=/sys/kernel/debug/tracing
 
 function cleanup {
+	# To reset saved histogram, remove pinned map
+	rm /sys/fs/bpf/tc/globals/lwt_len_hist_map
 	ip route del 192.168.253.2/32 dev $VETH0 2> /dev/null
 	ip link del $VETH0 2> /dev/null
 	ip link del $VETH1 2> /dev/null
diff --git a/samples/bpf/test_lwt_bpf.sh b/samples/bpf/test_lwt_bpf.sh
old mode 100644
new mode 100755
-- 
2.27.0



