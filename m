Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71BA249B9A
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 13:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgHSLUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 07:20:36 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:33209 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726746AbgHSLUe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 07:20:34 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 402DE1942781;
        Wed, 19 Aug 2020 07:20:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 07:20:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rko6XK
        2ZIz7E/DG+tWgpTx4FkNjK5/4Q+rh3xOYTbPA=; b=rPqEdP+ljMjiZEOLhSedaV
        Bxxt2PgLdtWa2SO1b3L5oxm67oiY7Por7UdhgQVRA4V1mWSBgX18slz5ywd9X/aH
        IH4jfVPtpOIBaFkReUp9u95k+9IAVhhYTTKyB9dz43qFIEtA5QszOrfcI/JsNY/j
        8ZFQPJZFv+XYOwzHQ54Sh03Yw/VvYo19va64EpAuZUWStZhQ4SyZabwtGoNENJIg
        2egAELtw092H7Jkb6jPXM0tfQVAN4c/x6V19Jy8PSBoLvoYy/XllqDVTa5fYWK2T
        UF0LrTnbNozeEyhQ/+6nTR7xUp4Aq7Ky6NlDKQOPthnTrV7Kp+9PneGYmb8gGDCg
        ==
X-ME-Sender: <xms:AAs9X939xtmhIChFma5PZG_QJCqc2PIFF-oi7_u57EtN_PGyAbCZMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:AAs9X0HBgHfJYzspdy9Hz3U0uNFNnXt8mOlTIVvGcOiUHzVaM_solg>
    <xmx:AAs9X94Gvww0iBo947qfqdo2iEX-I88yzk2HNt9X9Mlz8cYzmLNOpQ>
    <xmx:AAs9X63MDCsq8oAnxmEvemtEujudTxoVBs3OnRlPdEEMCRE-JuTNdg>
    <xmx:AQs9Xzx7yRzA39VBHHX7-LThFaK0kRhyTyzkil82uC47bglTcjhtpw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 882C33280059;
        Wed, 19 Aug 2020 07:20:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: allow use of global block reserve for balance item" failed to apply to 4.4-stable tree
To:     dsterba@suse.com, johannes.thumshirn@wdc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 13:20:55 +0200
Message-ID: <1597836055184180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3502a8c0dc1bd4b4970b59b06e348f22a1c05581 Mon Sep 17 00:00:00 2001
From: David Sterba <dsterba@suse.com>
Date: Thu, 25 Jun 2020 12:35:28 +0200
Subject: [PATCH] btrfs: allow use of global block reserve for balance item
 deletion

On a filesystem with exhausted metadata, but still enough to start
balance, it's possible to hit this error:

[324402.053842] BTRFS info (device loop0): 1 enospc errors during balance
[324402.060769] BTRFS info (device loop0): balance: ended with status: -28
[324402.172295] BTRFS: error (device loop0) in reset_balance_state:3321: errno=-28 No space left

It fails inside reset_balance_state and turns the filesystem to
read-only, which is unnecessary and should be fixed too, but the problem
is caused by lack for space when the balance item is deleted. This is a
one-time operation and from the same rank as unlink that is allowed to
use the global block reserve. So do the same for the balance item.

Status of the filesystem (100GiB) just after the balance fails:

$ btrfs fi df mnt
Data, single: total=80.01GiB, used=38.58GiB
System, single: total=4.00MiB, used=16.00KiB
Metadata, single: total=19.99GiB, used=19.48GiB
GlobalReserve, single: total=512.00MiB, used=50.11MiB

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f403fb1e6d37..62ae89b078f4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3231,7 +3231,7 @@ static int del_balance_item(struct btrfs_fs_info *fs_info)
 	if (!path)
 		return -ENOMEM;
 
-	trans = btrfs_start_transaction(root, 0);
+	trans = btrfs_start_transaction_fallback_global_rsv(root, 0);
 	if (IS_ERR(trans)) {
 		btrfs_free_path(path);
 		return PTR_ERR(trans);

