Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99A8F137932
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 23:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgAJWGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 17:06:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:52382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728060AbgAJWGC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jan 2020 17:06:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A349520866;
        Fri, 10 Jan 2020 22:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578693961;
        bh=dBxleWCteLB8i3+5XnkNePFWIdmqegJ4IrwyoOTGAuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wnbHsYcmcYvHFyG+y/XAE5ODFLamGIqptA78ehwA/Z+Ghj9S+XpqZBSWziybl07cE
         NAZLhn0tMbnMeDJhfEgR5zQfZQvuJ4UTCdT0UNqR68mt7lm/yjsQJ/nRVHZNw9cpbt
         u4bbSHBRy55/iBXHLYXqRrVyOPI7k0dg+NSe4HnI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandra Winter <wintera@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/11] s390/qeth: fix false reporting of VNIC CHAR config failure
Date:   Fri, 10 Jan 2020 17:05:49 -0500
Message-Id: <20200110220556.28505-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200110220556.28505-1-sashal@kernel.org>
References: <20200110220556.28505-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit 68c57bfd52836e31bff33e5e1fc64029749d2c35 ]

Symptom: Error message "Configuring the VNIC characteristics failed"
in dmesg whenever an OSA interface on z15 is set online.

The VNIC characteristics get re-programmed when setting a L2 device
online. This follows the selected 'wanted' characteristics - with the
exception that the INVISIBLE characteristic unconditionally gets
switched off.

For devices that don't support INVISIBLE (ie. OSA), the resulting
IO failure raises a noisy error message
("Configuring the VNIC characteristics failed").
For IQD, INVISIBLE is off by default anyways.

So don't unnecessarily special-case the INVISIBLE characteristic, and
thereby suppress the misleading error message on OSA devices.

Fixes: caa1f0b10d18 ("s390/qeth: add VNICC enable/disable support")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_l2_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 95669d47c389..66bc6f1ffd34 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -2367,7 +2367,6 @@ static void qeth_l2_vnicc_init(struct qeth_card *card)
 	error = qeth_l2_vnicc_recover_timeout(card, QETH_VNICC_LEARNING,
 					      timeout);
 	chars_tmp = card->options.vnicc.wanted_chars ^ QETH_VNICC_DEFAULT;
-	chars_tmp |= QETH_VNICC_BRIDGE_INVISIBLE;
 	chars_len = sizeof(card->options.vnicc.wanted_chars) * BITS_PER_BYTE;
 	for_each_set_bit(i, &chars_tmp, chars_len) {
 		vnicc = BIT(i);
-- 
2.20.1

