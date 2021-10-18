Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC8C431C5B
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbhJRNk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233806AbhJRNiv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:38:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2891861356;
        Mon, 18 Oct 2021 13:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563940;
        bh=wIS/+nGfYRfxZzuBiD4QPhkeWqMzIK0zUJQOPbgbDwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=032j5xOLb3wh7Xy+dw5l3GE8RWsJVPyNMAXwLB4bj3KB798zh2G27KLjyEhmPlAYM
         W+ah4JWHANEwS3mDK+GgK9HBA83gccQ7pi0ZhtxuLwReqQM+gRyd1VF4R81stva87l
         Bxze0yMI1MG0cR4CEKS2HcplAPB7v4r8KnHyXVDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 5.4 56/69] pata_legacy: fix a couple uninitialized variable bugs
Date:   Mon, 18 Oct 2021 15:24:54 +0200
Message-Id: <20211018132331.331510851@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
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
@@ -315,7 +315,8 @@ static unsigned int pdc_data_xfer_vlb(st
 			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
 
 		if (unlikely(slop)) {
-			__le32 pad;
+			__le32 pad = 0;
+
 			if (rw == READ) {
 				pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
 				memcpy(buf + buflen - slop, &pad, slop);
@@ -705,7 +706,8 @@ static unsigned int vlb32_data_xfer(stru
 			ioread32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
 
 		if (unlikely(slop)) {
-			__le32 pad;
+			__le32 pad = 0;
+
 			if (rw == WRITE) {
 				memcpy(&pad, buf + buflen - slop, slop);
 				iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);


