Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603F0395C41
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhEaNah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232084AbhEaN20 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:28:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B791A613E4;
        Mon, 31 May 2021 13:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467332;
        bh=ywB2cFMPpqaEpnvYOs74WDZywKlF4/f8tX+kCnLOTaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CbimDNbma2AF+zKQMdwnaMzP3wgXg1dl4amRubchgH+Q9q4s0Tl8Wd+HBRJaI9vky
         8lJz35e8uOmukcD8+o4hdFXatLGMnBE9DYM3pdh4oWIDw5NNj5QUy9IVCOaX54F8Kw
         NXZ8elv/sk/hwg5cKerErY/4dbLfj91LUNhalJrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 4.19 025/116] thunderbolt: dma_port: Fix NVM read buffer bounds and offset issue
Date:   Mon, 31 May 2021 15:13:21 +0200
Message-Id: <20210531130641.023278261@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit b106776080a1cf953a1b2fd50cb2a995db4732be upstream.

Up to 64 bytes of data can be read from NVM in one go. Read address
must be dword aligned. Data is read into a local buffer.

If caller asks to read data starting at an unaligned address then full
dword is anyway read from NVM into a local buffer. Data is then copied
from the local buffer starting at the unaligned offset to the caller
buffer.

In cases where asked data length + unaligned offset is over 64 bytes
we need to make sure we don't read past the 64 bytes in the local
buffer when copying to caller buffer, and make sure that we don't
skip copying unaligned offset bytes from local buffer anymore after
the first round of 64 byte NVM data read.

Fixes: 3e13676862f9 ("thunderbolt: Add support for DMA configuration based mailbox")
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/dma_port.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/thunderbolt/dma_port.c
+++ b/drivers/thunderbolt/dma_port.c
@@ -367,15 +367,15 @@ int dma_port_flash_read(struct tb_dma_po
 			void *buf, size_t size)
 {
 	unsigned int retries = DMA_PORT_RETRIES;
-	unsigned int offset;
-
-	offset = address & 3;
-	address = address & ~3;
 
 	do {
-		u32 nbytes = min_t(u32, size, MAIL_DATA_DWORDS * 4);
+		unsigned int offset;
+		size_t nbytes;
 		int ret;
 
+		offset = address & 3;
+		nbytes = min_t(size_t, size + offset, MAIL_DATA_DWORDS * 4);
+
 		ret = dma_port_flash_read_block(dma, address, dma->buf,
 						ALIGN(nbytes, 4));
 		if (ret) {
@@ -387,6 +387,7 @@ int dma_port_flash_read(struct tb_dma_po
 			return ret;
 		}
 
+		nbytes -= offset;
 		memcpy(buf, dma->buf + offset, nbytes);
 
 		size -= nbytes;


