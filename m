Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65996137979
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 23:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbgAJWIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 17:08:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:51182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727554AbgAJWFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jan 2020 17:05:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9F2320721;
        Fri, 10 Jan 2020 22:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578693931;
        bh=iLUaKpuUrImT91v7/zvkTcjyIkYXTInirP57No7GdtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D3Gn6BMjqayaNZrJkkjLthfLPnLxe53CfSd1Lw+7dXq2sDdMehdMhdqogiWFVAEJ9
         rfUwMjpQ+eHF8tS86ZrFV1agLHPr00fVtnKdIkMCzz3hJgEuhMh48zsaFLzCTp8rli
         WRbbz5PIrXdaV3rb+B6zLGzCETORE7c+VVZDn+tE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandra Winter <wintera@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 14/26] s390/qeth: vnicc Fix init to default
Date:   Fri, 10 Jan 2020 17:05:07 -0500
Message-Id: <20200110220519.28250-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200110220519.28250-1-sashal@kernel.org>
References: <20200110220519.28250-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit d1b9ae1864fc3c000e0eb4af8482d78c63e0915a ]

During vnicc_init wanted_char should be compared to cur_char and not
to QETH_VNICC_DEFAULT. Without this patch there is no way to enforce
the default values as desired values.

Note, that it is expected, that a card comes online with default values.
This patch was tested with private card firmware.

Fixes: caa1f0b10d18 ("s390/qeth: add VNICC enable/disable support")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_l2_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index dcbdaa5ce455..b9b47e74d6c2 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -2069,7 +2069,9 @@ static void qeth_l2_vnicc_init(struct qeth_card *card)
 	/* enforce assumed default values and recover settings, if changed  */
 	error |= qeth_l2_vnicc_recover_timeout(card, QETH_VNICC_LEARNING,
 					       timeout);
-	chars_tmp = card->options.vnicc.wanted_chars ^ QETH_VNICC_DEFAULT;
+	/* Change chars, if necessary  */
+	chars_tmp = card->options.vnicc.wanted_chars ^
+		    card->options.vnicc.cur_chars;
 	chars_len = sizeof(card->options.vnicc.wanted_chars) * BITS_PER_BYTE;
 	for_each_set_bit(i, &chars_tmp, chars_len) {
 		vnicc = BIT(i);
-- 
2.20.1

