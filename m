Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CCC3741E8
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234760AbhEEQmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234472AbhEEQj5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:39:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AE2F6157F;
        Wed,  5 May 2021 16:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232463;
        bh=QONIRF+5ydiIWkaO9VfJlV6cCc1Xy+VMsn1t9uBfZC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QsTYoRWnjuuBZIKPqZNuZXdNHxb5fnLMQUIXxiKWq4HFfC8t75fOroi82vBs+o8jO
         2BeTYHBHtdHIDqDMMfBmBJRGr++Cw/7fkOChI7iGjj8x7wrRXNuiCPH4KqDylGRYN8
         WJok4+ACRxOz+6XrXAK7bcygz2C4hZWp9Qdx6OAipdykplr0jX9ZQ/qT1rt2JY3URK
         /M/MyI+pBQIOMa8EmNrYskCmDU9BkZN4k8JULhuckM388raQ4QzIDk4uJat8lfEijF
         pUmsRn8ODKHy/0FmzHxp23S9GiSl88CE6naU9ROEGv1fWp7y5kT3nsWXXpzOkN5Hrp
         6os5WU/9ZRBbg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.11 006/104] fs: dlm: add check if dlm is currently running
Date:   Wed,  5 May 2021 12:32:35 -0400
Message-Id: <20210505163413.3461611-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 517461630d1c25ee4dfc1dee80973a64189d6ccf ]

This patch adds checks for dlm config attributes regarding to protocol
parameters as it makes only sense to change them when dlm is not running.
It also adds a check for valid protocol specifiers and return invalid
argument if they are not supported.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/config.c   | 34 ++++++++++++++++++++++++++++++++--
 fs/dlm/lowcomms.c |  2 +-
 fs/dlm/lowcomms.h |  3 +++
 3 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 8439610c266a..88d95d96e36c 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -164,6 +164,36 @@ static ssize_t cluster_##name##_show(struct config_item *item, char *buf)     \
 }                                                                             \
 CONFIGFS_ATTR(cluster_, name);
 
+static int dlm_check_protocol_and_dlm_running(unsigned int x)
+{
+	switch (x) {
+	case 0:
+		/* TCP */
+		break;
+	case 1:
+		/* SCTP */
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (dlm_allow_conn)
+		return -EBUSY;
+
+	return 0;
+}
+
+static int dlm_check_zero_and_dlm_running(unsigned int x)
+{
+	if (!x)
+		return -EINVAL;
+
+	if (dlm_allow_conn)
+		return -EBUSY;
+
+	return 0;
+}
+
 static int dlm_check_zero(unsigned int x)
 {
 	if (!x)
@@ -180,7 +210,7 @@ static int dlm_check_buffer_size(unsigned int x)
 	return 0;
 }
 
-CLUSTER_ATTR(tcp_port, dlm_check_zero);
+CLUSTER_ATTR(tcp_port, dlm_check_zero_and_dlm_running);
 CLUSTER_ATTR(buffer_size, dlm_check_buffer_size);
 CLUSTER_ATTR(rsbtbl_size, dlm_check_zero);
 CLUSTER_ATTR(recover_timer, dlm_check_zero);
@@ -188,7 +218,7 @@ CLUSTER_ATTR(toss_secs, dlm_check_zero);
 CLUSTER_ATTR(scan_secs, dlm_check_zero);
 CLUSTER_ATTR(log_debug, NULL);
 CLUSTER_ATTR(log_info, NULL);
-CLUSTER_ATTR(protocol, NULL);
+CLUSTER_ATTR(protocol, dlm_check_protocol_and_dlm_running);
 CLUSTER_ATTR(mark, NULL);
 CLUSTER_ATTR(timewarn_cs, dlm_check_zero);
 CLUSTER_ATTR(waitwarn_us, NULL);
diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 440dce99d0d9..c438ce0ac115 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -135,7 +135,7 @@ static DEFINE_SPINLOCK(dlm_node_addrs_spin);
 static struct listen_connection listen_con;
 static struct sockaddr_storage *dlm_local_addr[DLM_MAX_ADDR_COUNT];
 static int dlm_local_count;
-static int dlm_allow_conn;
+int dlm_allow_conn;
 
 /* Work queues */
 static struct workqueue_struct *recv_workqueue;
diff --git a/fs/dlm/lowcomms.h b/fs/dlm/lowcomms.h
index 790d6703b17e..bcd4dbd1dc98 100644
--- a/fs/dlm/lowcomms.h
+++ b/fs/dlm/lowcomms.h
@@ -14,6 +14,9 @@
 
 #define LOWCOMMS_MAX_TX_BUFFER_LEN	4096
 
+/* switch to check if dlm is running */
+extern int dlm_allow_conn;
+
 int dlm_lowcomms_start(void);
 void dlm_lowcomms_stop(void);
 void dlm_lowcomms_exit(void);
-- 
2.30.2

