Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6329426B40E
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgIOXP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:15:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727234AbgIOOj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:39:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AB3423CD2;
        Tue, 15 Sep 2020 14:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180177;
        bh=LnuiVm0b09YwpMrte0fpCkGcY5t1tjX1Rt1Rs296Zzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bXILGyYqAKfUWI2nOF1O96mt1WSkxTguaFO1VfISVs5EuJ7l1DtNwSVKu4++JHcW+
         Az7SJiXMUbFbYnrhpBtSat/QXsWN5Mxwl3dRkaaoWgT1nQphck/1cMPZu776MRlwsY
         X8qJ3mmzOYIRi/fTce0QyAtG6AGAQpzwAVVVn0xs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadym Kochan <vadym.kochan@plvision.eu>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.8 138/177] misc: eeprom: at24: register nvmem only after eeprom is ready to use
Date:   Tue, 15 Sep 2020 16:13:29 +0200
Message-Id: <20200915140700.271172638@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadym Kochan <vadym.kochan@plvision.eu>

commit 45df80d7605c25055a85fbc5a8446c81c6c0ca24 upstream.

During nvmem_register() the nvmem core sends notifications when:

    - cell added
    - nvmem added

and during these notifications some callback func may access the nvmem
device, which will fail in case of at24 eeprom because regulator and pm
are enabled after nvmem_register().

Fixes: cd5676db0574 ("misc: eeprom: at24: support pm_runtime control")
Fixes: b20eb4c1f026 ("eeprom: at24: drop unnecessary label")
Cc: stable@vger.kernel.org
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/eeprom/at24.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -692,10 +692,6 @@ static int at24_probe(struct i2c_client
 	nvmem_config.word_size = 1;
 	nvmem_config.size = byte_len;
 
-	at24->nvmem = devm_nvmem_register(dev, &nvmem_config);
-	if (IS_ERR(at24->nvmem))
-		return PTR_ERR(at24->nvmem);
-
 	i2c_set_clientdata(client, at24);
 
 	err = regulator_enable(at24->vcc_reg);
@@ -708,6 +704,13 @@ static int at24_probe(struct i2c_client
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
+	at24->nvmem = devm_nvmem_register(dev, &nvmem_config);
+	if (IS_ERR(at24->nvmem)) {
+		pm_runtime_disable(dev);
+		regulator_disable(at24->vcc_reg);
+		return PTR_ERR(at24->nvmem);
+	}
+
 	/*
 	 * Perform a one-byte test read to verify that the
 	 * chip is functional.


