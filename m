Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325EF1F30B6
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 03:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgFIBCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 21:02:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728063AbgFHXH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:07:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1C772085B;
        Mon,  8 Jun 2020 23:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657677;
        bh=QgvaHlKB1yX190WbTK1ySP3MSiCF87c2YD+6T1vhHIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cp6Q9xApoEf5JFdqgX3tW7DN6ZdtY06pnyRem5nYEWBZfODztn0gKxEF1uS8cKc9u
         6X2axHSeK5N/ZKYbvOnTmZn+XH26ncp8C5m+OT3QxPrv9VEaXVrUkBiZ1A7MQydjSe
         MJEg0j8XNGdLusAHZYnwSd7nQ0raHvyA8ZzEJJBc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ayush Sawal <ayush.sawal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 085/274] Crypto/chcr: Fixes a coccinile check error
Date:   Mon,  8 Jun 2020 19:02:58 -0400
Message-Id: <20200608230607.3361041-85-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

