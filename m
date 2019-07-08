Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABEBC61FF4
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 16:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbfGHOBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 10:01:00 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38821 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727401AbfGHOBA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 10:01:00 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 33018220AB;
        Mon,  8 Jul 2019 10:00:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 08 Jul 2019 10:00:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=j4ONHi
        WnWloPagwSyfVgJ176QA8tmmQCPkCZGbRQ3Sk=; b=s9ujutLRtDP67oyc3p7rpb
        JKFOQGDeuswnCPx7F6ZBxqfrNFBSapYCj4jzST2Igf+bUrYcyyW73qw+u1jeVmik
        UFGcgBKvYOcpBXLwOCgDdAflWpt3AJD8Cb3hvKDP4GZek+WCzBTlYJsXYUr+OwJx
        RP5jhUrXJjzKhPwe7njI8jfZU8sEiMPjpuaDH8YsK57uXnW41SmU2P5GE9T4SF74
        Ar1pq5MTx2v9n+65/5wQKr7tX3R3fGzuFz5TvMj+BfzAGiP08wC0I6Xe23sMNG3P
        dPS6yGRpEHJ9OtrroDltzq1ku+2+2PFvya73Zd1EG1e+xAQZPViP7Hxn+DAjjG/A
        ==
X-ME-Sender: <xms:m0wjXe-5toZntQIFiV_OA8wlVIOuhYwZ98ue2eZzNq7CBLkSta6P7A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrgedtgdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:m0wjXRh0sgog4YOEo8z5Qx6rSLGOfU3slIPBdM1qTUZ4yTYMOfG4TA>
    <xmx:m0wjXZY30WRrYE7FztwNZVtqXomSPVT8sHWA65wEq9kyJDutXcVv8A>
    <xmx:m0wjXUPunsX_YUVV0J3YqnaIZrxb-GTBH3eU1uVYJcCW6UQJXmxUTA>
    <xmx:m0wjXX6zg3eaxipbVaN1CExOjfeZyBxLVSQjy-L1N0jr3U-Vgsa6ug>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5E69B8005B;
        Mon,  8 Jul 2019 10:00:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] scsi: target/iblock: Fix overrun in WRITE SAME emulation" failed to apply to 4.4-stable tree
To:     r.bolshakov@yadro.com, bvanassche@acm.org,
        martin.petersen@oracle.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Jul 2019 16:00:51 +0200
Message-ID: <156259445110255@kroah.com>
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

