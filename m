Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4D981AFF
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbfHENLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729841AbfHENLH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:11:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45AFB216F4;
        Mon,  5 Aug 2019 13:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010666;
        bh=4pL1hx2ppMTBaKCpsGaTGvaIoDclQ1WBXEy5XCKPB3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VLFnHfDsHwnrnaI879Qcg6q6PKRRMnPdQxt/SyXMIbvYENO/fJxBj/O7pFhJyarBY
         iJKZAsvDSuH9E4DlqKV+Z20BRVT0T/rChq/4UVfBQkeAqECV0hVlyPylELF3zPpqQn
         2WE2ykxgDUVm9eNignUtXQ6xDOmI8YUPOw+TCxNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 4.19 50/74] mtd: rawnand: micron: handle on-die "ECC-off" devices correctly
Date:   Mon,  5 Aug 2019 15:03:03 +0200
Message-Id: <20190805124939.943312281@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

commit 8493b2a06fc5b77ef5c579dc32b12761f7b7a84c upstream.

Some devices are not supposed to support on-die ECC but experience
shows that internal ECC machinery can actually be enabled through the
"SET FEATURE (EFh)" command, even if a read of the "READ ID Parameter
Tables" returns that it is not.

Currently, the driver checks the "READ ID Parameter" field directly
after having enabled the feature. If the check fails it returns
immediately but leaves the ECC on. When using buggy chips like
MT29F2G08ABAGA and MT29F2G08ABBGA, all future read/program cycles will
go through the on-die ECC, confusing the host controller which is
supposed to be the one handling correction.

To address this in a common way we need to turn off the on-die ECC
directly after reading the "READ ID Parameter" and before checking the
"ECC status".

Cc: stable@vger.kernel.org
Fixes: dbc44edbf833 ("mtd: rawnand: micron: Fix on-die ECC detection logic")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/nand_micron.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/raw/nand_micron.c
+++ b/drivers/mtd/nand/raw/nand_micron.c
@@ -400,6 +400,14 @@ static int micron_supports_on_die_ecc(st
 	    (chip->id.data[4] & MICRON_ID_INTERNAL_ECC_MASK) != 0x2)
 		return MICRON_ON_DIE_UNSUPPORTED;
 
+	/*
+	 * It seems that there are devices which do not support ECC officially.
+	 * At least the MT29F2G08ABAGA / MT29F2G08ABBGA devices supports
+	 * enabling the ECC feature but don't reflect that to the READ_ID table.
+	 * So we have to guarantee that we disable the ECC feature directly
+	 * after we did the READ_ID table command. Later we can evaluate the
+	 * ECC_ENABLE support.
+	 */
 	ret = micron_nand_on_die_ecc_setup(chip, true);
 	if (ret)
 		return MICRON_ON_DIE_UNSUPPORTED;
@@ -408,13 +416,13 @@ static int micron_supports_on_die_ecc(st
 	if (ret)
 		return MICRON_ON_DIE_UNSUPPORTED;
 
-	if (!(id[4] & MICRON_ID_ECC_ENABLED))
-		return MICRON_ON_DIE_UNSUPPORTED;
-
 	ret = micron_nand_on_die_ecc_setup(chip, false);
 	if (ret)
 		return MICRON_ON_DIE_UNSUPPORTED;
 
+	if (!(id[4] & MICRON_ID_ECC_ENABLED))
+		return MICRON_ON_DIE_UNSUPPORTED;
+
 	ret = nand_readid_op(chip, 0, id, sizeof(id));
 	if (ret)
 		return MICRON_ON_DIE_UNSUPPORTED;


