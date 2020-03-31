Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F976198FB0
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730604AbgCaJFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:05:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730541AbgCaJFa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:05:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C735720B1F;
        Tue, 31 Mar 2020 09:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645530;
        bh=R4Lc+71PGFMVycjmavRdG/jAUNmy4bDOa660TR9oaVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oohEHjE1Tvrb4g4CU4cnzkq8pR/araSZlkWv2AZtnB0U0gk5xXi+MW30/1z44T1mG
         2b3Ata4Bpf0K6cmgUg1w9UtHCduWaCLHGkvOGGRJrWJLR82WnlrRaKUZ+oFUfB6wAR
         /sjIjMG4vzQEykXTEfPSIVlzffc5794BCImzHygo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.5 082/170] Input: raydium_i2c_ts - fix error codes in raydium_i2c_boot_trigger()
Date:   Tue, 31 Mar 2020 10:58:16 +0200
Message-Id: <20200331085433.024107683@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
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


