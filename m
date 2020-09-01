Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30DB0259736
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgIAQMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:12:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731316AbgIAPhH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:37:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DB8021582;
        Tue,  1 Sep 2020 15:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974626;
        bh=1B+QXaftpvc71qrW0YzBAEyEARivFDbq++HPRv+l/7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vWOMw8KbzmmxGpLhN3HCFyzOrJYd8rlicSfxzTio/7IB683q9HCXZzbDY0NrcPuH
         eXI/mn7HpbzFNcMiUwi4InJISyGewSH1aVGniFCr1jQ/nJS0QUYcnqgGZZlrdyZ9mF
         kuAMm2GQEc7Sm83P4aYwXawZ+W/yOuvamCUGvlUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 034/255] scsi: target: Fix xcopy sess release leak
Date:   Tue,  1 Sep 2020 17:08:10 +0200
Message-Id: <20200901151002.405443367@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 3c006c7d23aac928279f7cbe83bbac4361255d53 ]

transport_init_session can allocate memory via percpu_ref_init, and
target_xcopy_release_pt never frees it. This adds a
transport_uninit_session function to handle cleanup of resources allocated
in the init function.

Link: https://lore.kernel.org/r/1593654203-12442-3-git-send-email-michael.christie@oracle.com
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_internal.h  |  1 +
 drivers/target/target_core_transport.c |  7 ++++++-
 drivers/target/target_core_xcopy.c     | 11 +++++++++--
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 8533444159635..e7b3c6e5d5744 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -138,6 +138,7 @@ int	init_se_kmem_caches(void);
 void	release_se_kmem_caches(void);
 u32	scsi_get_new_index(scsi_index_t);
 void	transport_subsystem_check_init(void);
+void	transport_uninit_session(struct se_session *);
 unsigned char *transport_dump_cmd_direction(struct se_cmd *);
 void	transport_dump_dev_state(struct se_device *, char *, int *);
 void	transport_dump_dev_info(struct se_device *, struct se_lun *,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 90ecdd706a017..e6e1fa68de542 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -236,6 +236,11 @@ int transport_init_session(struct se_session *se_sess)
 }
 EXPORT_SYMBOL(transport_init_session);
 
+void transport_uninit_session(struct se_session *se_sess)
+{
+	percpu_ref_exit(&se_sess->cmd_count);
+}
+
 /**
  * transport_alloc_session - allocate a session object and initialize it
  * @sup_prot_ops: bitmask that defines which T10-PI modes are supported.
@@ -579,7 +584,7 @@ void transport_free_session(struct se_session *se_sess)
 		sbitmap_queue_free(&se_sess->sess_tag_pool);
 		kvfree(se_sess->sess_cmd_map);
 	}
-	percpu_ref_exit(&se_sess->cmd_count);
+	transport_uninit_session(se_sess);
 	kmem_cache_free(se_sess_cache, se_sess);
 }
 EXPORT_SYMBOL(transport_free_session);
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 0d00ccbeb0503..44e15d7fb2f09 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -474,7 +474,7 @@ int target_xcopy_setup_pt(void)
 	memset(&xcopy_pt_sess, 0, sizeof(struct se_session));
 	ret = transport_init_session(&xcopy_pt_sess);
 	if (ret < 0)
-		return ret;
+		goto destroy_wq;
 
 	xcopy_pt_nacl.se_tpg = &xcopy_pt_tpg;
 	xcopy_pt_nacl.nacl_sess = &xcopy_pt_sess;
@@ -483,12 +483,19 @@ int target_xcopy_setup_pt(void)
 	xcopy_pt_sess.se_node_acl = &xcopy_pt_nacl;
 
 	return 0;
+
+destroy_wq:
+	destroy_workqueue(xcopy_wq);
+	xcopy_wq = NULL;
+	return ret;
 }
 
 void target_xcopy_release_pt(void)
 {
-	if (xcopy_wq)
+	if (xcopy_wq) {
 		destroy_workqueue(xcopy_wq);
+		transport_uninit_session(&xcopy_pt_sess);
+	}
 }
 
 /*
-- 
2.25.1



