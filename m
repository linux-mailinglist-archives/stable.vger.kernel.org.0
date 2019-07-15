Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0583F68CF2
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732726AbfGONzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732259AbfGONzL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:55:11 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F3C12067C;
        Mon, 15 Jul 2019 13:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198909;
        bh=uIxwGh11w8bs6mPsamrje8/1REWkHMV4vr8N6bdpo3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cyvL04hlASNaNDH8EEzlAgw9KR31VFCVkd7c0kyxTZXgZ052bTWKlghmgmwf+PRdN
         TGbT/+w043zm3tZ2mWp4TM6jQlI3PtMUY/tYwHFh6b4PFpRQWbuLzrFpB+vCvhQKs1
         38Wqp+Hbm/jpzIDuc8CCyCP9+e68xZOiqks04WHc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 138/249] lightnvm: fix uninitialized pointer in nvm_remove_tgt()
Date:   Mon, 15 Jul 2019 09:45:03 -0400
Message-Id: <20190715134655.4076-138-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 2f5af4ab7de14bd35f3435e6a47300276bbb6c17 ]

With gcc 4.1:

    drivers/lightnvm/core.c: In function ‘nvm_remove_tgt’:
    drivers/lightnvm/core.c:510: warning: ‘t’ is used uninitialized in this function

Indeed, if no NVM devices have been registered, t will be an
uninitialized pointer, and may be dereferenced later.  A call to
nvm_remove_tgt() can be triggered from userspace by issuing the
NVM_DEV_REMOVE ioctl on the lightnvm control device.

Fix this by preinitializing t to NULL.

Fixes: 843f2edbdde085b4 ("lightnvm: do not remove instance under global lock")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Matias Bjørling <mb@lightnvm.io>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/lightnvm/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/lightnvm/core.c b/drivers/lightnvm/core.c
index 7d555b110ecd..a600934fdd9c 100644
--- a/drivers/lightnvm/core.c
+++ b/drivers/lightnvm/core.c
@@ -478,7 +478,7 @@ static void __nvm_remove_target(struct nvm_target *t, bool graceful)
  */
 static int nvm_remove_tgt(struct nvm_ioctl_remove *remove)
 {
-	struct nvm_target *t;
+	struct nvm_target *t = NULL;
 	struct nvm_dev *dev;
 
 	down_read(&nvm_lock);
-- 
2.20.1

