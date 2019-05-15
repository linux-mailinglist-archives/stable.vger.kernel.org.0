Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF1A1F3D8
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbfEOLA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727580AbfEOLA7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:00:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D82E72084F;
        Wed, 15 May 2019 11:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918058;
        bh=SZ0h49qTYTAVRiMKbU4JLmNPY26ZDaX+92rxPpki5Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PksrykwUKAzMETOgkOJsd7PNqg+zzayL+zl5npLJLH+86+p8D8yzg2tLJ6Z29GX6W
         hCS2ZMiPHIvGZxlCUtFmCNeZ3BlLSGJws/YtTA60nDoYgeJ96mKrCcAZB8nsYrwtx3
         9pCRvLQL60GxHs+rD2vHvR+rvNIxl8V8B6GFTqQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Vasquez <andrewv@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3.18 59/86] scsi: qla2xxx: Fix incorrect region-size setting in optrom SYSFS routines
Date:   Wed, 15 May 2019 12:55:36 +0200
Message-Id: <20190515090654.120100646@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
References: <20190515090642.339346723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Vasquez <andrewv@marvell.com>

commit 5cbdae10bf11f96e30b4d14de7b08c8b490e903c upstream.

Commit e6f77540c067 ("scsi: qla2xxx: Fix an integer overflow in sysfs
code") incorrectly set 'optrom_region_size' to 'start+size', which can
overflow option-rom boundaries when 'start' is non-zero.  Continue setting
optrom_region_size to the proper adjusted value of 'size'.

Fixes: e6f77540c067 ("scsi: qla2xxx: Fix an integer overflow in sysfs code")
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Vasquez <andrewv@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_attr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -431,7 +431,7 @@ qla2x00_sysfs_write_optrom_ctl(struct fi
 		}
 
 		ha->optrom_region_start = start;
-		ha->optrom_region_size = start + size;
+		ha->optrom_region_size = size;
 
 		ha->optrom_state = QLA_SREADING;
 		ha->optrom_buffer = vmalloc(ha->optrom_region_size);
@@ -504,7 +504,7 @@ qla2x00_sysfs_write_optrom_ctl(struct fi
 		}
 
 		ha->optrom_region_start = start;
-		ha->optrom_region_size = start + size;
+		ha->optrom_region_size = size;
 
 		ha->optrom_state = QLA_SWRITING;
 		ha->optrom_buffer = vmalloc(ha->optrom_region_size);


