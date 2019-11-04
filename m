Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 304B7EEE3F
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390334AbfKDWJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:09:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:42092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390341AbfKDWJF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:09:05 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10D652084D;
        Mon,  4 Nov 2019 22:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905344;
        bh=U+Zx5FXqnEKDqG9cbcGZr0ucvhiaP2b+eeL9ag+Gn0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDJcA6j+TASaN3ZjXN6CworFpborFs5k8GJxlWhaO5IbUeo2n5DzVgKul0+2ovLQq
         zGyXLVHJMABibxlZ0QBBXjc8iKSkxtvDnLalmVV1RzWGh1dC26EjJEd+WIGRXA0cgU
         RR7/tMmkhKUFKOmgLLSXgJksX7BnV8yueJsUNqRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Girish Basrur <gbasrur@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.3 113/163] scsi: qla2xxx: Fix partial flash write of MBI
Date:   Mon,  4 Nov 2019 22:45:03 +0100
Message-Id: <20191104212148.426992883@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

commit 8d8b83f5be2a3bdac3695a94e6cb5e50bd114869 upstream.

For new adapters with multiple flash regions to write to, current code
allows FW & Boot regions to be written, while other regions are blocked via
sysfs. The fix is to block all flash read/write through sysfs interface.

Fixes: e81d1bcbde06 ("scsi: qla2xxx: Further limit FLASH region write access from SysFS")
Cc: stable@vger.kernel.org # 5.2
Link: https://lore.kernel.org/r/20191022193643.7076-3-hmadhani@marvell.com
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Girish Basrur <gbasrur@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_attr.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -441,9 +441,6 @@ qla2x00_sysfs_write_optrom_ctl(struct fi
 		valid = 0;
 		if (ha->optrom_size == OPTROM_SIZE_2300 && start == 0)
 			valid = 1;
-		else if (start == (ha->flt_region_boot * 4) ||
-		    start == (ha->flt_region_fw * 4))
-			valid = 1;
 		else if (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha))
 			valid = 1;
 		if (!valid) {
@@ -491,8 +488,10 @@ qla2x00_sysfs_write_optrom_ctl(struct fi
 		    "Writing flash region -- 0x%x/0x%x.\n",
 		    ha->optrom_region_start, ha->optrom_region_size);
 
-		ha->isp_ops->write_optrom(vha, ha->optrom_buffer,
+		rval = ha->isp_ops->write_optrom(vha, ha->optrom_buffer,
 		    ha->optrom_region_start, ha->optrom_region_size);
+		if (rval)
+			rval = -EIO;
 		break;
 	default:
 		rval = -EINVAL;


