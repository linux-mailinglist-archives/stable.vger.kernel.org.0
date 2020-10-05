Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D35283A9F
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgJEPfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:35:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727714AbgJEPdf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:33:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F249207BC;
        Mon,  5 Oct 2020 15:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601912014;
        bh=wAXBs46pNEVfAFjXDP6XQOUMy8YMBqnthPuIgUThzOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x2eOL4rxH0DOd23EL3BU+q+7anXrMCV0AAM2i0ht8FnQmV4sDTQspSwZYHz+pyGCR
         8KofxrTAu2WH8ei7fjYwhc6hkOtuUJu2TDtxZQzT0T9De0Cvl2JFnvUMRqZNGocrKp
         c5koVWASVIA9N408pX+EhzjBRrW4LSlpXxw1FAfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tali Perry <tali.perry1@gmail.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 67/85] i2c: npcm7xx: Clear LAST bit after a failed transaction.
Date:   Mon,  5 Oct 2020 17:27:03 +0200
Message-Id: <20201005142117.954212662@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tali Perry <tali.perry1@gmail.com>

[ Upstream commit 8947efc077168c53b84d039881a7c967086a248a ]

Due to a HW issue, in some scenarios the LAST bit might remain set.
This will cause an unexpected NACK after reading 16 bytes on the next
read.

Example: if user tries to read from a missing device, get a NACK,
then if the next command is a long read ( > 16 bytes),
the master will stop reading after 16 bytes.
To solve this, if a command fails, check if LAST bit is still
set. If it does, reset the module.

Fixes: 56a1485b102e (i2c: npcm7xx: Add Nuvoton NPCM I2C controller driver)
Signed-off-by: Tali Perry <tali.perry1@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-npcm7xx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/i2c/busses/i2c-npcm7xx.c b/drivers/i2c/busses/i2c-npcm7xx.c
index dfcf04e1967f1..2ad166355ec9b 100644
--- a/drivers/i2c/busses/i2c-npcm7xx.c
+++ b/drivers/i2c/busses/i2c-npcm7xx.c
@@ -2163,6 +2163,15 @@ static int npcm_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 	if (bus->cmd_err == -EAGAIN)
 		ret = i2c_recover_bus(adap);
 
+	/*
+	 * After any type of error, check if LAST bit is still set,
+	 * due to a HW issue.
+	 * It cannot be cleared without resetting the module.
+	 */
+	if (bus->cmd_err &&
+	    (NPCM_I2CRXF_CTL_LAST_PEC & ioread8(bus->reg + NPCM_I2CRXF_CTL)))
+		npcm_i2c_reset(bus);
+
 #if IS_ENABLED(CONFIG_I2C_SLAVE)
 	/* reenable slave if it was enabled */
 	if (bus->slave)
-- 
2.25.1



