Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA928197802
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 11:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbgC3JtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 05:49:09 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55097 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726127AbgC3JtJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 05:49:09 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 9E6F25C076D;
        Mon, 30 Mar 2020 05:49:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 30 Mar 2020 05:49:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=wVZzZU
        29ufdOYHahAPebMyZrmm+TWSLrCjyLeOFw9j4=; b=d6WwbXPjlpp4gSCEKKVSao
        3EVyyTJ/FhxDcCwe9sJhrxDVZ87fMEk9oPU0YFZLV1zVlxno/azmGGnpBOLdmz27
        ics4qccpNFmDRq8EM7Q2tn9MNf6uATeAIuZjKPcAjQOVM4d6reqI1PghgpH2ncTT
        BSdI/ChgxkIeogA71Tc9rLKbh4S8xXDUrXc/R5cjIMq6x9QN907z2Y5pbel+GTC2
        FCqufnPiDGzRW1zuT4xzQGDVmE6s/OQHnVl7kvSDo139IvV2DW5XHVv6iClBhwSq
        fvFi9Y3PN/71mZQlrIX5V66mAn3DbPMhbYY2hv1gglvI3qmuyXwJxvwb+/QgVzlg
        ==
X-ME-Sender: <xms:k8CBXrLLcW_7gqmWdPWilMeUiNEWuA1OxqwQhryW5wWZS1tI2ArC6g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:k8CBXir_cx0iB43SoDOZR9obbU_n9TG6MbxYrZeI19EDbr0LfVTuHw>
    <xmx:k8CBXmhYJ55mZYhqGgsVVdm46hIy7YRoQl2naiMVCoOo4icUcomojw>
    <xmx:k8CBXh84ptp8l-NSteNOyiI5DMwDM_Kz8pwvZUgSgwS42bHaNZNxHg>
    <xmx:k8CBXtBjjO23woV0Mkz9a6p7ywCkbblnpT61yLdjoJThf-2bo_EQDQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 192403280059;
        Mon, 30 Mar 2020 05:49:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Input: raydium_i2c_ts - fix error codes in" failed to apply to 4.9-stable tree
To:     dan.carpenter@oracle.com, dmitry.torokhov@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 30 Mar 2020 11:49:05 +0200
Message-ID: <1585561745167189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 32cf3a610c35cb21e3157f4bbf29d89960e30a36 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Fri, 6 Mar 2020 11:50:51 -0800
Subject: [PATCH] Input: raydium_i2c_ts - fix error codes in
 raydium_i2c_boot_trigger()

These functions are supposed to return negative error codes but instead
it returns true on failure and false on success.  The error codes are
eventually propagated back to user space.

Fixes: 48a2b783483b ("Input: add Raydium I2C touchscreen driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20200303101306.4potflz7na2nn3od@kili.mountain
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

diff --git a/drivers/input/touchscreen/raydium_i2c_ts.c b/drivers/input/touchscreen/raydium_i2c_ts.c
index 6ed9f22e6401..fe245439adee 100644
--- a/drivers/input/touchscreen/raydium_i2c_ts.c
+++ b/drivers/input/touchscreen/raydium_i2c_ts.c
@@ -432,7 +432,7 @@ static int raydium_i2c_write_object(struct i2c_client *client,
 	return 0;
 }
 
-static bool raydium_i2c_boot_trigger(struct i2c_client *client)
+static int raydium_i2c_boot_trigger(struct i2c_client *client)
 {
 	static const u8 cmd[7][6] = {
 		{ 0x08, 0x0C, 0x09, 0x00, 0x50, 0xD7 },
@@ -457,10 +457,10 @@ static bool raydium_i2c_boot_trigger(struct i2c_client *client)
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
@@ -483,7 +483,7 @@ static bool raydium_i2c_fw_trigger(struct i2c_client *client)
 		}
 	}
 
-	return false;
+	return 0;
 }
 
 static int raydium_i2c_check_path(struct i2c_client *client)

