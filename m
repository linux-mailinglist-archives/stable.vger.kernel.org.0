Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD6F5AAFF5
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237153AbiIBMqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236652AbiIBMpY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:45:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772C6E1A80;
        Fri,  2 Sep 2022 05:33:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25D3B620DF;
        Fri,  2 Sep 2022 12:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6E6C433D6;
        Fri,  2 Sep 2022 12:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122008;
        bh=YAswBaI54FmrGFv/3FgYV6pl5yuiVekOIL5Memp56VQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3EF7LpBRWLSh2jdaPmJSBf3WaV8pJjvqXZ5pxFEsGr1g05G1bQGr3lCa3nMkwbgs
         0i3JNuzuXUjlMhXfK/lgFK6d5ahuRDYOZfhMaoTKZFr8RjvmpEt7D63c8YxDlKjx9g
         cQxXLzMAx8DsxqhrSe7animCvVaymmT1WbQ0iIck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 56/73] ksmbd: return STATUS_BAD_NETWORK_NAME error status if share is not configured
Date:   Fri,  2 Sep 2022 14:19:20 +0200
Message-Id: <20220902121406.278968570@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
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

[ Upstream commit fe54833dc8d97ef387e86f7c80537d51c503ca75 ]

If share is not configured in smb.conf, smb2 tree connect should return
STATUS_BAD_NETWORK_NAME instead of STATUS_BAD_NETWORK_PATH.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/mgmt/tree_connect.c | 2 +-
 fs/ksmbd/smb2pdu.c           | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/mgmt/tree_connect.c b/fs/ksmbd/mgmt/tree_connect.c
index 0d28e723a28c7..940385c6a9135 100644
--- a/fs/ksmbd/mgmt/tree_connect.c
+++ b/fs/ksmbd/mgmt/tree_connect.c
@@ -18,7 +18,7 @@
 struct ksmbd_tree_conn_status
 ksmbd_tree_conn_connect(struct ksmbd_session *sess, char *share_name)
 {
-	struct ksmbd_tree_conn_status status = {-EINVAL, NULL};
+	struct ksmbd_tree_conn_status status = {-ENOENT, NULL};
 	struct ksmbd_tree_connect_response *resp = NULL;
 	struct ksmbd_share_config *sc;
 	struct ksmbd_tree_connect *tree_conn = NULL;
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 28b5d20c8766e..824f17a101a9e 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1932,8 +1932,9 @@ int smb2_tree_connect(struct ksmbd_work *work)
 		rsp->hdr.Status = STATUS_SUCCESS;
 		rc = 0;
 		break;
+	case -ENOENT:
 	case KSMBD_TREE_CONN_STATUS_NO_SHARE:
-		rsp->hdr.Status = STATUS_BAD_NETWORK_PATH;
+		rsp->hdr.Status = STATUS_BAD_NETWORK_NAME;
 		break;
 	case -ENOMEM:
 	case KSMBD_TREE_CONN_STATUS_NOMEM:
-- 
2.35.1



