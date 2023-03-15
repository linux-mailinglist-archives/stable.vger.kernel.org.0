Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10B86BB167
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbjCOM1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbjCOM0t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:26:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6F79B98A
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:26:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A4D761D5C
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B67C433EF;
        Wed, 15 Mar 2023 12:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883116;
        bh=jP8a0dlp6GRTXOKuejSQhyNvxmiW9xH5nHB2Oz6B90I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NBVzZ9Vv0LPtAE3Ant4gkSFpS6LgJqSRfLvl1q/7YIbVLvqQyiDGMupaj6CBvekt+
         cf0rjciNOnqTorcyfmnZdeRkO26kfJGRphys2zhRtmyWK+lSL7Twf83MV9jUfa9Uua
         oM1j6RzNZ+BuQtzLLiN7zDpxxUQPmtFvCoL+TYUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/145] fs: dlm: add midcomms init/start functions
Date:   Wed, 15 Mar 2023 13:11:28 +0100
Message-Id: <20230315115739.763010098@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index a1b34605742fc..1b49f375829d0 100644
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
@@ -705,7 +704,7 @@ int dlm_new_lockspace(const char *name, const char *cluster,
 	if (!ls_count) {
 		dlm_scand_stop();
 		dlm_midcomms_shutdown();
-		dlm_lowcomms_stop();
+		dlm_midcomms_stop();
 	}
  out:
 	mutex_unlock(&ls_lock);
@@ -889,7 +888,7 @@ int dlm_release_lockspace(void *lockspace, int force)
 	if (!error)
 		ls_count--;
 	if (!ls_count)
-		dlm_lowcomms_stop();
+		dlm_midcomms_stop();
 	mutex_unlock(&ls_lock);
 
 	return error;
diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index d56a8f88a3852..1eb95ba7e7772 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1959,10 +1959,6 @@ static const struct dlm_proto_ops dlm_sctp_ops = {
 int dlm_lowcomms_start(void)
 {
 	int error = -EINVAL;
-	int i;
-
-	for (i = 0; i < CONN_HASH_SIZE; i++)
-		INIT_HLIST_HEAD(&connection_hash[i]);
 
 	init_local();
 	if (!dlm_local_count) {
@@ -1971,8 +1967,6 @@ int dlm_lowcomms_start(void)
 		goto fail;
 	}
 
-	INIT_WORK(&listen_con.rwork, process_listen_recv_socket);
-
 	error = work_start();
 	if (error)
 		goto fail_local;
@@ -2011,6 +2005,16 @@ int dlm_lowcomms_start(void)
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
index 4ccae07cf0058..26433632d1717 100644
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
index afc66a1346d3d..974f7ebb3fe63 100644
--- a/fs/dlm/main.c
+++ b/fs/dlm/main.c
@@ -17,7 +17,7 @@
 #include "user.h"
 #include "memory.h"
 #include "config.h"
-#include "lowcomms.h"
+#include "midcomms.h"
 
 static int __init init_dlm(void)
 {
@@ -27,6 +27,8 @@ static int __init init_dlm(void)
 	if (error)
 		goto out;
 
+	dlm_midcomms_init();
+
 	error = dlm_lockspace_init();
 	if (error)
 		goto out_mem;
@@ -63,6 +65,7 @@ static int __init init_dlm(void)
  out_lockspace:
 	dlm_lockspace_exit();
  out_mem:
+	dlm_midcomms_exit();
 	dlm_memory_exit();
  out:
 	return error;
@@ -76,7 +79,7 @@ static void __exit exit_dlm(void)
 	dlm_config_exit();
 	dlm_memory_exit();
 	dlm_lockspace_exit();
-	dlm_lowcomms_exit();
+	dlm_midcomms_exit();
 	dlm_unregister_debugfs();
 }
 
diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index 702c14de7a4bd..84a7a39fc12e6 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -1142,13 +1142,28 @@ void dlm_midcomms_commit_mhandle(struct dlm_mhandle *mh)
 }
 
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
index 579abc6929be2..1a36b7834dfc5 100644
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



