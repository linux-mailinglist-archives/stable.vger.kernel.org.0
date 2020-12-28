Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431D02E3EA7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504034AbgL1Oaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:30:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:38520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503720AbgL1Oap (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:30:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00A29221F0;
        Mon, 28 Dec 2020 14:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165829;
        bh=xoMTF1CXZZJ2IdsDi+XgdSgAMz+QyCa6IwiMQ7TtPz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=trMbM+uJ7O0+Yqb7l5/tn4vpNr+X/iQKzWzb8OXE0Q7QLMrQ9x0IreVsBtz1YW0Fy
         a1eSc00h0q5uGKs9OrA9pIOHTBa7hyp34kxOvPZsMCfks411iHpLvSMxGegC2p4AZJ
         pNqmJlp5FT91ioUqFLArZ0I+V9E0t4RxDrE7OGdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 669/717] scsi: qla2xxx: Fix crash during driver load on big endian machines
Date:   Mon, 28 Dec 2020 13:51:07 +0100
Message-Id: <20201228125053.036506065@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

commit 8de309e7299a00b3045fb274f82b326f356404f0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_tmpl.c |    9 +++++----
 drivers/scsi/qla2xxx/qla_tmpl.h |    2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -928,7 +928,8 @@ qla27xx_template_checksum(void *p, ulong
 static inline int
 qla27xx_verify_template_checksum(struct qla27xx_fwdt_template *tmp)
 {
-	return qla27xx_template_checksum(tmp, tmp->template_size) == 0;
+	return qla27xx_template_checksum(tmp,
+		le32_to_cpu(tmp->template_size)) == 0;
 }
 
 static inline int
@@ -944,7 +945,7 @@ qla27xx_execute_fwdt_template(struct scs
 	ulong len = 0;
 
 	if (qla27xx_fwdt_template_valid(tmp)) {
-		len = tmp->template_size;
+		len = le32_to_cpu(tmp->template_size);
 		tmp = memcpy(buf, tmp, len);
 		ql27xx_edit_template(vha, tmp);
 		qla27xx_walk_template(vha, tmp, buf, &len);
@@ -960,7 +961,7 @@ qla27xx_fwdt_calculate_dump_size(struct
 	ulong len = 0;
 
 	if (qla27xx_fwdt_template_valid(tmp)) {
-		len = tmp->template_size;
+		len = le32_to_cpu(tmp->template_size);
 		qla27xx_walk_template(vha, tmp, NULL, &len);
 	}
 
@@ -972,7 +973,7 @@ qla27xx_fwdt_template_size(void *p)
 {
 	struct qla27xx_fwdt_template *tmp = p;
 
-	return tmp->template_size;
+	return le32_to_cpu(tmp->template_size);
 }
 
 int
--- a/drivers/scsi/qla2xxx/qla_tmpl.h
+++ b/drivers/scsi/qla2xxx/qla_tmpl.h
@@ -12,7 +12,7 @@
 struct __packed qla27xx_fwdt_template {
 	__le32 template_type;
 	__le32 entry_offset;
-	uint32_t template_size;
+	__le32 template_size;
 	uint32_t count;		/* borrow field for running/residual count */
 
 	__le32 entry_count;


