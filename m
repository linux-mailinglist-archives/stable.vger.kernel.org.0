Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2C71797BE
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390146AbfG2Tsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:48:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390142AbfG2Tse (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:48:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63052205F4;
        Mon, 29 Jul 2019 19:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429713;
        bh=swzzTSWVDkECQUft7G79O2Qg7RSN7yfYSx8KiYioYDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hurK1f/UPT6JlWb5KcHrNCoBnn2ChOGMOLHA/UNN3ZPpH9T9/P91xL1WCN3fJ5cDH
         +9CC2tbPyez1mve3lg8ZvlmmFw6nze2KQAx0NTXJfeFnJxtGD9ysb1+FOYUNnK2Fqa
         8dpSeTO8kc5hS16HJgW9Gb98VJjE5QfOfxKi7BOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mao Wenan <maowenan@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 034/215] staging: kpc2000: report error status to spi core
Date:   Mon, 29 Jul 2019 21:20:30 +0200
Message-Id: <20190729190746.218831662@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9164f336311863d3e9f80840f4a1cce2aee293bd ]

There is an error condition that's not reported to
the spi core in kp_spi_transfer_one_message().
It should restore status value to m->status, and
return it in error path.

Signed-off-by: Mao Wenan <maowenan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/kpc2000/kpc_spi/spi_driver.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/kpc2000/kpc_spi/spi_driver.c b/drivers/staging/kpc2000/kpc_spi/spi_driver.c
index 86df16547a92..2f535022dc03 100644
--- a/drivers/staging/kpc2000/kpc_spi/spi_driver.c
+++ b/drivers/staging/kpc2000/kpc_spi/spi_driver.c
@@ -333,7 +333,7 @@ kp_spi_transfer_one_message(struct spi_master *master, struct spi_message *m)
     list_for_each_entry(transfer, &m->transfers, transfer_list) {
         if (transfer->tx_buf == NULL && transfer->rx_buf == NULL && transfer->len) {
             status = -EINVAL;
-            break;
+            goto error;
         }
         
         /* transfer */
@@ -371,7 +371,7 @@ kp_spi_transfer_one_message(struct spi_master *master, struct spi_message *m)
             
             if (count != transfer->len) {
                 status = -EIO;
-                break;
+                goto error;
             }
         }
         
@@ -389,6 +389,10 @@ kp_spi_transfer_one_message(struct spi_master *master, struct spi_message *m)
     /* done work */
     spi_finalize_current_message(master);
     return 0;
+
+ error:
+    m->status = status;
+    return status;
 }
 
 static void
-- 
2.20.1



