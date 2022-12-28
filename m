Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A365657FB5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234381AbiL1QIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234450AbiL1QHj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:07:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A53193D5
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:07:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4046D6155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:07:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B97C433F1;
        Wed, 28 Dec 2022 16:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243656;
        bh=7sjJ4Fdw+MreHOFVvOgpuhnwdQJ4IvbE2qMzOYOLmPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FriYpyEhDaKeH/xmfdn+7OhHE7CZ8AW5+EmI3Pk2DUG6yDsuAzmfOxj+PtmSia1LT
         ceWykw/KjVle3woPPwI5Q8mhjScBAtL18ccKoxJRc7Y/RC0exkqgGEGIsh9K3yLjWj
         1Dw4s1m0+oYbeEnfJIHptN6yIzbKiwYzs8pm0V1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiu Jianfeng <xiujianfeng@huawei.com>,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0564/1073] apparmor: Use pointer to struct aa_label for lbs_cred
Date:   Wed, 28 Dec 2022 15:35:52 +0100
Message-Id: <20221228144343.376332163@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 37923d4321b1e38170086da2c117f78f2b0f49c6 ]

According to the implementations of cred_label() and set_cred_label(),
we should use pointer to struct aa_label for lbs_cred instead of struct
aa_task_ctx, this patch fixes it.

Fixes: bbd3662a8348 ("Infrastructure management of the cred security blob")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/lsm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index e29cade7b662..9eb7972e08e4 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -1194,10 +1194,10 @@ static int apparmor_inet_conn_request(const struct sock *sk, struct sk_buff *skb
 #endif
 
 /*
- * The cred blob is a pointer to, not an instance of, an aa_task_ctx.
+ * The cred blob is a pointer to, not an instance of, an aa_label.
  */
 struct lsm_blob_sizes apparmor_blob_sizes __lsm_ro_after_init = {
-	.lbs_cred = sizeof(struct aa_task_ctx *),
+	.lbs_cred = sizeof(struct aa_label *),
 	.lbs_file = sizeof(struct aa_file_ctx),
 	.lbs_task = sizeof(struct aa_task_ctx),
 };
-- 
2.35.1



