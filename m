Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5A629B9B6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802740AbgJ0PvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:51:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802368AbgJ0Pq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:46:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BBBA21D42;
        Tue, 27 Oct 2020 15:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813614;
        bh=hh6NIyRlK4Wzwl+j76BIbzH/o10VR1Hj1qDhgVscnR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gL2xjU/n/f2LAg6aeHLLUgZQC4/qqo0OFPrIEb3eilbbMAbTygEvj4Jwz/EBcTCpS
         ldo3Xba5NM2ObCijton3W3W4I3X04SeejYVtjFiRCDtdZlBKWoEbE9YgR1pK7fnVJr
         DVGeHtPNF5pOQ2JP0t/QhLTuiAhkQKbEArsP5bfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 580/757] selftests: mptcp: depends on built-in IPv6
Date:   Tue, 27 Oct 2020 14:53:50 +0100
Message-Id: <20201027135517.727716271@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

[ Upstream commit 287d35405989cfe0090e3059f7788dc531879a8d ]

Recently, CONFIG_MPTCP_IPV6 no longer selects CONFIG_IPV6. As a
consequence, if CONFIG_MPTCP_IPV6=y is added to the kconfig, it will no
longer ensure CONFIG_IPV6=y. If it is not enabled, CONFIG_MPTCP_IPV6
will stay disabled and selftests will fail.

We also need CONFIG_IPV6 to be built-in. For more details, please see
commit 0ed37ac586c0 ("mptcp: depends on IPV6 but not as a module").

Note that 'make kselftest-merge' will take all 'config' files found in
'tools/testsing/selftests'. Because some of them already set
CONFIG_IPV6=y, MPTCP selftests were still passing. But they will fail if
MPTCP selftests are launched manually after having executed this command
to prepare the kernel config:

  ./scripts/kconfig/merge_config.sh -m .config \
      ./tools/testing/selftests/net/mptcp/config

Fixes: 010b430d5df5 ("mptcp: MPTCP_IPV6 should depend on IPV6 instead of selecting it")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Link: https://lore.kernel.org/r/20201021155549.933731-1-matthieu.baerts@tessares.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/mptcp/config b/tools/testing/selftests/net/mptcp/config
index 8df5cb8f71ff9..741a1c4f4ae8f 100644
--- a/tools/testing/selftests/net/mptcp/config
+++ b/tools/testing/selftests/net/mptcp/config
@@ -1,4 +1,5 @@
 CONFIG_MPTCP=y
+CONFIG_IPV6=y
 CONFIG_MPTCP_IPV6=y
 CONFIG_INET_DIAG=m
 CONFIG_INET_MPTCP_DIAG=m
-- 
2.25.1



