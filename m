Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A60E1198FE6
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731227AbgCaJHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:07:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731205AbgCaJHT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:07:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A345520675;
        Tue, 31 Mar 2020 09:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645639;
        bh=fonGa2Jo6J/Aqu3Gec9US4klKsW7E93xxowFHt7fUKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQKRZXeqOzJuYjZAzQcqeB0Wi0PYCouLyrpDxhcbAFbl50hz7Qozp0rzsmvdxAOqc
         ynk9UZ54QKLhmw6zINOhxevlBeqR/O/g5hT60dNUtTt8CyMrygGHohC6SUJpL/Rage
         oxIglGeTxk5xECxz4DQu6jJ22vZWXt1T4KJY1GlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 077/170] dpaa_eth: Remove unnecessary boolean expression in dpaa_get_headroom
Date:   Tue, 31 Mar 2020 10:58:11 +0200
Message-Id: <20200331085432.504560513@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 7395f62d95aafacdb9bd4996ec2f95b4a655d7e6 ]

Clang warns:

drivers/net/ethernet/freescale/dpaa/dpaa_eth.c:2860:9: warning:
converting the result of '?:' with integer constants to a boolean always
evaluates to 'true' [-Wtautological-constant-compare]
        return DPAA_FD_DATA_ALIGNMENT ? ALIGN(headroom,
               ^
drivers/net/ethernet/freescale/dpaa/dpaa_eth.c:131:34: note: expanded
from macro 'DPAA_FD_DATA_ALIGNMENT'
\#define DPAA_FD_DATA_ALIGNMENT  (fman_has_errata_a050385() ? 64 : 16)
                                 ^
1 warning generated.

This was exposed by commit 3c68b8fffb48 ("dpaa_eth: FMan erratum A050385
workaround") even though it appears to have been an issue since the
introductory commit 9ad1a3749333 ("dpaa_eth: add support for DPAA
Ethernet") since DPAA_FD_DATA_ALIGNMENT has never been able to be zero.

Just replace the whole boolean expression with the true branch, as it is
always been true.

Link: https://github.com/ClangBuiltLinux/linux/issues/928
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 36e2e28fa6e38..1e8dcae5f4b40 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2845,9 +2845,7 @@ static inline u16 dpaa_get_headroom(struct dpaa_buffer_layout *bl)
 	headroom = (u16)(bl->priv_data_size + DPAA_PARSE_RESULTS_SIZE +
 		DPAA_TIME_STAMP_SIZE + DPAA_HASH_RESULTS_SIZE);
 
-	return DPAA_FD_DATA_ALIGNMENT ? ALIGN(headroom,
-					      DPAA_FD_DATA_ALIGNMENT) :
-					headroom;
+	return ALIGN(headroom, DPAA_FD_DATA_ALIGNMENT);
 }
 
 static int dpaa_eth_probe(struct platform_device *pdev)
-- 
2.20.1



