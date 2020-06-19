Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE31201266
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405360AbgFSPwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:52:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390743AbgFSPXT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:23:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D9C821548;
        Fri, 19 Jun 2020 15:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580198;
        bh=8M0BVirU0WrdSQ2GntXLcUZw8QqQhLkv8Jmputer5H8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t5VXTrw9/mrY45p7vrxed5/7Gw737AweFHxTOEiYCaQKR3YengPZa/btCkP/Z+KWo
         s5/jH6n0ui3AxFKHnSxNVMmgyMJ63hOVwDofuuAWo00I+yf6ZmycdV5Fd3hi18E00Q
         1VP3euFRHsTnJwQRgrSqoVAFPT8UoJ15bWRxeRu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 160/376] mips: cm: Fix an invalid error code of INTVN_*_ERR
Date:   Fri, 19 Jun 2020 16:31:18 +0200
Message-Id: <20200619141717.895785728@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index cdb93ed91cde..361bfc91a0e6 100644
--- a/arch/mips/kernel/mips-cm.c
+++ b/arch/mips/kernel/mips-cm.c
@@ -119,9 +119,9 @@ static char *cm2_causes[32] = {
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



