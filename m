Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87FC961FF2
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 16:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731494AbfGHOA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 10:00:58 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39427 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727401AbfGHOA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 10:00:58 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4323621F16;
        Mon,  8 Jul 2019 10:00:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 08 Jul 2019 10:00:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=MgKoKR
        GCmHDRY3Hfn3vZycyX+6ydFuCuR0URiaJDEAI=; b=UICKNRTuaATW4QlK1qKuKG
        S5N/OsF+SaiUqg0VTIn8JFA39/H78aD2b80uFYI4pVqYc1rrdhzdBQcNbIHMF+qD
        jh7vlO6HG5wsRYyfGfSfWCRWoJ8Ar+ceOwqkfXKL/BHLPife+1yCOKqnLZoI5XLu
        hAAxPCctdhFimwLIotQ+cnWJ5b/hvTyzUDeWEed1uFwd/Lf6aFtpEnDsNqIDrIho
        ClGhpmioRXG4PJjJXlGm8M6epPyLWho3CF9BDZxU3C+H3O/+2wHu1yCRyFRq+9nd
        KAGSLuJsMa70nAaiAndNjZaKo05uUuyNjeHvDPlxMq5efX1ZngiilQTve2o9LICA
        ==
X-ME-Sender: <xms:mUwjXVssZ6WCRPdiaAhhMKoPNL62Hb12PbiV5RpK93YlRwd5blkZbQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrgedtgdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:mUwjXYtXa_lLxnsVBwinaQe5hkQuGLcy0wnSF55lCSc0TBe-d6-n-Q>
    <xmx:mUwjXePDp36VDoGIKhcPpEdgWX3ggboxEWokVnKLdpp5Jqa7HGQieA>
    <xmx:mUwjXSd5T2GJhPpKUcN7VFl1oCxfR-7B9NYyyIHSwdBOiLWIMmbJNA>
    <xmx:mUwjXRbFUYSEYbf7zh2TVWhiFM6-MJDfLoL6z9AzMa5ILalWxH6oxQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 197C18006A;
        Mon,  8 Jul 2019 10:00:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] scsi: target/iblock: Fix overrun in WRITE SAME emulation" failed to apply to 4.14-stable tree
To:     r.bolshakov@yadro.com, bvanassche@acm.org,
        martin.petersen@oracle.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Jul 2019 16:00:50 +0200
Message-ID: <156259445030138@kroah.com>
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

