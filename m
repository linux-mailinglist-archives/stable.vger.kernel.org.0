Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD801990C8
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731836AbgCaJOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730648AbgCaJOg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:14:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 417012072E;
        Tue, 31 Mar 2020 09:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646075;
        bh=R4Lc+71PGFMVycjmavRdG/jAUNmy4bDOa660TR9oaVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nRbMr3R/mIPYAPm01IAMlR2YLyxE+K6svwkDxUMXmwN6gRlovWlM7lt4K5q/DVyUd
         DqICTQ2A7Y87dURPXbe/gsN0dlArdttLAYyM55+5JneGmfvuT17TTgXueb01ig8WEQ
         pdN+ya1+kVefMv7830kRjNnoR6RLeKLsz/N5CdM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 077/155] Input: raydium_i2c_ts - fix error codes in raydium_i2c_boot_trigger()
Date:   Tue, 31 Mar 2020 10:58:37 +0200
Message-Id: <20200331085427.011328797@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 32cf3a610c35cb21e3157f4bbf29d89960e30a36 upstream.

These functions are supposed to return negative error codes but instead
it returns true on failure and false on success.  The error codes are
eventually propagated back to user space.

Fixes: 48a2b783483b ("Input: add Raydium I2C touchscreen driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20200303101306.4potflz7na2nn3od@kili.mountain
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/touchscreen/raydium_i2c_ts.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/input/touchscreen/raydium_i2c_ts.c
+++ b/drivers/input/touchscreen/raydium_i2c_ts.c
@@ -432,7 +432,7 @@ static int raydium_i2c_write_object(stru
 	return 0;
 }
 
-static bool raydium_i2c_boot_trigger(struct i2c_client *client)
+static int raydium_i2c_boot_trigger(struct i2c_client *client)
 {
 	static const u8 cmd[7][6] = {
 		{ 0x08, 0x0C, 0x09, 0x00, 0x50, 0xD7 },
@@ -457,10 +457,10 @@ static bool raydium_i2c_boot_trigger(str
 		}
 	}
 
-	return false;
+	return 0;
 }
 
-static bool raydium_i2c_fw_trigger(struct i2c_client *client)
+static int raydium_i2c_fw_trigger(struct i2c_client *client)
 {
 	static const u8 cmd[5][11] = {
 		{ 0, 0x09, 0x71, 0x0C, 0x09, 0x00, 0x50, 0xD7, 0, 0, 0 },
@@ -483,7 +483,7 @@ static bool raydium_i2c_fw_trigger(struc
 		}
 	}
 
-	return false;
+	return 0;
 }
 
 static int raydium_i2c_check_path(struct i2c_client *client)


