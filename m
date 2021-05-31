Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F924395FFB
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbhEaOR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:17:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233780AbhEaOPj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:15:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55A5F6147D;
        Mon, 31 May 2021 13:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468573;
        bh=zaqc71jmfjSYAhxJFkH0vlK71+sUttf04PqO/8IWQqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wyK2zyYRmm2jfnNaQHXlfaibCAGYb/ugR4lcPcqXAWWxylRLddsyLcC+ZZsSK+xvO
         m0d95e3agqE+PrIb4TSaAfDzNyiDNcHftXw2i6tAI81ovwms7pMEgUlADOAt0AYU+N
         q5d8Km25IJIZq/UbQJhKtIIrRCf9MT9BP6DzEaKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.4 041/177] thunderbolt: dma_port: Fix NVM read buffer bounds and offset issue
Date:   Mon, 31 May 2021 15:13:18 +0200
Message-Id: <20210531130649.344025343@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
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
@@ -364,15 +364,15 @@ int dma_port_flash_read(struct tb_dma_po
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
@@ -384,6 +384,7 @@ int dma_port_flash_read(struct tb_dma_po
 			return ret;
 		}
 
+		nbytes -= offset;
 		memcpy(buf, dma->buf + offset, nbytes);
 
 		size -= nbytes;


