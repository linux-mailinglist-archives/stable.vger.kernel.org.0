Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF175A05DB
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbiHYBgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233201AbiHYBfd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:35:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F1E96FC6;
        Wed, 24 Aug 2022 18:35:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F81EB826E2;
        Thu, 25 Aug 2022 01:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E0DC433C1;
        Thu, 25 Aug 2022 01:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391327;
        bh=5h/d4iI4GYTakGSKNwvrLAXYxyw/LIb4048SQXx+FTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T2Ko1tD8WGMk5VNd/C02NvpYZDsBnYYKEJsruzQtiPfQrFmT6Hg4+A/GEhp9WAg85
         /mTVPKxv9mRXk/fG+cSc5sG0H+bTBqR1e4COdvKkcaABdALUb3+1x4NhDKSWf25Pb9
         YatlJQ5tYeH0reU75X+qV4kzU1peTd+8J3jl7p0IhMSF+f+V0lU9TNsBSfM9kMJ9XJ
         S7bcrfW2DnKZ4taNBZ9gkuVcWbBAZhAp6rmZmMMXVq4ewoi7zs64XX30WpzGY9sg+G
         Xjgo8tXhcqKBQFkCJetoLD7Wuo+quQvmoqyTgFTPXTmDTdhR6O11QHV24B2Snw+8Wm
         FqRNgclMmmtug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        atteh.mailbox@gmail.com, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 15/38] ksmbd: return STATUS_BAD_NETWORK_NAME error status if share is not configured
Date:   Wed, 24 Aug 2022 21:33:38 -0400
Message-Id: <20220825013401.22096-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013401.22096-1-sashal@kernel.org>
References: <20220825013401.22096-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 0d28e723a28c..940385c6a913 100644
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
index a9c33d15ca1f..bbb3958b6469 100644
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

