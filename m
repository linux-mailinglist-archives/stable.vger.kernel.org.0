Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5467113FD2D
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390970AbgAPXW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:22:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:50984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390953AbgAPXW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:22:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E6B22072E;
        Thu, 16 Jan 2020 23:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216978;
        bh=MNpadv6oG1yu1rgMedCa6a7fBv1EwM++aYTJQL9Y5y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yM9l2XLEhhsEKmIt8+eyS2uVK4SiINKVXSNy0Vtkm4Zh/RU+9N6eWCJieMdQoxFRw
         GmczjIpT4V9l441TXNoEnYuvaBA1jHMFkQRC+HLQekHuSUYWASrFXNMJT8bAvuov2t
         XoyJVW98ZiA+UhKCS8Obl0PPFiVhd+A+1s8h0Ap8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phani Kiran Hemadri <phemadri@marvell.com>,
        Srikanth Jampala <jsrikanth@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 098/203] crypto: cavium/nitrox - fix firmware assignment to AE cores
Date:   Fri, 17 Jan 2020 00:16:55 +0100
Message-Id: <20200116231754.201070520@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phani Kiran Hemadri <phemadri@marvell.com>

commit 6a97a99db848748d582d79447f7c9c330ce1688e upstream.

This patch fixes assigning UCD block number of Asymmetric crypto
firmware to AE cores of CNN55XX device.

Fixes: a7268c4d4205 ("crypto: cavium/nitrox - Add support for loading asymmetric crypto firmware")
Signed-off-by: Phani Kiran Hemadri <phemadri@marvell.com>
Reviewed-by: Srikanth Jampala <jsrikanth@marvell.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/cavium/nitrox/nitrox_main.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -103,8 +103,7 @@ static void write_to_ucd_unit(struct nit
 	offset = UCD_UCODE_LOAD_BLOCK_NUM;
 	nitrox_write_csr(ndev, offset, block_num);
 
-	code_size = ucode_size;
-	code_size = roundup(code_size, 8);
+	code_size = roundup(ucode_size, 16);
 	while (code_size) {
 		data = ucode_data[i];
 		/* write 8 bytes at a time */
@@ -220,11 +219,11 @@ static int nitrox_load_fw(struct nitrox_
 
 	/* write block number and firmware length
 	 * bit:<2:0> block number
-	 * bit:3 is set SE uses 32KB microcode
-	 * bit:3 is clear SE uses 64KB microcode
+	 * bit:3 is set AE uses 32KB microcode
+	 * bit:3 is clear AE uses 64KB microcode
 	 */
 	core_2_eid_val.value = 0ULL;
-	core_2_eid_val.ucode_blk = 0;
+	core_2_eid_val.ucode_blk = 2;
 	if (ucode_size <= CNN55XX_UCD_BLOCK_SIZE)
 		core_2_eid_val.ucode_len = 1;
 	else


