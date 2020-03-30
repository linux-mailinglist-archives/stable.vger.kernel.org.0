Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E01E0197803
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 11:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgC3JtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 05:49:17 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43737 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728708AbgC3JtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 05:49:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 683BB5C0710;
        Mon, 30 Mar 2020 05:49:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 30 Mar 2020 05:49:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=O9L/ig
        ZUmv0dQXA32CxYC9kF/3BsVDiKtZROumOSlsQ=; b=2XDiGB+5K2aYIWCWe+tkA6
        ovAg10lg5E+9vu/FON/h9oIf/dX/qVT52NtzKFMJLDpDdj/cKcNOVzvRLNzhMBD4
        t9YGybuw7HUY9ElIs/F64ZU9PYh3M5wxyh6VMaRaoSx4g7lArk2LDJrv/LJNxz+S
        xTSTdM7bGBccyc4VrRKxo7Y+euw2WIQ2X0NkwmHrSDIUPXlLoe+268DbyesYirJc
        GdUgKfMl6jyLR9nzKNp7JhhkU8n+/3u2z1KrNfTdpOXRv43j0zP1xnKZlAMVuokz
        5TNevopJ9MJgvD0EgKAMoPDxaPYkkvZfSR5xzNsBJl4MXPV/CPiE+gUFgFZRISOQ
        ==
X-ME-Sender: <xms:m8CBXvtH8vhRdWa3rrokQGDa3g8bbhGolXAqvA1Ktm5Vw0DXlEEO1g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:m8CBXksdXVLWSgjCoqrjskCkkxRkuozPufY7KqA7s5XHRwOq3LgfkQ>
    <xmx:m8CBXtzHxYYdF6bmaesaPHm8Q4FRlSR-EF9dJ5qKbM23IVDVRPNRcw>
    <xmx:m8CBXijKlClfKUy67afjqczF0Wksav-8woOtSOeDgwK2awswf2UD9w>
    <xmx:m8CBXlicbb1el1oSyaWyoQO4fR4NHdqOWvpm5Pn7EWW15voHx2xYRw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 043933280059;
        Mon, 30 Mar 2020 05:49:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Input: raydium_i2c_ts - fix error codes in" failed to apply to 4.14-stable tree
To:     dan.carpenter@oracle.com, dmitry.torokhov@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 30 Mar 2020 11:49:05 +0200
Message-ID: <15855617453276@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

