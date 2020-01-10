Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1508137980
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 23:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbgAJWFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 17:05:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:51110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727526AbgAJWF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jan 2020 17:05:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7990520842;
        Fri, 10 Jan 2020 22:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578693929;
        bh=k0j77J0+Hj7BvtVZoT38fVZd1GFh/VHHvV/yUuG86AY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CcK1Pb1YVzsAPiuwN+SLPM6x1NkXrzqUxNG+p7a6m57Rk4IsGmhFAOHufOdOOBYvx
         ByUzNpZgn5nRHS/KwoEW6UCL3DeBzUAxmEokd3D2E+ITB84/u5yBbHFJrqHNZ6bGfv
         ptwnxY8pz2G1Mfy5EOeAyNJcdNFPMlRXQiXjeBWY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandra Winter <wintera@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/26] s390/qeth: fix false reporting of VNIC CHAR config failure
Date:   Fri, 10 Jan 2020 17:05:05 -0500
Message-Id: <20200110220519.28250-7-sashal@kernel.org>
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
index 4224a3b7cd07..5272a4c36db8 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -2071,7 +2071,6 @@ static void qeth_l2_vnicc_init(struct qeth_card *card)
 	error |= qeth_l2_vnicc_recover_timeout(card, QETH_VNICC_LEARNING,
 					       timeout);
 	chars_tmp = card->options.vnicc.wanted_chars ^ QETH_VNICC_DEFAULT;
-	chars_tmp |= QETH_VNICC_BRIDGE_INVISIBLE;
 	chars_len = sizeof(card->options.vnicc.wanted_chars) * BITS_PER_BYTE;
 	for_each_set_bit(i, &chars_tmp, chars_len) {
 		vnicc = BIT(i);
-- 
2.20.1

