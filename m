Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E76451EDE
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355379AbhKPAhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344714AbhKOTZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D828636B7;
        Mon, 15 Nov 2021 19:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002979;
        bh=vpAKWvmBaxgt80dS47aqaD+iO9Qy+veH5ehNAmRzsAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzUn+MK6aO22E+M1HdiaBFlv0MxE6a3AgTXA+PRV4T0CZ6Ct1b3ExZawYeawTVz4h
         b3aUevVQvVMjKXQU5arpVZH1swhqh7i0/Seap0Blp5LJfl7iPfW7M9/K6UNBpMifC/
         y9zqU/1Kl4A3h+ycDkUSmBM0vXEiyifPtIxA1Fag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 765/917] kselftests/net: add missed setup_loopback.sh/setup_veth.sh to Makefile
Date:   Mon, 15 Nov 2021 18:04:20 +0100
Message-Id: <20211115165454.871454976@linuxfoundation.org>
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

[ Upstream commit b99ac1841147eefd8d8b52fcf00d7d917949ae7f ]

When generating the selftests to another folder, the include file
setup_loopback.sh/setup_veth.sh for gro.sh/gre_gro.sh are missing as
they are not in Makefile, e.g.

  make -C tools/testing/selftests/ install \
      TARGETS="net" INSTALL_PATH=/tmp/kselftests

Fixes: 7d1575014a63 ("selftests/net: GRO coalesce test")
Fixes: 9af771d2ec04 ("selftests/net: allow GRO coalesce test on veth")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 9b1c2dfe12530..63ee01c1437b6 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -28,7 +28,7 @@ TEST_PROGS += veth.sh
 TEST_PROGS += ioam6.sh
 TEST_PROGS += gro.sh
 TEST_PROGS += gre_gso.sh
-TEST_PROGS_EXTENDED := in_netns.sh
+TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
 TEST_GEN_FILES += tcp_mmap tcp_inq psock_snd txring_overwrite
-- 
2.33.0



