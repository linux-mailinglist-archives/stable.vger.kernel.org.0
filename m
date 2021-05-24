Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D3238EECB
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234062AbhEXPzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234762AbhEXPyR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:54:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E88B6142A;
        Mon, 24 May 2021 15:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870784;
        bh=CDRMBNjaStc0Wy7yYEz1n1EtEWzMYRWonj//RK82c3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=miqslYpa5XHzVDoGbXHwC0t8vigybL2jp5WblqfCF1Z5r7HwvVdIed2cthmaUmkJE
         06QeZOiilM4CM/bVY5vJTlNNCUsOiaE/nVXz5tqljsniKVb/gkbkl5+J0qbzUESHP5
         1WJygN/LVCLT9eYT8fob3aC5keudbKJmhRQaJ3Ag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Hsin-Yi Wang <hsinyi@chromium.org>
Subject: [PATCH 5.10 033/104] misc: eeprom: at24: check suspend status before disable regulator
Date:   Mon, 24 May 2021 17:25:28 +0200
Message-Id: <20210524152333.924476885@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hsin-Yi Wang <hsinyi@chromium.org>

commit 2962484dfef8dbb7f9059822bc26ce8a04d0e47c upstream.

cd5676db0574 ("misc: eeprom: at24: support pm_runtime control") disables
regulator in runtime suspend. If runtime suspend is called before
regulator disable, it will results in regulator unbalanced disabling.

Fixes: cd5676db0574 ("misc: eeprom: at24: support pm_runtime control")
Cc: stable <stable@vger.kernel.org>
Acked-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Link: https://lore.kernel.org/r/20210420133050.377209-1-hsinyi@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/eeprom/at24.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -763,7 +763,8 @@ static int at24_probe(struct i2c_client
 	at24->nvmem = devm_nvmem_register(dev, &nvmem_config);
 	if (IS_ERR(at24->nvmem)) {
 		pm_runtime_disable(dev);
-		regulator_disable(at24->vcc_reg);
+		if (!pm_runtime_status_suspended(dev))
+			regulator_disable(at24->vcc_reg);
 		return PTR_ERR(at24->nvmem);
 	}
 
@@ -774,7 +775,8 @@ static int at24_probe(struct i2c_client
 	err = at24_read(at24, 0, &test_byte, 1);
 	if (err) {
 		pm_runtime_disable(dev);
-		regulator_disable(at24->vcc_reg);
+		if (!pm_runtime_status_suspended(dev))
+			regulator_disable(at24->vcc_reg);
 		return -ENODEV;
 	}
 


