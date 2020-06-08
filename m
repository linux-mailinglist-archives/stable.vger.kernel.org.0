Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E331F28C0
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731522AbgFHXzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:55:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731550AbgFHXXy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:23:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A77A2072F;
        Mon,  8 Jun 2020 23:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658634;
        bh=WI3HQ8lMCRznQ3o12AJnapm9JrQWYpgFcNojPlKXQAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S9QWUKkwZAAdhSy/kzu10zdmKQ87UMJrlDkQ94Pvjq4/XSK9MiVNibpfjasOzKRiF
         Ajz61oQMXp46gHNDi1Z35UF1TVNUuEv2tVA4pGN8raobm1uBUYGzDzvCIzD+zLwH0T
         4fk9HKViClDfKI9ekzBu2zqKZrP5/vgktcQzmyak=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Devulapally Shiva Krishna <shiva@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 057/106] Crypto/chcr: fix for ccm(aes) failed test
Date:   Mon,  8 Jun 2020 19:21:49 -0400
Message-Id: <20200608232238.3368589-57-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232238.3368589-1-sashal@kernel.org>
References: <20200608232238.3368589-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Devulapally Shiva Krishna <shiva@chelsio.com>

[ Upstream commit 10b0c75d7bc19606fa9a62c8ab9180e95c0e0385 ]

The ccm(aes) test fails when req->assoclen > ~240bytes.

The problem is the value assigned to auth_offset is wrong.
As auth_offset is unsigned char, it can take max value as 255.
So fix it by making it unsigned int.

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Devulapally Shiva Krishna <shiva@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/chelsio/chcr_algo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index c435f89f34e3..9b3c259f081d 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -2764,7 +2764,7 @@ static void fill_sec_cpl_for_aead(struct cpl_tx_sec_pdu *sec_cpl,
 	unsigned int mac_mode = CHCR_SCMD_AUTH_MODE_CBCMAC;
 	unsigned int c_id = a_ctx(tfm)->dev->rx_channel_id;
 	unsigned int ccm_xtra;
-	unsigned char tag_offset = 0, auth_offset = 0;
+	unsigned int tag_offset = 0, auth_offset = 0;
 	unsigned int assoclen;
 
 	if (get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_RFC4309)
-- 
2.25.1

