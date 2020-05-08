Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89D51CAEBB
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729468AbgEHMqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:46:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729464AbgEHMqn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:46:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3B5A21974;
        Fri,  8 May 2020 12:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942003;
        bh=JhKR7i5dfEhFFTPYQ7tYFZZyr2se2f3HLZYXa4lpvmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxauS+wiDDGjM/66nOeBbtLnHPxeAPqKEb8Qsvm5iI658rTfC3nTc9PGkImWuzu4m
         C8MyujIrHvBeeS2zmMtvNeJK/kuuPqigPazr37EMo4yHzKljXQ/mEZj6554b4Aordh
         TgP5JrUehEOqUJGs6L5OBj2PissPUZNdL6VuQHmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Xiang <liu.xiang6@zte.com.cn>,
        "Andrew F. Davis" <afd@ti.com>, Sebastian Reichel <sre@kernel.org>
Subject: [PATCH 4.4 231/312] power: bq27xxx_battery: Fix bq27541 AveragePower register address
Date:   Fri,  8 May 2020 14:33:42 +0200
Message-Id: <20200508123140.683195367@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Xiang <liu.xiang6@zte.com.cn>

commit 265b60497a57da56a4be7d5c72983ae89dc0765e upstream.

Currently in bq27541 driver, the average power register address is
incorrectly set to 0x76, which would result in an error:
bq27xxx-battery 2-0055: error reading average power register  10: -11
According to the bq27541 datasheet, fix this problem by setting
the average power register address to 0x24.

Fixes: d74534c27775 ("power: bq27xxx_battery: Add support for additional bq27xxx family devices")
Signed-off-by: Liu Xiang <liu.xiang6@zte.com.cn>
Acked-by: Andrew F. Davis <afd@ti.com>
Signed-off-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/power/bq27xxx_battery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/bq27xxx_battery.c
+++ b/drivers/power/bq27xxx_battery.c
@@ -242,7 +242,7 @@ static u8 bq27541_regs[] = {
 	INVALID_REG_ADDR,	/* AE - NA	*/
 	0x2c,	/* SOC(RSOC)	*/
 	0x3c,	/* DCAP		*/
-	0x76,	/* AP		*/
+	0x24,	/* AP		*/
 };
 
 static u8 bq27545_regs[] = {


