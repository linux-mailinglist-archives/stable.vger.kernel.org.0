Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F49623A48B
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbgHCM2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:28:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727834AbgHCM2P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:28:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BECC207FC;
        Mon,  3 Aug 2020 12:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457693;
        bh=QyR66mhOB+DXFLTsZEh2HgiH7RdpdVsPW6tOdlXQPTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Snn4jhFaKhyjxVv9i0MFzhVq9aGZWmxMXBU9C+LkFtqS5RzytBBcevhgeAm8PniYV
         4StEGnrwVPQn+kLR3nbQk3ztjQpTOgBTAlBeWVlCutZGhF7u57y8n/q7uOJEQebNbD
         JXIxgH136Fw5E3n2LBeoI8YbrQV2W08sLzo2ACEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tanner Love <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 41/90] selftests/net: psock_fanout: fix clang issues for target arch PowerPC
Date:   Mon,  3 Aug 2020 14:19:03 +0200
Message-Id: <20200803121859.613977019@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

[ Upstream commit 64f9ede2274980076423583683d44480909b7a40 ]

Clang 9 threw:
warning: format specifies type 'unsigned short' but the argument has \
type 'int' [-Wformat]
                typeflags, PORT_BASE, PORT_BASE + port_off);

Tested: make -C tools/testing/selftests TARGETS="net" run_tests

Fixes: 77f65ebdca50 ("packet: packet fanout rollover during socket overload")
Signed-off-by: Tanner Love <tannerlove@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/psock_fanout.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/psock_fanout.c b/tools/testing/selftests/net/psock_fanout.c
index 8c8c7d79c38d9..2c522f7a0aeca 100644
--- a/tools/testing/selftests/net/psock_fanout.c
+++ b/tools/testing/selftests/net/psock_fanout.c
@@ -350,7 +350,8 @@ static int test_datapath(uint16_t typeflags, int port_off,
 	int fds[2], fds_udp[2][2], ret;
 
 	fprintf(stderr, "\ntest: datapath 0x%hx ports %hu,%hu\n",
-		typeflags, PORT_BASE, PORT_BASE + port_off);
+		typeflags, (uint16_t)PORT_BASE,
+		(uint16_t)(PORT_BASE + port_off));
 
 	fds[0] = sock_fanout_open(typeflags, 0);
 	fds[1] = sock_fanout_open(typeflags, 0);
-- 
2.25.1



