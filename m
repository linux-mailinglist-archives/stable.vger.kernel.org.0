Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43169401318
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239878AbhIFBYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:24:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239495AbhIFBW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:22:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E75361104;
        Mon,  6 Sep 2021 01:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891285;
        bh=YJJ4ExQGkPUrZyQ7xYfyygR2fz3tqJMbXkqJ1hKH7GE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SIwBADsRX3DS0guiAqVqbIUb9INQ1QZD07UjI7W//PqinS+Y81RhpRyx88+WIHK3N
         tY4NtqQWkGy9pyOoaanWogkDc7bzZIKEANPaPRQ4BPi0lLIDkvtA1P7PV3J1ADPx+r
         gkDPjfLtDJyizZXQqfrIif5XPpTIn2UZgzm1sH96cQ7Z2xq7ex2FwKCAY7iAjB3Jfb
         jUux4EIXJe5I6fG4u6OoWQMC+UnlSYkzSEBV48gF7a2L5U6ULQ32nApxkTdWUg0ohH
         +Iaw2OEuHCPqiRChNMcvuNLB8CpCLlUygP28T7R+VQlQ4UpdlR+9/m6UEMbXXWR8aA
         PL9qPXz/Cwnog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 26/46] s390/zcrypt: fix wrong offset index for APKA master key valid state
Date:   Sun,  5 Sep 2021 21:20:31 -0400
Message-Id: <20210906012052.929174-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012052.929174-1-sashal@kernel.org>
References: <20210906012052.929174-1-sashal@kernel.org>
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
index d68c0ed5e0dd..f5d0212fb4fe 100644
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

