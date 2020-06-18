Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FA61FE0F3
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgFRBu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:50:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731825AbgFRB1P (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:27:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 820EA20776;
        Thu, 18 Jun 2020 01:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443635;
        bh=A8WtP3vMsswmUtj7/Z5FBorv3GFfxNsg9zYgCEOcPjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jx3w52ZGVKL11CwIdZROTimW6a2ZZ5UCDSB4ATaG1KebCS0dkZLIG1KpTDQyGqWGZ
         HpTGB+m1ZZq1uNiSSUEwbOksTZJkXlE6NYW1Nv/9gQw5YuTg0JGSfbnAKfyt3CPSHU
         IABk8HChMHDEpnqpdx3GfIN15nhefPOHjQ5PlLUI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gregory CLEMENT <gregory.clement@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 058/108] tty: n_gsm: Fix SOF skipping
Date:   Wed, 17 Jun 2020 21:25:10 -0400
Message-Id: <20200618012600.608744-58-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gregory CLEMENT <gregory.clement@bootlin.com>

[ Upstream commit 84d6f81c1fb58b56eba81ff0a36cf31946064b40 ]

For at least some modems like the TELIT LE910, skipping SOF makes
transfers blocking indefinitely after a short amount of data
transferred.

Given the small improvement provided by skipping the SOF (just one
byte on about 100 bytes), it seems better to completely remove this
"feature" than make it optional.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Link: https://lore.kernel.org/r/20200512115323.1447922-3-gregory.clement@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index f46bd1af7a10..eabdcfa414aa 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -681,7 +681,6 @@ static void gsm_data_kick(struct gsm_mux *gsm)
 {
 	struct gsm_msg *msg, *nmsg;
 	int len;
-	int skip_sof = 0;
 
 	list_for_each_entry_safe(msg, nmsg, &gsm->tx_list, list) {
 		if (gsm->constipated && msg->addr)
@@ -703,15 +702,10 @@ static void gsm_data_kick(struct gsm_mux *gsm)
 			print_hex_dump_bytes("gsm_data_kick: ",
 					     DUMP_PREFIX_OFFSET,
 					     gsm->txframe, len);
-
-		if (gsm->output(gsm, gsm->txframe + skip_sof,
-						len - skip_sof) < 0)
+		if (gsm->output(gsm, gsm->txframe, len) < 0)
 			break;
 		/* FIXME: Can eliminate one SOF in many more cases */
 		gsm->tx_bytes -= msg->len;
-		/* For a burst of frames skip the extra SOF within the
-		   burst */
-		skip_sof = 1;
 
 		list_del(&msg->list);
 		kfree(msg);
-- 
2.25.1

