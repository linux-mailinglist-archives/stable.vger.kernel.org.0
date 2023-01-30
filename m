Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB416811FA
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237519AbjA3ORm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237476AbjA3ORV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:17:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312CC3E093
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:16:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9E1BB80DEB
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FDFCC4339B;
        Mon, 30 Jan 2023 14:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088216;
        bh=txMnUCQ+1YLXG3R0Lu4/Puj1zEYCp6oQYtx1+RuYkeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LpY+LdqLA5QX90yRC0hel13n6rr6kFalE6ddFW4a0phr1RiORdUolKDJUK9/EAykf
         q3QsDmQ+8DpM2b6nKjJiNdjPI4bV3AP0MrQLKfbszto2q35T2SV0x+bbozeLOYko/b
         Mtr03xHY1udsBdgCPYcfcWelHerQwDouws4pJvh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Namjae Jeon <linkinjeon@kernel.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 154/204] ksmbd: add smbd max io size parameter
Date:   Mon, 30 Jan 2023 14:51:59 +0100
Message-Id: <20230130134323.316893210@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

commit 65bb45b97b578c8eed1ffa80caec84708df49729 upstream.

Add 'smbd max io size' parameter to adjust smbd-direct max read/write
size.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/ksmbd_netlink.h  |    3 ++-
 fs/ksmbd/transport_ipc.c  |    3 +++
 fs/ksmbd/transport_rdma.c |    8 +++++++-
 fs/ksmbd/transport_rdma.h |    6 ++++++
 4 files changed, 18 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/ksmbd_netlink.h
+++ b/fs/ksmbd/ksmbd_netlink.h
@@ -104,7 +104,8 @@ struct ksmbd_startup_request {
 					 */
 	__u32	sub_auth[3];		/* Subauth value for Security ID */
 	__u32	smb2_max_credits;	/* MAX credits */
-	__u32	reserved[128];		/* Reserved room */
+	__u32	smbd_max_io_size;	/* smbd read write size */
+	__u32	reserved[127];		/* Reserved room */
 	__u32	ifc_list_sz;		/* interfaces list size */
 	__s8	____payload[];
 };
--- a/fs/ksmbd/transport_ipc.c
+++ b/fs/ksmbd/transport_ipc.c
@@ -26,6 +26,7 @@
 #include "mgmt/ksmbd_ida.h"
 #include "connection.h"
 #include "transport_tcp.h"
+#include "transport_rdma.h"
 
 #define IPC_WAIT_TIMEOUT	(2 * HZ)
 
@@ -303,6 +304,8 @@ static int ipc_server_config_on_startup(
 		init_smb2_max_trans_size(req->smb2_max_trans);
 	if (req->smb2_max_credits)
 		init_smb2_max_credits(req->smb2_max_credits);
+	if (req->smbd_max_io_size)
+		init_smbd_max_io_size(req->smbd_max_io_size);
 
 	ret = ksmbd_set_netbios_name(req->netbios_name);
 	ret |= ksmbd_set_server_string(req->server_string);
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -75,7 +75,7 @@ static int smb_direct_max_fragmented_rec
 /*  The maximum single-message size which can be received */
 static int smb_direct_max_receive_size = 8192;
 
-static int smb_direct_max_read_write_size = 1024 * 1024;
+static int smb_direct_max_read_write_size = SMBD_DEFAULT_IOSIZE;
 
 static int smb_direct_max_outstanding_rw_ops = 8;
 
@@ -201,6 +201,12 @@ struct smb_direct_rdma_rw_msg {
 	struct scatterlist	sg_list[0];
 };
 
+void init_smbd_max_io_size(unsigned int sz)
+{
+	sz = clamp_val(sz, SMBD_MIN_IOSIZE, SMBD_MAX_IOSIZE);
+	smb_direct_max_read_write_size = sz;
+}
+
 static inline int get_buf_page_count(void *buf, int size)
 {
 	return DIV_ROUND_UP((uintptr_t)buf + size, PAGE_SIZE) -
--- a/fs/ksmbd/transport_rdma.h
+++ b/fs/ksmbd/transport_rdma.h
@@ -9,6 +9,10 @@
 
 #define SMB_DIRECT_PORT	5445
 
+#define SMBD_DEFAULT_IOSIZE (8 * 1024 * 1024)
+#define SMBD_MIN_IOSIZE (512 * 1024)
+#define SMBD_MAX_IOSIZE (16 * 1024 * 1024)
+
 /* SMB DIRECT negotiation request packet [MS-SMBD] 2.2.1 */
 struct smb_direct_negotiate_req {
 	__le16 min_version;
@@ -54,10 +58,12 @@ struct smb_direct_data_transfer {
 int ksmbd_rdma_init(void);
 int ksmbd_rdma_destroy(void);
 bool ksmbd_rdma_capable_netdev(struct net_device *netdev);
+void init_smbd_max_io_size(unsigned int sz);
 #else
 static inline int ksmbd_rdma_init(void) { return 0; }
 static inline int ksmbd_rdma_destroy(void) { return 0; }
 static inline bool ksmbd_rdma_capable_netdev(struct net_device *netdev) { return false; }
+static inline void init_smbd_max_io_size(unsigned int sz) { }
 #endif
 
 #endif /* __KSMBD_TRANSPORT_RDMA_H__ */


