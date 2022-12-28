Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB0665802A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbiL1QOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:14:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233143AbiL1QON (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:14:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233841A21B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:12:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAA3BB8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12ECBC433F0;
        Wed, 28 Dec 2022 16:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243930;
        bh=C82UUF1Cw3IQ37sjwiUZ3lmZr/zoi0iq5pfDLLko1dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2sXQEXJaDjFHg+VWjhtxJ8s5dmpvFjzfvxyqvibvpnBnbJRVroeMOD0UGROQERVN
         ByhOgOGAuKYApKYi7rk0idhMCOsWTyCW71Ihr2Vj9fuMQvcL2S3bSZFVp2+iWFEmmz
         jViQB2YQiw93Dr1HaNzU/l6uD9o3dQbQYZcmiK/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiu Jianfeng <xiujianfeng@huawei.com>,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0581/1146] apparmor: Use pointer to struct aa_label for lbs_cred
Date:   Wed, 28 Dec 2022 15:35:20 +0100
Message-Id: <20221228144345.955831170@linuxfoundation.org>
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
index f56070270c69..1e2f40db15c5 100644
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



