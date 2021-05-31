Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E63A39615F
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbhEaOkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:40:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233570AbhEaOhT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:37:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BF6A61186;
        Mon, 31 May 2021 13:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469094;
        bh=jpVMtKXl1RTVWB0Fw22VVI7MVcQq0LTzIpG/V2Ew1vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QPmF1XPRJk3FeAQlRJgiU8Ufbdj342qNkfW+FHgikbODGKifGsRiVRVlB6JTERvfA
         /JpxmKkcwctjaLMlGUDfYlr6ndNIlkYmwQEhF+kVkwQu8NRvGAaP4kP0IDxaqn//kD
         wh/YNH9Z7gZu22p/hZCZHO5C+39WwaQoVat5sW4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.12 068/296] thunderbolt: usb4: Fix NVM read buffer bounds and offset issue
Date:   Mon, 31 May 2021 15:12:03 +0200
Message-Id: <20210531130706.128519532@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 22c7a18ed5f007faccb7527bc890463763214081 upstream.

Up to 64 bytes of data can be read from NVM in one go.
Read address must be dword aligned. Data is read into a local buffer.

If caller asks to read data starting at an unaligned address then full
dword is anyway read from NVM into a local buffer. Data is then copied
from the local buffer starting at the unaligned offset to the caller
buffer.

In cases where asked data length + unaligned offset is over 64 bytes
we need to make sure we don't read past the 64 bytes in the local
buffer when copying to caller buffer, and make sure that we don't
skip copying unaligned offset bytes from local buffer anymore after
the first round of 64 byte NVM data read.

Fixes: b04079837b20 ("thunderbolt: Add initial support for USB4")
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/usb4.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -68,15 +68,15 @@ static int usb4_do_read_data(u16 address
 	unsigned int retries = USB4_DATA_RETRIES;
 	unsigned int offset;
 
-	offset = address & 3;
-	address = address & ~3;
-
 	do {
-		size_t nbytes = min_t(size_t, size, USB4_DATA_DWORDS * 4);
 		unsigned int dwaddress, dwords;
 		u8 data[USB4_DATA_DWORDS * 4];
+		size_t nbytes;
 		int ret;
 
+		offset = address & 3;
+		nbytes = min_t(size_t, size + offset, USB4_DATA_DWORDS * 4);
+
 		dwaddress = address / 4;
 		dwords = ALIGN(nbytes, 4) / 4;
 
@@ -87,6 +87,7 @@ static int usb4_do_read_data(u16 address
 			return ret;
 		}
 
+		nbytes -= offset;
 		memcpy(buf, data + offset, nbytes);
 
 		size -= nbytes;


