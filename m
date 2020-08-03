Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7647323A51A
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729425AbgHCMdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:33:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729419AbgHCMdW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:33:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE90C2076B;
        Mon,  3 Aug 2020 12:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596458001;
        bh=OtnXhp2U8pIrjCX+A+q845AQgjyLC0mf+i8t9s0aHRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mAY0TMwEkYW6w4SE1TZ8C7lLGqgebhzQjfvS6TKOrJPfUPEyXS58Mt/JWNL7ZY5RB
         rLy4B1GUpGSN/9wnWgL6J27ObyvMSChUj2iltPI7GPnvXWDiXJHuKf6v0EEH0IdEZ/
         FgQprrz7AtNr2xvKiUjHc3gINpPD4VkX3cTtHV9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tanner Love <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 29/56] selftests/net: psock_fanout: fix clang issues for target arch PowerPC
Date:   Mon,  3 Aug 2020 14:19:44 +0200
Message-Id: <20200803121851.757460525@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121850.306734207@linuxfoundation.org>
References: <20200803121850.306734207@linuxfoundation.org>
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
index bd9b9632c72b0..f496ba3b1cd37 100644
--- a/tools/testing/selftests/net/psock_fanout.c
+++ b/tools/testing/selftests/net/psock_fanout.c
@@ -364,7 +364,8 @@ static int test_datapath(uint16_t typeflags, int port_off,
 	int fds[2], fds_udp[2][2], ret;
 
 	fprintf(stderr, "\ntest: datapath 0x%hx ports %hu,%hu\n",
-		typeflags, PORT_BASE, PORT_BASE + port_off);
+		typeflags, (uint16_t)PORT_BASE,
+		(uint16_t)(PORT_BASE + port_off));
 
 	fds[0] = sock_fanout_open(typeflags, 0);
 	fds[1] = sock_fanout_open(typeflags, 0);
-- 
2.25.1



