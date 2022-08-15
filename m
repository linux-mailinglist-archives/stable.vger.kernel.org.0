Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3F7594A13
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245140AbiHOXci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245013AbiHOX3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:29:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A60BB908;
        Mon, 15 Aug 2022 13:07:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD16AB81142;
        Mon, 15 Aug 2022 20:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A91FC433D6;
        Mon, 15 Aug 2022 20:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594074;
        bh=PubY1hmrGCf0b7CV+WmrD1xQ9cFgoAo/s7Yj5UkVxNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=margB09aOgF1l4NRzrTpPWFqnGcSUaJDufbfn1A4/D1sfuLIPj6TMC1C79tC4pFBD
         7IIsWXCzYyZ2Z24tDmy6SZ5bs6fTbTI78ev8XWMR0sIpGkfZ0BRIMlj0cVkTYmfjCi
         uAEltIyYGt1mh+ndTu+L3cvc7wK2FqodP/GXiC00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1051/1095] ksmbd: add smbd max io size parameter
Date:   Mon, 15 Aug 2022 20:07:30 +0200
Message-Id: <20220815180512.555659116@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 65bb45b97b578c8eed1ffa80caec84708df49729 ]

Add 'smbd max io size' parameter to adjust smbd-direct max read/write
size.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/ksmbd_netlink.h  | 3 ++-
 fs/ksmbd/transport_ipc.c  | 3 +++
 fs/ksmbd/transport_rdma.c | 8 +++++++-
 fs/ksmbd/transport_rdma.h | 6 ++++++
 4 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
index ebe6ca08467a..52aa0adeb951 100644
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
diff --git a/fs/ksmbd/transport_ipc.c b/fs/ksmbd/transport_ipc.c
index 3ad6881e0f7e..7cb0eeb07c80 100644
--- a/fs/ksmbd/transport_ipc.c
+++ b/fs/ksmbd/transport_ipc.c
@@ -26,6 +26,7 @@
 #include "mgmt/ksmbd_ida.h"
 #include "connection.h"
 #include "transport_tcp.h"
+#include "transport_rdma.h"
 
 #define IPC_WAIT_TIMEOUT	(2 * HZ)
 
@@ -303,6 +304,8 @@ static int ipc_server_config_on_startup(struct ksmbd_startup_request *req)
 		init_smb2_max_trans_size(req->smb2_max_trans);
 	if (req->smb2_max_credits)
 		init_smb2_max_credits(req->smb2_max_credits);
+	if (req->smbd_max_io_size)
+		init_smbd_max_io_size(req->smbd_max_io_size);
 
 	ret = ksmbd_set_netbios_name(req->netbios_name);
 	ret |= ksmbd_set_server_string(req->server_string);
diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index b44a5e584bac..afc66b9765e7 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -80,7 +80,7 @@ static int smb_direct_max_fragmented_recv_size = 1024 * 1024;
 /*  The maximum single-message size which can be received */
 static int smb_direct_max_receive_size = 8192;
 
-static int smb_direct_max_read_write_size = 8 * 1024 * 1024;
+static int smb_direct_max_read_write_size = SMBD_DEFAULT_IOSIZE;
 
 static LIST_HEAD(smb_direct_device_list);
 static DEFINE_RWLOCK(smb_direct_device_lock);
@@ -214,6 +214,12 @@ struct smb_direct_rdma_rw_msg {
 	struct scatterlist	sg_list[];
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
diff --git a/fs/ksmbd/transport_rdma.h b/fs/ksmbd/transport_rdma.h
index 5567d93a6f96..e7b4e6790fab 100644
--- a/fs/ksmbd/transport_rdma.h
+++ b/fs/ksmbd/transport_rdma.h
@@ -7,6 +7,10 @@
 #ifndef __KSMBD_TRANSPORT_RDMA_H__
 #define __KSMBD_TRANSPORT_RDMA_H__
 
+#define SMBD_DEFAULT_IOSIZE (8 * 1024 * 1024)
+#define SMBD_MIN_IOSIZE (512 * 1024)
+#define SMBD_MAX_IOSIZE (16 * 1024 * 1024)
+
 /* SMB DIRECT negotiation request packet [MS-SMBD] 2.2.1 */
 struct smb_direct_negotiate_req {
 	__le16 min_version;
@@ -52,10 +56,12 @@ struct smb_direct_data_transfer {
 int ksmbd_rdma_init(void);
 void ksmbd_rdma_destroy(void);
 bool ksmbd_rdma_capable_netdev(struct net_device *netdev);
+void init_smbd_max_io_size(unsigned int sz);
 #else
 static inline int ksmbd_rdma_init(void) { return 0; }
 static inline int ksmbd_rdma_destroy(void) { return 0; }
 static inline bool ksmbd_rdma_capable_netdev(struct net_device *netdev) { return false; }
+static inline void init_smbd_max_io_size(unsigned int sz) { }
 #endif
 
 #endif /* __KSMBD_TRANSPORT_RDMA_H__ */
-- 
2.35.1



