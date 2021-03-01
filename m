Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF853290FC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243108AbhCAUSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:18:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:39542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236025AbhCAUJY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:09:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31EA7650A3;
        Mon,  1 Mar 2021 18:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621611;
        bh=D2LVDaN8hZJpX1CeiMcPvE6wKFL2Bwh5v9y4bTsAd5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xzRea7sFR99ZfsCFZRrge9ap6tWCtXJQP9G5qPkoKf3SM+w8FnNWie09JJoi2q2/F
         5RQoIA5muDpcUGp+3PUnDjWQaiSwyrUJ7HWmE4sSKqT6vaigCjo8p4Uz+mk6Se8MCw
         ykcFHFIqlHP/Z27AEIMJPZnKZlik0ZnbIN2AU3d0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "jeffrey.lin" <jeffrey.lin@rad-ic.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.11 579/775] Input: raydium_ts_i2c - do not send zero length
Date:   Mon,  1 Mar 2021 17:12:27 +0100
Message-Id: <20210301161230.069382584@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
@@ -445,6 +445,7 @@ static int raydium_i2c_write_object(stru
 				    enum raydium_bl_ack state)
 {
 	int error;
+	static const u8 cmd[] = { 0xFF, 0x39 };
 
 	error = raydium_i2c_send(client, RM_CMD_BOOT_WRT, data, len);
 	if (error) {
@@ -453,7 +454,7 @@ static int raydium_i2c_write_object(stru
 		return error;
 	}
 
-	error = raydium_i2c_send(client, RM_CMD_BOOT_ACK, NULL, 0);
+	error = raydium_i2c_send(client, RM_CMD_BOOT_ACK, cmd, sizeof(cmd));
 	if (error) {
 		dev_err(&client->dev, "Ack obj command failed: %d\n", error);
 		return error;


