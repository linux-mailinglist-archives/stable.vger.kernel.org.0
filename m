Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 943A914B74D
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgA1ONJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:13:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:34732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729113AbgA1ONJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:13:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4292A2468A;
        Tue, 28 Jan 2020 14:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220788;
        bh=cXhWVoe8l7SesCfbvpKHyaadgu/BrM44Hjki1zDwezM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zL2TP4ug485Eueab8DY7W+BV89oLPJu+dL/ZTBe9AJ7SchYvyey/5PLE6eXbZKXmP
         Mocji6R4iHTkig83YSTdsVSuw0Etmc5POs/wfGCj8Lg5xLR39dFZIY2wuBKZ3kpBlI
         jGBERp3/TciZM076lSSpL64ST5WDVMdepEUkA2pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antonio Borneo <antonio.borneo@st.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 146/183] net: stmmac: fix length of PTP clocks name string
Date:   Tue, 28 Jan 2020 15:06:05 +0100
Message-Id: <20200128135844.326536543@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antonio Borneo <antonio.borneo@st.com>

[ Upstream commit 5da202c88f8c355ad79bc2e8eb582e6d433060e7 ]

The field "name" in struct ptp_clock_info has a fixed size of 16
chars and is used as zero terminated string by clock_name_show()
in drivers/ptp/ptp_sysfs.c
The current initialization value requires 17 chars to fit also the
null termination, and this causes overflow to the next bytes in
the struct when the string is read as null terminated:
	hexdump -C /sys/class/ptp/ptp0/clock_name
	00000000  73 74 6d 6d 61 63 5f 70  74 70 5f 63 6c 6f 63 6b  |stmmac_ptp_clock|
	00000010  a0 ac b9 03 0a                                    |.....|
where the extra 4 bytes (excluding the newline) after the string
represent the integer 0x03b9aca0 = 62500000 assigned to the field
"max_adj" that follows "name" in the same struct.

There is no strict requirement for the "name" content and in the
comment in ptp_clock_kernel.h it's reported it should just be 'A
short "friendly name" to identify the clock'.
Replace it with "stmmac ptp".

Signed-off-by: Antonio Borneo <antonio.borneo@st.com>
Fixes: 92ba6888510c ("stmmac: add the support for PTP hw clock driver")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index 170a18b61281d..147c9f8cee7f7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -157,7 +157,7 @@ static int stmmac_enable(struct ptp_clock_info *ptp,
 /* structure describing a PTP hardware clock */
 static struct ptp_clock_info stmmac_ptp_clock_ops = {
 	.owner = THIS_MODULE,
-	.name = "stmmac_ptp_clock",
+	.name = "stmmac ptp",
 	.max_adj = 62500000,
 	.n_alarm = 0,
 	.n_ext_ts = 0,
-- 
2.20.1



