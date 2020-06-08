Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13F41F2A51
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732882AbgFIAGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:06:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731086AbgFHXVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:21:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A945F2086A;
        Mon,  8 Jun 2020 23:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658461;
        bh=mH81tB9upTQuVHsacg+7F8lM3/Lh0sT2+FTlCBmknr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mxev9cTEYY9ni3UkUb3KfW78lFGSTVqKBX2BNfS6ujdAMan/PmaL/HkUN3hKE94od
         FAyCkst+MMClvHWJc8w1BsRwIBZel4oy2lae6YLAYbd0Rv4fI3bxUzobJO7NVqgBqE
         l7isgO2sg2Zgsgl6OVYMu1DCVBoOFpCiZd8+jl1c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Devulapally Shiva Krishna <shiva@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 101/175] Crypto/chcr: fix for ccm(aes) failed test
Date:   Mon,  8 Jun 2020 19:17:34 -0400
Message-Id: <20200608231848.3366970-101-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
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
index 01dd418bdadc..fe2eadc0ce83 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -2818,7 +2818,7 @@ static void fill_sec_cpl_for_aead(struct cpl_tx_sec_pdu *sec_cpl,
 	unsigned int mac_mode = CHCR_SCMD_AUTH_MODE_CBCMAC;
 	unsigned int c_id = a_ctx(tfm)->tx_chan_id;
 	unsigned int ccm_xtra;
-	unsigned char tag_offset = 0, auth_offset = 0;
+	unsigned int tag_offset = 0, auth_offset = 0;
 	unsigned int assoclen;
 
 	if (get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_RFC4309)
-- 
2.25.1

