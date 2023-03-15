Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8966BB223
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbjCOMdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232597AbjCOMdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:33:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762598B042
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:32:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0E31B81E07
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E7AC433EF;
        Wed, 15 Mar 2023 12:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883525;
        bh=OBxoBTC7l7uFCA/gWjDOJIjVjWmPpgZHAt4JH1lPxeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rsa6bwR+lAbuAW6AEMmtdirFO55gJpdqFIPyX9i69V9+My0xfNy4CSAPo69pjY+mN
         6aHVFSgkr3HDAkkOZAobDzWOkV+mJWOT08UbuGCVaAm3ABsstA03r4QzBu2X9WQ229
         IjiUuSxlRWx7Q+OpAYVII7G4Ej/W4REZaAYNW41k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/143] fs: dlm: add midcomms init/start functions
Date:   Wed, 15 Mar 2023 13:11:57 +0100
Message-Id: <20230315115741.451724683@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 8b0188b0d60b6f6183b48380bac49fe080c5ded9 ]

This patch introduces leftovers of init, start, stop and exit
functionality. The dlm application layer should always call the midcomms
layer which getting aware of such event and redirect it to the lowcomms
layer. Some functionality which is currently handled inside the start
functionality of midcomms and lowcomms should be handled in the init
functionality as it only need to be initialized once when dlm is loaded.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Stable-dep-of: aad633dc0cf9 ("fs: dlm: start midcomms before scand")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lockspace.c |  5 ++---
 fs/dlm/lowcomms.c  | 16 ++++++++++------
 fs/dlm/lowcomms.h  |  1 +
 fs/dlm/main.c      |  7 +++++--
 fs/dlm/midcomms.c  | 17 ++++++++++++++++-
 fs/dlm/midcomms.h  |  3 +++
 6 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 04e1b4fe366dc..c3cf2e7996f6c 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -17,7 +17,6 @@
 #include "recoverd.h"
 #include "dir.h"
 #include "midcomms.h"
-#include "lowcomms.h"
 #include "config.h"
 #include "memory.h"
 #include "lock.h"
@@ -726,7 +725,7 @@ static int __dlm_new_lockspace(const char *name, const char *cluster,
 	if (!ls_count) {
 		dlm_scand_stop();
 		dlm_midcomms_shutdown();
-		dlm_lowcomms_stop();
+		dlm_midcomms_stop();
 	}
  out:
 	mutex_unlock(&ls_lock);
@@ -929,7 +928,7 @@ int dlm_release_lockspace(void *lockspace, int force)
 	if (!error)
 		ls_count--;
 	if (!ls_count)
-		dlm_lowcomms_stop();
+		dlm_midcomms_stop();
 	mutex_unlock(&ls_lock);
 
 	return error;
diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 871d4e9f49fb6..6ed09edabea0c 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1982,10 +1982,6 @@ static const struct dlm_proto_ops dlm_sctp_ops = {
 int dlm_lowcomms_start(void)
 {
 	int error = -EINVAL;
-	int i;
-
-	for (i = 0; i < CONN_HASH_SIZE; i++)
-		INIT_HLIST_HEAD(&connection_hash[i]);
 
 	init_local();
 	if (!dlm_local_count) {
@@ -1994,8 +1990,6 @@ int dlm_lowcomms_start(void)
 		goto fail;
 	}
 
-	INIT_WORK(&listen_con.rwork, process_listen_recv_socket);
-
 	error = work_start();
 	if (error)
 		goto fail_local;
@@ -2034,6 +2028,16 @@ int dlm_lowcomms_start(void)
 	return error;
 }
 
+void dlm_lowcomms_init(void)
+{
+	int i;
+
+	for (i = 0; i < CONN_HASH_SIZE; i++)
+		INIT_HLIST_HEAD(&connection_hash[i]);
+
+	INIT_WORK(&listen_con.rwork, process_listen_recv_socket);
+}
+
 void dlm_lowcomms_exit(void)
 {
 	struct dlm_node_addr *na, *safe;
diff --git a/fs/dlm/lowcomms.h b/fs/dlm/lowcomms.h
index 29369feea9916..bbce7a18416dc 100644
--- a/fs/dlm/lowcomms.h
+++ b/fs/dlm/lowcomms.h
@@ -35,6 +35,7 @@ extern int dlm_allow_conn;
 int dlm_lowcomms_start(void);
 void dlm_lowcomms_shutdown(void);
 void dlm_lowcomms_stop(void);
+void dlm_lowcomms_init(void);
 void dlm_lowcomms_exit(void);
 int dlm_lowcomms_close(int nodeid);
 struct dlm_msg *dlm_lowcomms_new_msg(int nodeid, int len, gfp_t allocation,
diff --git a/fs/dlm/main.c b/fs/dlm/main.c
index 1c5be4b70ac1b..a77338be32371 100644
--- a/fs/dlm/main.c
+++ b/fs/dlm/main.c
@@ -17,7 +17,7 @@
 #include "user.h"
 #include "memory.h"
 #include "config.h"
-#include "lowcomms.h"
+#include "midcomms.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/dlm.h>
@@ -30,6 +30,8 @@ static int __init init_dlm(void)
 	if (error)
 		goto out;
 
+	dlm_midcomms_init();
+
 	error = dlm_lockspace_init();
 	if (error)
 		goto out_mem;
@@ -66,6 +68,7 @@ static int __init init_dlm(void)
  out_lockspace:
 	dlm_lockspace_exit();
  out_mem:
+	dlm_midcomms_exit();
 	dlm_memory_exit();
  out:
 	return error;
@@ -79,7 +82,7 @@ static void __exit exit_dlm(void)
 	dlm_config_exit();
 	dlm_memory_exit();
 	dlm_lockspace_exit();
-	dlm_lowcomms_exit();
+	dlm_midcomms_exit();
 	dlm_unregister_debugfs();
 }
 
diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index 546c52c46b1c9..095f2005fb621 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -1160,13 +1160,28 @@ void dlm_midcomms_commit_mhandle(struct dlm_mhandle *mh)
 #endif
 
 int dlm_midcomms_start(void)
+{
+	return dlm_lowcomms_start();
+}
+
+void dlm_midcomms_stop(void)
+{
+	dlm_lowcomms_stop();
+}
+
+void dlm_midcomms_init(void)
 {
 	int i;
 
 	for (i = 0; i < CONN_HASH_SIZE; i++)
 		INIT_HLIST_HEAD(&node_hash[i]);
 
-	return dlm_lowcomms_start();
+	dlm_lowcomms_init();
+}
+
+void dlm_midcomms_exit(void)
+{
+	dlm_lowcomms_exit();
 }
 
 static void dlm_act_fin_ack_rcv(struct midcomms_node *node)
diff --git a/fs/dlm/midcomms.h b/fs/dlm/midcomms.h
index 82bcd96619228..f61fce622e93d 100644
--- a/fs/dlm/midcomms.h
+++ b/fs/dlm/midcomms.h
@@ -20,6 +20,9 @@ struct dlm_mhandle *dlm_midcomms_get_mhandle(int nodeid, int len,
 void dlm_midcomms_commit_mhandle(struct dlm_mhandle *mh);
 int dlm_midcomms_close(int nodeid);
 int dlm_midcomms_start(void);
+void dlm_midcomms_stop(void);
+void dlm_midcomms_init(void);
+void dlm_midcomms_exit(void);
 void dlm_midcomms_shutdown(void);
 void dlm_midcomms_add_member(int nodeid);
 void dlm_midcomms_remove_member(int nodeid);
-- 
2.39.2



