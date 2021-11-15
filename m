Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA58451ED8
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351902AbhKPAhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344727AbhKOTZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8439636BF;
        Mon, 15 Nov 2021 19:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002988;
        bh=wB5sIrKqXPDvKRn2UUAxU6NlKfOSmWyp5qQC73KLl5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2uMusHNDehUpkjUtTVdDCYnJz85/D+DFvhL6FaO/XemZgq0XaAk7PzVFqdCOEgLIe
         S0TQRwK1zirz7HA5ogirAJ2xMygQ4gEjGsDS/TT4rovCwPg+HB2OmObkWM8OXlTfTW
         3dAgSEzU50u2B7qSvoCxxqtlIvdJwSIh2iiBNXj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 768/917] kselftests/net: add missed toeplitz.sh/toeplitz_client.sh to Makefile
Date:   Mon, 15 Nov 2021 18:04:23 +0100
Message-Id: <20211115165454.980788034@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 17b67370c38de2a878debf39dcbc704a206af4d0 ]

When generating the selftests to another folder, the toeplitz.sh
and toeplitz_client.sh are missing as they are not in Makefile, e.g.

  make -C tools/testing/selftests/ install \
      TARGETS="net" INSTALL_PATH=/tmp/kselftests

Making them under TEST_PROGS_EXTENDED as they test NIC hardware features
and are not intended to be run from kselftests.

Fixes: 5ebfb4cc3048 ("selftests/net: toeplitz test")
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 7328bede35f05..6a953ec793ced 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -33,6 +33,7 @@ TEST_PROGS += srv6_end_dt4_l3vpn_test.sh
 TEST_PROGS += srv6_end_dt6_l3vpn_test.sh
 TEST_PROGS += vrf_strict_mode_test.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
+TEST_PROGS_EXTENDED += toeplitz_client.sh toeplitz.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
 TEST_GEN_FILES += tcp_mmap tcp_inq psock_snd txring_overwrite
-- 
2.33.0



