Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6434328738
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237643AbhCARWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:22:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:52722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237876AbhCARNl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:13:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D441164EE9;
        Mon,  1 Mar 2021 16:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617043;
        bh=cG00EA4GqSE9VrsMiGmD1BFl2y/v11PU4dDaZHNRsrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCF4zSPinLYM1yDw/Z05hzojs8As56iac8v2j+BfXwbMbl8eTXlG62OIrNkaCjU5X
         LHNvSDHF9x637mR5ft4z6ED5k1hs+BG6UnGG+8r0CNMrbwYfiXWa9LtYR3qW2bQ6RG
         wUCEQeEuij4Ha39MmovH49m/tS44aHxxPIoUxmG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "jeffrey.lin" <jeffrey.lin@rad-ic.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.19 182/247] Input: raydium_ts_i2c - do not send zero length
Date:   Mon,  1 Mar 2021 17:13:22 +0100
Message-Id: <20210301161040.568707268@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: jeffrey.lin <jeffrey.lin@rad-ic.com>

commit fafd320ae51b9c72d371585b2501f86640ea7b7d upstream.

Add default write command package to prevent i2c quirk error of zero
data length as Raydium touch firmware update is executed.

Signed-off-by: jeffrey.lin <jeffrey.lin@rad-ic.com>
Link: https://lore.kernel.org/r/1608031217-7247-1-git-send-email-jeffrey.lin@raydium.corp-partner.google.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/raydium_i2c_ts.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/input/touchscreen/raydium_i2c_ts.c
+++ b/drivers/input/touchscreen/raydium_i2c_ts.c
@@ -419,6 +419,7 @@ static int raydium_i2c_write_object(stru
 				    enum raydium_bl_ack state)
 {
 	int error;
+	static const u8 cmd[] = { 0xFF, 0x39 };
 
 	error = raydium_i2c_send(client, RM_CMD_BOOT_WRT, data, len);
 	if (error) {
@@ -427,7 +428,7 @@ static int raydium_i2c_write_object(stru
 		return error;
 	}
 
-	error = raydium_i2c_send(client, RM_CMD_BOOT_ACK, NULL, 0);
+	error = raydium_i2c_send(client, RM_CMD_BOOT_ACK, cmd, sizeof(cmd));
 	if (error) {
 		dev_err(&client->dev, "Ack obj command failed: %d\n", error);
 		return error;


