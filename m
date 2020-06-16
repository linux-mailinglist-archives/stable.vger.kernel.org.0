Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBBA1FB69B
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729916AbgFPPiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:38:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730792AbgFPPiu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:38:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD3D021534;
        Tue, 16 Jun 2020 15:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321930;
        bh=KcTahHkVoRsy+IsGjmhF3qgFZbKsfTtARSuBnB9D+Eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QAUDUrYK6bU/BxMc53wZA1ty2yHEaP97GchYcqC6RWJ+XX7oQ5/Eqdd3/Qxm5SxbU
         11VD1ErcGCp0Vm5O7GERiMwJ+uqgwsVwz384hJs32SpPrkuPsz8+fh99A0tpZb17Qd
         x4E+mDm5gFES80j86AUM47zRFWx3NWaCSno3l5YI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 070/134] spi: Fix controller unregister order
Date:   Tue, 16 Jun 2020 17:34:14 +0200
Message-Id: <20200616153104.134143873@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 84855678add8aba927faf76bc2f130a40f94b6f7 upstream.

When an SPI controller unregisters, it unbinds all its slave devices.
For this, their drivers may need to access the SPI bus, e.g. to quiesce
interrupts.

However since commit ffbbdd21329f ("spi: create a message queueing
infrastructure"), spi_destroy_queue() is executed before unbinding the
slaves.  It sets ctlr->running = false, thereby preventing SPI bus
access and causing unbinding of slave devices to fail.

Fix by unbinding slaves before calling spi_destroy_queue().

Fixes: ffbbdd21329f ("spi: create a message queueing infrastructure")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v3.4+
Cc: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/8aaf9d44c153fe233b17bc2dec4eb679898d7e7b.1589557526.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2581,6 +2581,8 @@ void spi_unregister_controller(struct sp
 	struct spi_controller *found;
 	int id = ctlr->bus_num;
 
+	device_for_each_child(&ctlr->dev, NULL, __unregister);
+
 	/* First make sure that this controller was ever added */
 	mutex_lock(&board_lock);
 	found = idr_find(&spi_master_idr, id);
@@ -2593,7 +2595,6 @@ void spi_unregister_controller(struct sp
 	list_del(&ctlr->list);
 	mutex_unlock(&board_lock);
 
-	device_for_each_child(&ctlr->dev, NULL, __unregister);
 	device_unregister(&ctlr->dev);
 	/* free bus id */
 	mutex_lock(&board_lock);


