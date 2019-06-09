Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9AE3AAAE
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730743AbfFIQrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:47:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730735AbfFIQrF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:47:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1C22208E3;
        Sun,  9 Jun 2019 16:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098824;
        bh=djcMLwIfe/22lcru6QrlwMZ98x837/yYlP/0xOJ48ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LgaWbpPpe34bq96A61o1XHKMe08SuGd/BwMp5FrZ1K+ckBRRX4Mno5/dweNjhOJqs
         aEm6BSet/dLC5j1eBdubwTYHzmyFbA4T4SPyH0HbVsGqC7rP3uAEy/PjjqgzoJWMsg
         jeU+Allul09M3l8b99S+GxBP1lPwhlXBnFaYOMIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <hancock@sedsystems.ca>,
        Michal Simek <michal.simek@xilinx.com>,
        Wolfram Sang <wsa@the-dreams.de>, stable@kernel.org
Subject: [PATCH 5.1 41/70] i2c: xiic: Add max_read_len quirk
Date:   Sun,  9 Jun 2019 18:41:52 +0200
Message-Id: <20190609164130.702915045@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <hancock@sedsystems.ca>

commit 49b809586730a77b57ce620b2f9689de765d790b upstream.

This driver does not support reading more than 255 bytes at once because
the register for storing the number of bytes to read is only 8 bits. Add
a max_read_len quirk to enforce this.

This was found when using this driver with the SFP driver, which was
previously reading all 256 bytes in the SFP EEPROM in one transaction.
This caused a bunch of hard-to-debug errors in the xiic driver since the
driver/logic was treating the number of bytes to read as zero.
Rejecting transactions that aren't supported at least allows the problem
to be diagnosed more easily.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
Reviewed-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-xiic.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -718,11 +718,16 @@ static const struct i2c_algorithm xiic_a
 	.functionality = xiic_func,
 };
 
+static const struct i2c_adapter_quirks xiic_quirks = {
+	.max_read_len = 255,
+};
+
 static const struct i2c_adapter xiic_adapter = {
 	.owner = THIS_MODULE,
 	.name = DRIVER_NAME,
 	.class = I2C_CLASS_DEPRECATED,
 	.algo = &xiic_algorithm,
+	.quirks = &xiic_quirks,
 };
 
 


