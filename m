Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6172E6635
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388293AbgL1NXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:23:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:51464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387639AbgL1NXB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:23:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2727922B37;
        Mon, 28 Dec 2020 13:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161740;
        bh=ZEwHuEGQ+vf2UNUct46rsFOozmqr9HZK0SBkkoaJ5G8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TAE3WqyavfJJMb1a2qfCK0lYlTzFyt4tns/wJQ4eZPhTlSVMWHfPLUTWHIa5f4dbR
         bMZJfLvhl5m+vdK5D1pKptSn4kJaMXSyKHsFRXJM2svx/NvBTMGgwDNqIp1U14OQTJ
         esHLPbZZla+bb6+rDq14WjqnBojklJ+pxn2EFFcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 066/346] selftests/bpf/test_offload.py: Reset ethtool features after failed setting
Date:   Mon, 28 Dec 2020 13:46:25 +0100
Message-Id: <20201228124922.990491256@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 766e62b7fcd2cf1d43e6594ba37c659dc48f7ddb ]

When setting the ethtool feature flag fails (as expected for the test), the
kernel now tracks that the feature was requested to be 'off' and refuses to
subsequently disable it again. So reset it back to 'on' so a subsequent
disable (that's not supposed to fail) can succeed.

Fixes: 417ec26477a5 ("selftests/bpf: add offload test based on netdevsim")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/bpf/160752226280.110217.10696241563705667871.stgit@toke.dk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_offload.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/test_offload.py b/tools/testing/selftests/bpf/test_offload.py
index d59642e70f562..2229e55216a97 100755
--- a/tools/testing/selftests/bpf/test_offload.py
+++ b/tools/testing/selftests/bpf/test_offload.py
@@ -787,6 +787,7 @@ try:
     start_test("Test disabling TC offloads is rejected while filters installed...")
     ret, _ = sim.set_ethtool_tc_offloads(False, fail=False)
     fail(ret == 0, "Driver should refuse to disable TC offloads with filters installed...")
+    sim.set_ethtool_tc_offloads(True)
 
     start_test("Test qdisc removal frees things...")
     sim.tc_flush_filters()
-- 
2.27.0



