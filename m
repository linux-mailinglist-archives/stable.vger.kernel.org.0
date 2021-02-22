Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9798B3217A3
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhBVMvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:51:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231704AbhBVMsA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:48:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F24DC64F18;
        Mon, 22 Feb 2021 12:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997757;
        bh=aGzspOFXTKy1lNkelqJsGy9T7jJNKDGAKbez/J5EgZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=axCD8kr8ay+P6ML0zcZV/OdeuWUAUQZ3aW/xmrsxwXXm8c/srtzNO5hAke2p79398
         89xW+3xW6WpDQYTIZy6ZVv26vLudyP+/VfOvu4jdHxNyAlOMzShxiBgnqI+TOynkbM
         Mt9gZOK8RtCxX2hSVXsoA91PFNRXVp845zcHhEFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 48/49] scsi: qla2xxx: Fix crash during driver load on big endian machines
Date:   Mon, 22 Feb 2021 13:36:46 +0100
Message-Id: <20210222121028.427083139@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121022.546148341@linuxfoundation.org>
References: <20210222121022.546148341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

commit 8de309e7299a00b3045fb274f82b326f356404f0 upstream

Crash stack:
	[576544.715489] Unable to handle kernel paging request for data at address 0xd00000000f970000
	[576544.715497] Faulting instruction address: 0xd00000000f880f64
	[576544.715503] Oops: Kernel access of bad area, sig: 11 [#1]
	[576544.715506] SMP NR_CPUS=2048 NUMA pSeries
	:
	[576544.715703] NIP [d00000000f880f64] .qla27xx_fwdt_template_valid+0x94/0x100 [qla2xxx]
	[576544.715722] LR [d00000000f7952dc] .qla24xx_load_risc_flash+0x2fc/0x590 [qla2xxx]
	[576544.715726] Call Trace:
	[576544.715731] [c0000004d0ffb000] [c0000006fe02c350] 0xc0000006fe02c350 (unreliable)
	[576544.715750] [c0000004d0ffb080] [d00000000f7952dc] .qla24xx_load_risc_flash+0x2fc/0x590 [qla2xxx]
	[576544.715770] [c0000004d0ffb170] [d00000000f7aa034] .qla81xx_load_risc+0x84/0x1a0 [qla2xxx]
	[576544.715789] [c0000004d0ffb210] [d00000000f79f7c8] .qla2x00_setup_chip+0xc8/0x910 [qla2xxx]
	[576544.715808] [c0000004d0ffb300] [d00000000f7a631c] .qla2x00_initialize_adapter+0x4dc/0xb00 [qla2xxx]
	[576544.715826] [c0000004d0ffb3e0] [d00000000f78ce28] .qla2x00_probe_one+0xf08/0x2200 [qla2xxx]

Link: https://lore.kernel.org/r/20201202132312.19966-8-njavali@marvell.com
Fixes: f73cb695d3ec ("[SCSI] qla2xxx: Add support for ISP2071.")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_tmpl.c |    9 +++++----
 drivers/scsi/qla2xxx/qla_tmpl.h |    2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -878,7 +878,8 @@ qla27xx_template_checksum(void *p, ulong
 static inline int
 qla27xx_verify_template_checksum(struct qla27xx_fwdt_template *tmp)
 {
-	return qla27xx_template_checksum(tmp, tmp->template_size) == 0;
+	return qla27xx_template_checksum(tmp,
+		le32_to_cpu(tmp->template_size)) == 0;
 }
 
 static inline int
@@ -894,7 +895,7 @@ qla27xx_execute_fwdt_template(struct scs
 	ulong len;
 
 	if (qla27xx_fwdt_template_valid(tmp)) {
-		len = tmp->template_size;
+		len = le32_to_cpu(tmp->template_size);
 		tmp = memcpy(vha->hw->fw_dump, tmp, len);
 		ql27xx_edit_template(vha, tmp);
 		qla27xx_walk_template(vha, tmp, tmp, &len);
@@ -910,7 +911,7 @@ qla27xx_fwdt_calculate_dump_size(struct
 	ulong len = 0;
 
 	if (qla27xx_fwdt_template_valid(tmp)) {
-		len = tmp->template_size;
+		len = le32_to_cpu(tmp->template_size);
 		qla27xx_walk_template(vha, tmp, NULL, &len);
 	}
 
@@ -922,7 +923,7 @@ qla27xx_fwdt_template_size(void *p)
 {
 	struct qla27xx_fwdt_template *tmp = p;
 
-	return tmp->template_size;
+	return le32_to_cpu(tmp->template_size);
 }
 
 ulong
--- a/drivers/scsi/qla2xxx/qla_tmpl.h
+++ b/drivers/scsi/qla2xxx/qla_tmpl.h
@@ -13,7 +13,7 @@
 struct __packed qla27xx_fwdt_template {
 	uint32_t template_type;
 	uint32_t entry_offset;
-	uint32_t template_size;
+	__le32 template_size;
 	uint32_t reserved_1;
 
 	uint32_t entry_count;


