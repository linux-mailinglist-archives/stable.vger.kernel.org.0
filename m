Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF1561FF1
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 16:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731493AbfGHOA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 10:00:56 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54731 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727401AbfGHOA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 10:00:56 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2EA63220A7;
        Mon,  8 Jul 2019 10:00:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 08 Jul 2019 10:00:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2CU/QD
        tZJ08w495Q2Pin6wHihb++v4njPBXIGMtAKic=; b=CEbG3NxZRuJYEcwqoqWS+r
        7Trii77DBJ8jwRvK4UVAdU8o6JxMEKTK21BddPpjly3shtahqDk9c/HxiR2rUNff
        cSfEggqAZ+ykDEKfQKOq+iMBF+eixkAmy0O1Pj1daKVBKQZqyZ2BQoInqVkxOKH5
        6TkGH9mZ16GBgHK/yME5ZWIai9G/t4qHjz5+Z75bv4If5Tla+xRY5sbEowTRMwFA
        jL/DHfxgoCmJfcEuoL7XgkOWDG2h0/6qMYX8Ho5dgDlIHidb9Rn24FbRH15uAZVN
        kkOnqP8mDq+tP4Ep7QIgg6wpGTqNWb06zyC86z9F9m1J66CUIVWzqYc59JJC3hsQ
        ==
X-ME-Sender: <xms:lkwjXQBivhTa3hwkahcIrb_kQ5Qc9pRHbg_4o6SH3JTZwCOEknoZqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrgedtgdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:lkwjXWyvQNon7vRxIlG3U6SiN0HiOD3oSCW8-zemdmfzxh64IqDc9w>
    <xmx:lkwjXemlYCw1N7fpJFl5D28xxnYpjYCays4xPZM353qVd7050ZR3-Q>
    <xmx:lkwjXbEDAcpuhNDyrQZKLb3m2_l4QGLos0wld0HZdHCJAV9o41JB3Q>
    <xmx:l0wjXcRL1vgv45RmdZ2pZwVbHzYrxbgpgVaUqytnFcARxytP_03Usw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7673D80063;
        Mon,  8 Jul 2019 10:00:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] scsi: target/iblock: Fix overrun in WRITE SAME emulation" failed to apply to 4.9-stable tree
To:     r.bolshakov@yadro.com, bvanassche@acm.org,
        martin.petersen@oracle.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Jul 2019 16:00:50 +0200
Message-ID: <1562594450199182@kroah.com>
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

From 5676234f20fef02f6ca9bd66c63a8860fce62645 Mon Sep 17 00:00:00 2001
From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Tue, 2 Jul 2019 22:16:38 +0300
Subject: [PATCH] scsi: target/iblock: Fix overrun in WRITE SAME emulation

WRITE SAME corrupts data on the block device behind iblock if the command
is emulated. The emulation code issues (M - 1) * N times more bios than
requested, where M is the number of 512 blocks per real block size and N is
the NUMBER OF LOGICAL BLOCKS specified in WRITE SAME command. So, for a
device with 4k blocks, 7 * N more LBAs gets written after the requested
range.

The issue happens because the number of 512 byte sectors to be written is
decreased one by one while the real bios are typically from 1 to 8 512 byte
sectors per bio.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Cc: <stable@vger.kernel.org>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index b5ed9c377060..efebacd36101 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -515,7 +515,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 
 		/* Always in 512 byte units for Linux/Block */
 		block_lba += sg->length >> SECTOR_SHIFT;
-		sectors -= 1;
+		sectors -= sg->length >> SECTOR_SHIFT;
 	}
 
 	iblock_submit_bios(&list);

