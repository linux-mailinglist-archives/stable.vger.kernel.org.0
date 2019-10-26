Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD66E5C54
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfJZNUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:20:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbfJZNUQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:20:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89FB9222C4;
        Sat, 26 Oct 2019 13:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096015;
        bh=dDcqdwzmfziiuG8Bhf21mdgTAguQoiR/ydOqSM8oWpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGeurBm1rP3Ufggjp5m6CIlqf+LLvXb/NS4HTeIYN/w2/+wA3O+eQjJTRrIyrkqiA
         SACNx4X8VvtK2Buq1K/6/m9Z4eNMxhkwCVlxPnrAjpuWfWMuInDdeAUjdSKHjibiiG
         2rClICW6On4OWZU+cqmr0V81qYcUB0b/jQby7SXA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandra Winter <wintera@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 30/59] s390/qeth: Fix error handling during VNICC initialization
Date:   Sat, 26 Oct 2019 09:18:41 -0400
Message-Id: <20191026131910.3435-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131910.3435-1-sashal@kernel.org>
References: <20191026131910.3435-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit b528965bcc827dad32a8d21745feaacfc76c9703 ]

Smatch discovered the use of uninitialized variable sup_cmds
in error paths.

Fixes: caa1f0b10d18 ("s390/qeth: add VNICC enable/disable support")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_l2_main.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index c1c35eccd5b65..e571129c364e4 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -2328,10 +2328,10 @@ static bool qeth_l2_vnicc_recover_char(struct qeth_card *card, u32 vnicc,
 static void qeth_l2_vnicc_init(struct qeth_card *card)
 {
 	u32 *timeout = &card->options.vnicc.learning_timeout;
+	bool enable, error = false;
 	unsigned int chars_len, i;
 	unsigned long chars_tmp;
 	u32 sup_cmds, vnicc;
-	bool enable, error;
 
 	QETH_CARD_TEXT(card, 2, "vniccini");
 	/* reset rx_bcast */
@@ -2352,7 +2352,10 @@ static void qeth_l2_vnicc_init(struct qeth_card *card)
 	chars_len = sizeof(card->options.vnicc.sup_chars) * BITS_PER_BYTE;
 	for_each_set_bit(i, &chars_tmp, chars_len) {
 		vnicc = BIT(i);
-		qeth_l2_vnicc_query_cmds(card, vnicc, &sup_cmds);
+		if (qeth_l2_vnicc_query_cmds(card, vnicc, &sup_cmds)) {
+			sup_cmds = 0;
+			error = true;
+		}
 		if (!(sup_cmds & IPA_VNICC_SET_TIMEOUT) ||
 		    !(sup_cmds & IPA_VNICC_GET_TIMEOUT))
 			card->options.vnicc.getset_timeout_sup &= ~vnicc;
@@ -2361,8 +2364,8 @@ static void qeth_l2_vnicc_init(struct qeth_card *card)
 			card->options.vnicc.set_char_sup &= ~vnicc;
 	}
 	/* enforce assumed default values and recover settings, if changed  */
-	error = qeth_l2_vnicc_recover_timeout(card, QETH_VNICC_LEARNING,
-					      timeout);
+	error |= qeth_l2_vnicc_recover_timeout(card, QETH_VNICC_LEARNING,
+					       timeout);
 	chars_tmp = card->options.vnicc.wanted_chars ^ QETH_VNICC_DEFAULT;
 	chars_tmp |= QETH_VNICC_BRIDGE_INVISIBLE;
 	chars_len = sizeof(card->options.vnicc.wanted_chars) * BITS_PER_BYTE;
-- 
2.20.1

