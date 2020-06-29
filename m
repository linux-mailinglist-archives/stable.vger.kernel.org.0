Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844EA20DEB6
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732443AbgF2U2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:28:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732501AbgF2TZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6891D253E2;
        Mon, 29 Jun 2020 15:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445325;
        bh=Z+lOGaPeEiSVC2XbgGFRsgc+lOH7cZOhLcUrKI7FS/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ckYvKjGPVUjZ3Se+7r4ewinvsdxtzCbG26gAaSgx/yzjUt0AsrYdo2RxYMvYwWgbR
         qI7aXnMEHD9LIfeP0BCgrZa43Xa9M6TN6X4ZgHVtphUDq8QgxoDhr9Ou9CzLYfPLUg
         PbzbrGlZgP5e4I1K/FN/cDW+1WpCZAZbAHJ41/Ps=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>, Mike Gerow <gerow@google.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        =?UTF-8?q?Kai=20L=C3=BCke?= <kai@kinvolk.io>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 091/191] crypto: algboss - don't wait during notifier callback
Date:   Mon, 29 Jun 2020 11:38:27 -0400
Message-Id: <20200629154007.2495120-92-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 77251e41f89a813b4090f5199442f217bbf11297 upstream.

When a crypto template needs to be instantiated, CRYPTO_MSG_ALG_REQUEST
is sent to crypto_chain.  cryptomgr_schedule_probe() handles this by
starting a thread to instantiate the template, then waiting for this
thread to complete via crypto_larval::completion.

This can deadlock because instantiating the template may require loading
modules, and this (apparently depending on userspace) may need to wait
for the crc-t10dif module (lib/crc-t10dif.c) to be loaded.  But
crc-t10dif's module_init function uses crypto_register_notifier() and
therefore takes crypto_chain.rwsem for write.  That can't proceed until
the notifier callback has finished, as it holds this semaphore for read.

Fix this by removing the wait on crypto_larval::completion from within
cryptomgr_schedule_probe().  It's actually unnecessary because
crypto_alg_mod_lookup() calls crypto_larval_wait() itself after sending
CRYPTO_MSG_ALG_REQUEST.

This only actually became a problem in v4.20 due to commit b76377543b73
("crc-t10dif: Pick better transform if one becomes available"), but the
unnecessary wait was much older.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207159
Reported-by: Mike Gerow <gerow@google.com>
Fixes: 398710379f51 ("crypto: algapi - Move larval completion into algboss")
Cc: <stable@vger.kernel.org> # v3.6+
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reported-by: Kai Lüke <kai@kinvolk.io>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/algboss.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/crypto/algboss.c b/crypto/algboss.c
index 6e39d9c05b98a..5cbc588555ca0 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -194,8 +194,6 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 	if (IS_ERR(thread))
 		goto err_put_larval;
 
-	wait_for_completion_interruptible(&larval->completion);
-
 	return NOTIFY_STOP;
 
 err_put_larval:
-- 
2.25.1

