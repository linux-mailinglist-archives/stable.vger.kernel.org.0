Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC474272FAC
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729688AbgIUQ7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:59:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729137AbgIUQlZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:41:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAD662399A;
        Mon, 21 Sep 2020 16:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706485;
        bh=1Pc+8kuK6JSFDckznXLJCEEkO2/fb968mCbD/xiDKZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cK0jbY5J8B5U1jV2Ju4y8VdH0vK4Gk3ClkAfcKgT4ULEV3C6xny6AwFz6dgCkMLD5
         gnADzm14cSbSspOH2ykB9N/ErJ9RUNfHH5C7oEdcIMzwye7fqWXFL7Jja2s5qU0xHW
         wYlL0AWqR0LilsW/25CNk/AnSZQ7DFixx5jTxgdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gustav Wiklander <gustavwi@axis.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 24/49] spi: Fix memory leak on splited transfers
Date:   Mon, 21 Sep 2020 18:28:08 +0200
Message-Id: <20200921162035.721679705@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
References: <20200921162034.660953761@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustav Wiklander <gustavwi@axis.com>

[ Upstream commit b59a7ca15464c78ea1ba3b280cfc5ac5ece11ade ]

In the prepare_message callback the bus driver has the
opportunity to split a transfer into smaller chunks.
spi_map_msg is done after prepare_message.

Function spi_res_release releases the splited transfers
in the message. Therefore spi_res_release should be called
after spi_map_msg.

The previous try at this was commit c9ba7a16d0f1
which released the splited transfers after
spi_finalize_current_message had been called.
This introduced a race since the message struct could be
out of scope because the spi_sync call got completed.

Fixes this leak on spi bus driver spi-bcm2835.c when transfer
size is greater than 65532:

Kmemleak:
sg_alloc_table+0x28/0xc8
spi_map_buf+0xa4/0x300
__spi_pump_messages+0x370/0x748
__spi_sync+0x1d4/0x270
spi_sync+0x34/0x58
spi_test_execute_msg+0x60/0x340 [spi_loopback_test]
spi_test_run_iter+0x548/0x578 [spi_loopback_test]
spi_test_run_test+0x94/0x140 [spi_loopback_test]
spi_test_run_tests+0x150/0x180 [spi_loopback_test]
spi_loopback_test_probe+0x50/0xd0 [spi_loopback_test]
spi_drv_probe+0x84/0xe0

Signed-off-by: Gustav Wiklander <gustavwi@axis.com>
Link: https://lore.kernel.org/r/20200908151129.15915-1-gustav.wiklander@axis.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 92e6b6774d98e..1fd529a2d2f6b 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1116,8 +1116,6 @@ out:
 	if (msg->status && ctlr->handle_err)
 		ctlr->handle_err(ctlr, msg);
 
-	spi_res_release(ctlr, msg);
-
 	spi_finalize_current_message(ctlr);
 
 	return ret;
@@ -1375,6 +1373,13 @@ void spi_finalize_current_message(struct spi_controller *ctlr)
 
 	spi_unmap_msg(ctlr, mesg);
 
+	/* In the prepare_messages callback the spi bus has the opportunity to
+	 * split a transfer to smaller chunks.
+	 * Release splited transfers here since spi_map_msg is done on the
+	 * splited transfers.
+	 */
+	spi_res_release(ctlr, mesg);
+
 	if (ctlr->cur_msg_prepared && ctlr->unprepare_message) {
 		ret = ctlr->unprepare_message(ctlr, mesg);
 		if (ret) {
-- 
2.25.1



