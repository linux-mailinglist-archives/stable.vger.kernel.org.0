Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B435AB084
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237979AbiIBMyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238010AbiIBMx0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:53:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C214BF9940;
        Fri,  2 Sep 2022 05:37:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54AA2B82AE2;
        Fri,  2 Sep 2022 12:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6FCC433C1;
        Fri,  2 Sep 2022 12:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122207;
        bh=AyoUCDITYVxRiU7eJuWQT5v3RL+D8n4SQJt7lcoFtRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sS940ZgcjqRgAZYhgTJU/bImAFp18vvIj2/qI5vchVbSGPwFGK9pNF9QkOrrC/8Tz
         0RYyxLxX4jTgKwkGPprWW8Bjh2P32kKMsa0YZYiQj0cWnRqU17e1BahsC+LSNO8c5w
         GyvtNZsMQSDb56y8m2YeoQiiffG/TiVxyuH9zAjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 46/72] ksmbd: return STATUS_BAD_NETWORK_NAME error status if share is not configured
Date:   Fri,  2 Sep 2022 14:19:22 +0200
Message-Id: <20220902121406.281634426@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
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
index a9c33d15ca1fb..bbb3958b6469d 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1930,8 +1930,9 @@ int smb2_tree_connect(struct ksmbd_work *work)
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



