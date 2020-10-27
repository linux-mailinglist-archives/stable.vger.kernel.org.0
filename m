Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC8029BA3F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783194AbgJ0P61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:58:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1803839AbgJ0Px3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:53:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F8FB20657;
        Tue, 27 Oct 2020 15:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603814009;
        bh=+Y0a2asrL7jAicrUGmb4DlOlW6Zj6PfPYrl0sTo8Acc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jf5n6mzYSqmAxNuxk3EKncTl387j08WI+p0yYwffUbC6+UZxXCuGxHID0lh77UlK0
         qAioDafrKJCEFbjynGwdSzLccEtqWswQZlFNNDCooWnhcBrTKYcWGT6EI0e9VT7Dn/
         ZXQWvbzVu9mTTn/ataEGCJ0h6SE9u+Fr+LGX3/n4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Wilck <mwilck@suse.com>,
        Arun Easi <aeasi@marvell.com>, Daniel Wagner <dwagner@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 714/757] scsi: qla2xxx: Warn if done() or free() are called on an already freed srb
Date:   Tue, 27 Oct 2020 14:56:04 +0100
Message-Id: <20201027135523.991075987@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit c0014f94218ea3a312f6235febea0d626c5f2154 ]

Emit a warning when ->done or ->free are called on an already freed
srb. There is a hidden use-after-free bug in the driver which corrupts
the srb memory pool which originates from the cleanup callbacks.

An extensive search didn't bring any lights on the real problem. The
initial fix was to set both pointers to NULL and try to catch invalid
accesses. But instead the memory corruption was gone and the driver
didn't crash. Since not all calling places check for NULL pointer, add
explicitly default handlers. With this we workaround the memory
corruption and add a debug help.

Link: https://lore.kernel.org/r/20200908081516.8561-2-dwagner@suse.de
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c   | 10 ++++++++++
 drivers/scsi/qla2xxx/qla_inline.h |  5 +++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 0bd04a62af836..8d4b651e14422 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -63,6 +63,16 @@ void qla2x00_sp_free(srb_t *sp)
 	qla2x00_rel_sp(sp);
 }
 
+void qla2xxx_rel_done_warning(srb_t *sp, int res)
+{
+	WARN_ONCE(1, "Calling done() of an already freed srb %p object\n", sp);
+}
+
+void qla2xxx_rel_free_warning(srb_t *sp)
+{
+	WARN_ONCE(1, "Calling free() of an already freed srb %p object\n", sp);
+}
+
 /* Asynchronous Login/Logout Routines -------------------------------------- */
 
 unsigned long
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 861dc522723ce..2aa6f81f87c43 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -207,10 +207,15 @@ qla2xxx_get_qpair_sp(scsi_qla_host_t *vha, struct qla_qpair *qpair,
 	return sp;
 }
 
+void qla2xxx_rel_done_warning(srb_t *sp, int res);
+void qla2xxx_rel_free_warning(srb_t *sp);
+
 static inline void
 qla2xxx_rel_qpair_sp(struct qla_qpair *qpair, srb_t *sp)
 {
 	sp->qpair = NULL;
+	sp->done = qla2xxx_rel_done_warning;
+	sp->free = qla2xxx_rel_free_warning;
 	mempool_free(sp, qpair->srb_mempool);
 	QLA_QPAIR_MARK_NOT_BUSY(qpair);
 }
-- 
2.25.1



