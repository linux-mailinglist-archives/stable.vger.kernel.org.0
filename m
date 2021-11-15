Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7235450AA5
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236530AbhKORM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:12:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:41622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231582AbhKORLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:11:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 689DD61BF5;
        Mon, 15 Nov 2021 17:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996138;
        bh=VEHNeTno1hGOmPbcQZkUvtYTx4/orCAVnY1faZy4R1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ucB6SZamluhFaRuffP7MjocW0B4K7gra9qSBXGfSFEHuZ68WBdJSP/m/k2OgJS8bd
         a3lequqzFaKLB2a78Rv8XEYMPNCSkTaTZBhffxXtpwq2PK51JnkALveaGxL4Po+R3C
         Sr33IwiyktgmMenc3rSDe6KKeH4Nq01J6P4+4W1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Todd Kjos <tkjos@google.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.4 005/355] binder: use cred instead of task for getsecid
Date:   Mon, 15 Nov 2021 17:58:49 +0100
Message-Id: <20211115165313.732018691@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Kjos <tkjos@google.com>

commit 4d5b5539742d2554591751b4248b0204d20dcc9d upstream.

Use the 'struct cred' saved at binder_open() to lookup
the security ID via security_cred_getsecid(). This
ensures that the security context that opened binder
is the one used to generate the secctx.

Cc: stable@vger.kernel.org # 5.4+
Fixes: ec74136ded79 ("binder: create node flag to request sender's security context")
Signed-off-by: Todd Kjos <tkjos@google.com>
Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    2 +-
 include/linux/security.h |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3106,7 +3106,7 @@ static void binder_transaction(struct bi
 		u32 secid;
 		size_t added_size;
 
-		security_task_getsecid(proc->tsk, &secid);
+		security_cred_getsecid(proc->cred, &secid);
 		ret = security_secid_to_secctx(secid, &secctx, &secctx_sz);
 		if (ret) {
 			return_error = BR_FAILED_REPLY;
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -985,6 +985,11 @@ static inline void security_transfer_cre
 {
 }
 
+static inline void security_cred_getsecid(const struct cred *c, u32 *secid)
+{
+	*secid = 0;
+}
+
 static inline int security_kernel_act_as(struct cred *cred, u32 secid)
 {
 	return 0;


