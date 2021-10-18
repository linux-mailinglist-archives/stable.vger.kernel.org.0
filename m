Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0032431B6B
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbhJRNdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:33:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232841AbhJRNba (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:31:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 706B360295;
        Mon, 18 Oct 2021 13:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563727;
        bh=OSSrq3kmOhkyY4KrOeBAVTFjERmPuwDFj8ZvTdyL8G0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nHwmiz3RsZkaPosreaCX4LqQqdSqdeUXNuAvZa1eiJHP9e/foK7HAt++HdiCvfrnw
         PGhxSTMzLTkx6wkaXTHlnRVT5KH5FPddJWGz1qx7PkiDcOPczqZTH7IcIh0uR3MYjf
         wfahckSUWqJFJ0xdFLJmT2S77L1E2M/JeTdfJCEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 4.19 41/50] pata_legacy: fix a couple uninitialized variable bugs
Date:   Mon, 18 Oct 2021 15:24:48 +0200
Message-Id: <20211018132327.882743347@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132326.529486647@linuxfoundation.org>
References: <20211018132326.529486647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 013923477cb311293df9079332cf8b806ed0e6f2 upstream.

The last byte of "pad" is used without being initialized.

Fixes: 55dba3120fbc ("libata: update ->data_xfer hook for ATAPI")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/pata_legacy.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -329,7 +329,8 @@ static unsigned int pdc_data_xfer_vlb(st
 			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
 
 		if (unlikely(slop)) {
-			__le32 pad;
+			__le32 pad = 0;
+
 			if (rw == READ) {
 				pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
 				memcpy(buf + buflen - slop, &pad, slop);
@@ -719,7 +720,8 @@ static unsigned int vlb32_data_xfer(stru
 			ioread32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
 
 		if (unlikely(slop)) {
-			__le32 pad;
+			__le32 pad = 0;
+
 			if (rw == WRITE) {
 				memcpy(&pad, buf + buflen - slop, slop);
 				iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);


