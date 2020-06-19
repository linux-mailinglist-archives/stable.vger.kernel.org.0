Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C13A20130F
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392238AbgFSPUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392407AbgFSPUG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:20:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1785121927;
        Fri, 19 Jun 2020 15:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580005;
        bh=QgvaHlKB1yX190WbTK1ySP3MSiCF87c2YD+6T1vhHIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hxLpoVjyYGCj3Rk1ITRKnfcfo7+LjLMdV5Blg8jSrDjtdc+jQCuAjLxiR2hrk6uwC
         PS4a6qO2R0icugqONMPwaoYzIpzM84k5t4IH64aT849I3xWehtGNFHvytg2YZl38Q4
         4WJgWZyl9sWCn/6w3/N9aiTJXTVkNhdURVh+c6v8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ayush Sawal <ayush.sawal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 079/376] Crypto/chcr: Fixes a coccinile check error
Date:   Fri, 19 Jun 2020 16:29:57 +0200
Message-Id: <20200619141714.086375913@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>

[ Upstream commit 055be6865dea6743b090d1c55c8d21a5e01df201 ]

This fixes an error observed after running coccinile check.
drivers/crypto/chelsio/chcr_algo.c:1462:5-8: Unneeded variable:
"err". Return "0" on line 1480

This line is missed in the commit 567be3a5d227 ("crypto:
chelsio - Use multiple txq/rxq per tfm to process the requests").

Fixes: 567be3a5d227 ("crypto:
chelsio - Use multiple txq/rxq per tfm to process the requests").

V1->V2
-Modified subject.

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/chelsio/chcr_algo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index c29b80dd30d8..5a2d9ee9348d 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -1443,6 +1443,7 @@ static int chcr_device_init(struct chcr_context *ctx)
 	if (!ctx->dev) {
 		u_ctx = assign_chcr_device();
 		if (!u_ctx) {
+			err = -ENXIO;
 			pr_err("chcr device assignment fails\n");
 			goto out;
 		}
-- 
2.25.1



