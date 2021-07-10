Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32BAE3C3017
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234234AbhGJCdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:33:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233483AbhGJCb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:31:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ED9D61428;
        Sat, 10 Jul 2021 02:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884059;
        bh=dHzZKRZ3FDowREux2qcPuORWFSKvSiAaYuR4hFegqZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OWg8UzyKxSf9CX3iAGWtiwjRP1biqNTPytUnDPDI6CdO+e+vJI1STjBfKQjPOt7o5
         QuV7hL+WLWupgyfYzn7XxuNffeAt411RLTk3CcMxeRJnGw/aFDfB88EoBLseF3M93l
         dko9dsOPZ4ojUU9jtQH/Aj5t3zQfKf4/eMAQIlxqy/jlBb5+UDzqvN7bbgyBqLGhL4
         HZ4hwpna0pffczYE0AgKKSp/xCFhbw+5BnsWqWiP+drrRklG9oQk5y2ap4LInivisr
         tTdZMpm0FpdjaURbO8iDHgPdyhooyQcv7iqrG6EsCJA7tPdwV2xc0o3lZ7vrbfVJp3
         aEw3SzflVZbyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 23/63] scsi: iscsi: Add iscsi_cls_conn refcount helpers
Date:   Fri,  9 Jul 2021 22:26:29 -0400
Message-Id: <20210710022709.3170675-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit b1d19e8c92cfb0ded180ef3376c20e130414e067 ]

There are a couple places where we could free the iscsi_cls_conn while it's
still in use. This adds some helpers to get/put a refcount on the struct
and converts an exiting user. Subsequent commits will then use the helpers
to fix 2 bugs in the eh code.

Link: https://lore.kernel.org/r/20210525181821.7617-11-michael.christie@oracle.com
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libiscsi.c             |  7 ++-----
 drivers/scsi/scsi_transport_iscsi.c | 12 ++++++++++++
 include/scsi/scsi_transport_iscsi.h |  2 ++
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index c5b7d18513b6..b9981078375d 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1348,7 +1348,6 @@ void iscsi_session_failure(struct iscsi_session *session,
 			   enum iscsi_err err)
 {
 	struct iscsi_conn *conn;
-	struct device *dev;
 
 	spin_lock_bh(&session->frwd_lock);
 	conn = session->leadconn;
@@ -1357,10 +1356,8 @@ void iscsi_session_failure(struct iscsi_session *session,
 		return;
 	}
 
-	dev = get_device(&conn->cls_conn->dev);
+	iscsi_get_conn(conn->cls_conn);
 	spin_unlock_bh(&session->frwd_lock);
-	if (!dev)
-	        return;
 	/*
 	 * if the host is being removed bypass the connection
 	 * recovery initialization because we are going to kill
@@ -1370,7 +1367,7 @@ void iscsi_session_failure(struct iscsi_session *session,
 		iscsi_conn_error_event(conn->cls_conn, err);
 	else
 		iscsi_conn_failure(conn, err);
-	put_device(dev);
+	iscsi_put_conn(conn->cls_conn);
 }
 EXPORT_SYMBOL_GPL(iscsi_session_failure);
 
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index a26df7d6d5d1..2f1553d0a10e 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2308,6 +2308,18 @@ int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
 }
 EXPORT_SYMBOL_GPL(iscsi_destroy_conn);
 
+void iscsi_put_conn(struct iscsi_cls_conn *conn)
+{
+	put_device(&conn->dev);
+}
+EXPORT_SYMBOL_GPL(iscsi_put_conn);
+
+void iscsi_get_conn(struct iscsi_cls_conn *conn)
+{
+	get_device(&conn->dev);
+}
+EXPORT_SYMBOL_GPL(iscsi_get_conn);
+
 /*
  * iscsi interface functions
  */
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 325ae731d9ad..71c78410e6ab 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -423,6 +423,8 @@ extern void iscsi_remove_session(struct iscsi_cls_session *session);
 extern void iscsi_free_session(struct iscsi_cls_session *session);
 extern struct iscsi_cls_conn *iscsi_create_conn(struct iscsi_cls_session *sess,
 						int dd_size, uint32_t cid);
+extern void iscsi_put_conn(struct iscsi_cls_conn *conn);
+extern void iscsi_get_conn(struct iscsi_cls_conn *conn);
 extern int iscsi_destroy_conn(struct iscsi_cls_conn *conn);
 extern void iscsi_unblock_session(struct iscsi_cls_session *session);
 extern void iscsi_block_session(struct iscsi_cls_session *session);
-- 
2.30.2

