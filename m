Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A547D40129F
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239029AbhIFBVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238690AbhIFBV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:21:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B15F9610E9;
        Mon,  6 Sep 2021 01:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891223;
        bh=22+iNXGyu0eCwAJ2X0a28d6/ghXFmPsf4AF7qIF8heo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QExy520exWL9J/O1gDM5YoO1D1XpZQepug6DQafDPTBnUuuCn0p/WmplPfWvbRxSz
         MjcC2wq2e7DbAlXs3PC2kobDy6syRuJZ0qdM8zkK/yZeyz+0PwPZ5V7mfldJqSlFrC
         AUMXDF8NebXJBIHrWxb7mtfFi5G0h8yTs1M9rlBcMCm218Oqeif/BS/TSRycmKv616
         9zaI7NxE55fYmz/wRCylkw9nnxOziEb4HpiK7KyfUp8BySgtuh73Px+rieyXuw6usB
         PI0iGl7y7BzPvGZrspeKN0zFRA9DB8Po/xJm/9jHEX0exrnl0Oy2Lg0B7vrP9ej2It
         1XhXBMY6piDoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 26/47] s390/zcrypt: fix wrong offset index for APKA master key valid state
Date:   Sun,  5 Sep 2021 21:19:30 -0400
Message-Id: <20210906011951.928679-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906011951.928679-1-sashal@kernel.org>
References: <20210906011951.928679-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 8617bb74006252cb2286008afe7d6575a6425857 ]

Tests showed a mismatch between what the CCA tool reports about
the APKA master key state and what's displayed by the zcrypt dd
in sysfs. After some investigation, we found out that the
documentation which was the source for the zcrypt dd implementation
lacks the listing of 3 fields. So this patch now moves the
evaluation of the APKA master key state to the correct offset.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/zcrypt_ccamisc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/crypto/zcrypt_ccamisc.c b/drivers/s390/crypto/zcrypt_ccamisc.c
index bc34bedf9db8..6a3c2b460965 100644
--- a/drivers/s390/crypto/zcrypt_ccamisc.c
+++ b/drivers/s390/crypto/zcrypt_ccamisc.c
@@ -1724,10 +1724,10 @@ static int fetch_cca_info(u16 cardnr, u16 domain, struct cca_info *ci)
 	rlen = vlen = PAGE_SIZE/2;
 	rc = cca_query_crypto_facility(cardnr, domain, "STATICSB",
 				       rarray, &rlen, varray, &vlen);
-	if (rc == 0 && rlen >= 10*8 && vlen >= 240) {
-		ci->new_apka_mk_state = (char) rarray[7*8];
-		ci->cur_apka_mk_state = (char) rarray[8*8];
-		ci->old_apka_mk_state = (char) rarray[9*8];
+	if (rc == 0 && rlen >= 13*8 && vlen >= 240) {
+		ci->new_apka_mk_state = (char) rarray[10*8];
+		ci->cur_apka_mk_state = (char) rarray[11*8];
+		ci->old_apka_mk_state = (char) rarray[12*8];
 		if (ci->old_apka_mk_state == '2')
 			memcpy(&ci->old_apka_mkvp, varray + 208, 8);
 		if (ci->cur_apka_mk_state == '2')
-- 
2.30.2

