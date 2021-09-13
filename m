Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4B74090EE
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343752AbhIMN4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245484AbhIMNym (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:54:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7226060698;
        Mon, 13 Sep 2021 13:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540117;
        bh=YJJ4ExQGkPUrZyQ7xYfyygR2fz3tqJMbXkqJ1hKH7GE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y62K0ycrypECxktX5svJrGCkwBE0ijT3LHcBD7/nVH7cOe9fi95yPg7/Pov9lwC2O
         rV2xCv36x7047PYZLYlc4u3rsCFEUPw6S4OIxJaBGJKjdhAJVZghAYggkXrejoElnI
         nAWQFT1nAEpeNnAtxKTnKV+8P59C6zaj90e9uueE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 026/300] s390/zcrypt: fix wrong offset index for APKA master key valid state
Date:   Mon, 13 Sep 2021 15:11:27 +0200
Message-Id: <20210913131110.200301160@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



