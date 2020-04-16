Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9491ACA1C
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410368AbgDPPb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:31:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392172AbgDPNm5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:42:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0374218AC;
        Thu, 16 Apr 2020 13:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044577;
        bh=51H9TY8V5noS4FlXlFD3P5jsli5RDi0dx8xUt4ONeBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RO3F9tM+CpF2bBRm3ZvXBaf+R8Jx3Z3D0MRpUX7ag0gnuCWB48IT0mp8PghiT3zkJ
         cejCm3QukPhCkyvmu8KmZHVTQXsRu4Q9gmZSfin6z5eAQRsYd3pQqDhhqNbagYsu+e
         mSnFFQnl0QZCdrJuqsP5ysHbF9KtxOrh/dVG0D6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 017/232] selftests/net: add definition for SOL_DCCP to fix compilation errors for old libc
Date:   Thu, 16 Apr 2020 15:21:51 +0200
Message-Id: <20200416131318.487927919@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit 83a9b6f639e9f6b632337f9776de17d51d969c77 ]

Many systems build/test up-to-date kernels with older libcs, and
an older glibc (2.17) lacks the definition of SOL_DCCP in
/usr/include/bits/socket.h (it was added in the 4.6 timeframe).

Adding the definition to the test program avoids a compilation
failure that gets in the way of building tools/testing/selftests/net.
The test itself will work once the definition is added; either
skipping due to DCCP not being configured in the kernel under test
or passing, so there are no other more up-to-date glibc dependencies
here it seems beyond that missing definition.

Fixes: 11fb60d1089f ("selftests: net: reuseport_addr_any: add DCCP")
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/reuseport_addr_any.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/reuseport_addr_any.c b/tools/testing/selftests/net/reuseport_addr_any.c
index c6233935fed14..b8475cb29be7a 100644
--- a/tools/testing/selftests/net/reuseport_addr_any.c
+++ b/tools/testing/selftests/net/reuseport_addr_any.c
@@ -21,6 +21,10 @@
 #include <sys/socket.h>
 #include <unistd.h>
 
+#ifndef SOL_DCCP
+#define SOL_DCCP 269
+#endif
+
 static const char *IP4_ADDR = "127.0.0.1";
 static const char *IP6_ADDR = "::1";
 static const char *IP4_MAPPED6 = "::ffff:127.0.0.1";
-- 
2.20.1



