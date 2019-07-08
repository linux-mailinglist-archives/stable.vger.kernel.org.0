Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C11E6236D
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390938AbfGHPfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:35:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390631AbfGHPfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:35:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7861204EC;
        Mon,  8 Jul 2019 15:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562600123;
        bh=aNaYjnq15d5e7OzdjIviYRdikdrCKjgey/wUG1Q66SA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OL1Sw7/MO55X878KuvUaYh8Dt5WPxCFMzwiBMTCatm8KtRpRdlVeBGZcjlB0ABNr+
         /yXwx19nVEJdUE0tzgkLqc6sNV8IOnV2ZqKQJnqOZZSv2OggjNIahIh+YljeRcTT6E
         iKDAq7IOdnVsmkHdaK2jQHPqFliy6c8yXv8skpls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Bolshakov <r.bolshakov@yadro.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.1 96/96] scsi: target/iblock: Fix overrun in WRITE SAME emulation
Date:   Mon,  8 Jul 2019 17:14:08 +0200
Message-Id: <20190708150531.612248263@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Bolshakov <r.bolshakov@yadro.com>

commit 5676234f20fef02f6ca9bd66c63a8860fce62645 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_iblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -515,7 +515,7 @@ iblock_execute_write_same(struct se_cmd
 
 		/* Always in 512 byte units for Linux/Block */
 		block_lba += sg->length >> SECTOR_SHIFT;
-		sectors -= 1;
+		sectors -= sg->length >> SECTOR_SHIFT;
 	}
 
 	iblock_submit_bios(&list);


