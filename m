Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37BF4999B8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455972AbiAXVhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390879AbiAXVM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:12:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80549C06E002;
        Mon, 24 Jan 2022 12:10:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48107B811F9;
        Mon, 24 Jan 2022 20:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EECDC340E5;
        Mon, 24 Jan 2022 20:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055025;
        bh=zzKbzuFubpHHemI4OYJIDmPJ6QVU/JspdXhTqkh54ZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SRT59O+HW2rYu92XRhkzAR8MOLEETkFCHsaKioSykMF2CJnAMF6I7F8GZrCqF1AQC
         jFl3rlHXlg7Q5dWTOG8aVzSy17x++u/GJlnYyax1LWDOaJyFOMp8qYXHmrevmvPm18
         1De1OMsbhcWzbEHngCsWc47E+Y1rvxW3QrYYsDfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 017/846] mtd: rawnand: davinci: Avoid duplicated page read
Date:   Mon, 24 Jan 2022 19:32:14 +0100
Message-Id: <20220124184101.509750050@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 9c9d709965385de5a99f84b14bd5860e1541729e upstream.

The function nand_davinci_read_page_hwecc_oob_first() first reads the
OOB data, extracts the ECC information, programs the ECC hardware before
reading the actual data in a loop.

Right after the OOB data was read, it called nand_read_page_op() to
reset the read cursor to the beginning of the page. This caused the
first page to be read twice: in that call, and later in the loop.

Address that issue by changing the call to nand_read_page_op() to
nand_change_read_column_op(), which will only reset the read cursor.

Cc: <stable@vger.kernel.org> # v5.2
Fixes: a0ac778eb82c ("mtd: rawnand: ingenic: Add support for the JZ4740")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20211016132228.40254-2-paul@crapouillou.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/davinci_nand.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/davinci_nand.c
+++ b/drivers/mtd/nand/raw/davinci_nand.c
@@ -401,7 +401,8 @@ static int nand_davinci_read_page_hwecc_
 	if (ret)
 		return ret;
 
-	ret = nand_read_page_op(chip, page, 0, NULL, 0);
+	/* Move read cursor to start of page */
+	ret = nand_change_read_column_op(chip, 0, NULL, 0, false);
 	if (ret)
 		return ret;
 


