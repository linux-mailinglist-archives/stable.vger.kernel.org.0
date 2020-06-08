Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4951F2563
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731927AbgFHX0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:26:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731915AbgFHX0E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:26:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E9072068D;
        Mon,  8 Jun 2020 23:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658763;
        bh=XPPEpC2yTAW6izKCvYgVtt0TlCBTsFss0avmq3pxYOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nsma6UZ04GbR4wjARCTcEau6YRgz7PrKjU99/uO9xgPr5YRau5cRv4HXMX6bghE7d
         ObOO0u+lYMCnF5MYh3qX6fdgbdlwLl/p4ylphdhZr+2arcrL3GcQ9vh6kSlB2qRxvd
         3QNWb4vH1Pre/iOBjHNHxZ5N4fKyiIsBDwVbCpBE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 46/72] mips: cm: Fix an invalid error code of INTVN_*_ERR
Date:   Mon,  8 Jun 2020 19:24:34 -0400
Message-Id: <20200608232500.3369581-46-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232500.3369581-1-sashal@kernel.org>
References: <20200608232500.3369581-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 8a0efb8b101665a843205eab3d67ab09cb2d9a8d ]

Commit 3885c2b463f6 ("MIPS: CM: Add support for reporting CM cache
errors") adds cm2_causes[] array with map of error type ID and
pointers to the short description string. There is a mistake in
the table, since according to MIPS32 manual CM2_ERROR_TYPE = {17,18}
correspond to INTVN_WR_ERR and INTVN_RD_ERR, while the table
claims they have {0x17,0x18} codes. This is obviously hex-dec
copy-paste bug. Moreover codes {0x18 - 0x1a} indicate L2 ECC errors.

Fixes: 3885c2b463f6 ("MIPS: CM: Add support for reporting CM cache errors")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: linux-pm@vger.kernel.org
Cc: devicetree@vger.kernel.org
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/mips-cm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kernel/mips-cm.c b/arch/mips/kernel/mips-cm.c
index 7f3f136572de..50d3d74001cb 100644
--- a/arch/mips/kernel/mips-cm.c
+++ b/arch/mips/kernel/mips-cm.c
@@ -123,9 +123,9 @@ static char *cm2_causes[32] = {
 	"COH_RD_ERR", "MMIO_WR_ERR", "MMIO_RD_ERR", "0x07",
 	"0x08", "0x09", "0x0a", "0x0b",
 	"0x0c", "0x0d", "0x0e", "0x0f",
-	"0x10", "0x11", "0x12", "0x13",
-	"0x14", "0x15", "0x16", "INTVN_WR_ERR",
-	"INTVN_RD_ERR", "0x19", "0x1a", "0x1b",
+	"0x10", "INTVN_WR_ERR", "INTVN_RD_ERR", "0x13",
+	"0x14", "0x15", "0x16", "0x17",
+	"0x18", "0x19", "0x1a", "0x1b",
 	"0x1c", "0x1d", "0x1e", "0x1f"
 };
 
-- 
2.25.1

