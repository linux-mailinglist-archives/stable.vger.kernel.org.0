Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8342A15F0CF
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388114AbgBNP5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:57:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:39460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388103AbgBNP5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:57:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E89B222C4;
        Fri, 14 Feb 2020 15:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695824;
        bh=6vAb/3AnW2cySkICFJWn4lWI0wr0JfuL5Ldafl3W6AE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DReua4Uwr5YWFNUVQALTnwoISAtJ+VoqxTyv7eOlPfaI6+h7ftCaPEP9CKRDcKY3L
         fMJxsetzFjDLoUsBnomeMtUAGYXa93+5lFWofsL/PDkPlJsD7s5PkRMajZrGOhaO+l
         RxiBsI558Yc954Whv6LpzCZGnGXD2qCOytYn4PO8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zaibo Xu <xuzaibo@huawei.com>, Arnd Bergmann <arnd@arndb.de>,
        Marco Elver <elver@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 378/542] crypto: hisilicon - Update debugfs usage of SEC V2
Date:   Fri, 14 Feb 2020 10:46:10 -0500
Message-Id: <20200214154854.6746-378-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zaibo Xu <xuzaibo@huawei.com>

[ Upstream commit ca0d158dc9e5dc0902c1d507d82178d97f6f5709 ]

Applied some advices of Marco Elver on atomic usage of Debugfs,
which is carried out by basing on Arnd Bergmann's fixing patch.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Marco Elver <elver@google.com>
Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec.h        |  2 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c |  8 ++++----
 drivers/crypto/hisilicon/sec2/sec_main.c   | 18 +++++++++---------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index b846d73d9a855..841f4c56ca73c 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -40,7 +40,7 @@ struct sec_req {
 	int req_id;
 
 	/* Status of the SEC request */
-	atomic_t fake_busy;
+	bool fake_busy;
 };
 
 /**
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 0a5391fff485c..2475aaf0d59b9 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -141,7 +141,7 @@ static int sec_bd_send(struct sec_ctx *ctx, struct sec_req *req)
 		return -ENOBUFS;
 
 	if (!ret) {
-		if (atomic_read(&req->fake_busy))
+		if (req->fake_busy)
 			ret = -EBUSY;
 		else
 			ret = -EINPROGRESS;
@@ -641,7 +641,7 @@ static void sec_skcipher_callback(struct sec_ctx *ctx, struct sec_req *req)
 	if (ctx->c_ctx.c_mode == SEC_CMODE_CBC && req->c_req.encrypt)
 		sec_update_iv(req);
 
-	if (atomic_cmpxchg(&req->fake_busy, 1, 0) != 1)
+	if (req->fake_busy)
 		sk_req->base.complete(&sk_req->base, -EINPROGRESS);
 
 	sk_req->base.complete(&sk_req->base, req->err_type);
@@ -672,9 +672,9 @@ static int sec_request_init(struct sec_ctx *ctx, struct sec_req *req)
 	}
 
 	if (ctx->fake_req_limit <= atomic_inc_return(&qp_ctx->pending_reqs))
-		atomic_set(&req->fake_busy, 1);
+		req->fake_busy = true;
 	else
-		atomic_set(&req->fake_busy, 0);
+		req->fake_busy = false;
 
 	ret = ctx->req_op->get_res(ctx, req);
 	if (ret) {
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index ab742dfbab997..d40e2da3b05da 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -608,13 +608,13 @@ static const struct file_operations sec_dbg_fops = {
 	.write = sec_debug_write,
 };
 
-static int debugfs_atomic64_t_get(void *data, u64 *val)
+static int sec_debugfs_atomic64_get(void *data, u64 *val)
 {
-        *val = atomic64_read((atomic64_t *)data);
-        return 0;
+	*val = atomic64_read((atomic64_t *)data);
+	return 0;
 }
-DEFINE_DEBUGFS_ATTRIBUTE(fops_atomic64_t_ro, debugfs_atomic64_t_get, NULL,
-                        "%lld\n");
+DEFINE_DEBUGFS_ATTRIBUTE(sec_atomic64_ops, sec_debugfs_atomic64_get,
+			 NULL, "%lld\n");
 
 static int sec_core_debug_init(struct sec_dev *sec)
 {
@@ -636,11 +636,11 @@ static int sec_core_debug_init(struct sec_dev *sec)
 
 	debugfs_create_regset32("regs", 0444, tmp_d, regset);
 
-	debugfs_create_file("send_cnt", 0444, tmp_d, &dfx->send_cnt,
-			    &fops_atomic64_t_ro);
+	debugfs_create_file("send_cnt", 0444, tmp_d,
+			    &dfx->send_cnt, &sec_atomic64_ops);
 
-	debugfs_create_file("recv_cnt", 0444, tmp_d, &dfx->recv_cnt,
-			    &fops_atomic64_t_ro);
+	debugfs_create_file("recv_cnt", 0444, tmp_d,
+			    &dfx->recv_cnt, &sec_atomic64_ops);
 
 	return 0;
 }
-- 
2.20.1

