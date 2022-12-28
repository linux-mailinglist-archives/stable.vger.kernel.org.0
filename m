Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C0D6581C8
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbiL1Qbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:31:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234613AbiL1Qba (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:31:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791F61CB0F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:27:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EB32B816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEBCC433D2;
        Wed, 28 Dec 2022 16:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244848;
        bh=GtikZnRZ4OaT2m0mUo8jo9s7mJwxMQk3RZknu1q13mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W72qYqmxpu+VxsOmURv4bzeRi9MK8RDcLnlWF0ujfoj2hZ6LgmpCyLP7BG2fvadH+
         Fe8HAJG85dQPldAEt5gQYILqIxrz4kPHEi+Z73kwhCvMm/3A9OmmyIDpHZH/UWO8de
         f1O8oUYOwj06Ac+YoRhbER9lFrWmoZCkIEGsR4bE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiu Jianfeng <xiujianfeng@huawei.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0747/1146] ksmbd: Fix resource leak in ksmbd_session_rpc_open()
Date:   Wed, 28 Dec 2022 15:38:06 +0100
Message-Id: <20221228144350.436287025@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit bc044414fa0326a4e5c3c509c00b1fcaf621b5f4 ]

When ksmbd_rpc_open() fails then it must call ksmbd_rpc_id_free() to
undo the result of ksmbd_ipc_id_alloc().

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/mgmt/user_session.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/mgmt/user_session.c b/fs/ksmbd/mgmt/user_session.c
index 3fa2139a0b30..92b1603b5abe 100644
--- a/fs/ksmbd/mgmt/user_session.c
+++ b/fs/ksmbd/mgmt/user_session.c
@@ -108,15 +108,17 @@ int ksmbd_session_rpc_open(struct ksmbd_session *sess, char *rpc_name)
 	entry->method = method;
 	entry->id = ksmbd_ipc_id_alloc();
 	if (entry->id < 0)
-		goto error;
+		goto free_entry;
 
 	resp = ksmbd_rpc_open(sess, entry->id);
 	if (!resp)
-		goto error;
+		goto free_id;
 
 	kvfree(resp);
 	return entry->id;
-error:
+free_id:
+	ksmbd_rpc_id_free(entry->id);
+free_entry:
 	list_del(&entry->list);
 	kfree(entry);
 	return -EINVAL;
-- 
2.35.1



