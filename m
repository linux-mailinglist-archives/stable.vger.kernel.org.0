Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0A22061B9
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404163AbgFWUtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:49:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392629AbgFWUtO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:49:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B079A2098B;
        Tue, 23 Jun 2020 20:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945354;
        bh=mAnF15wAyu4dE2ORZ90SsLT8GhRsD5iyWzmJTPigbMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+Tb1vDoHjsUbisRvYBjnDrFdZMqftxfZLxTC7/ahdeTXiOLL5x+mt4AekRqjg173
         TLktX7cYgLMkrum1wAtyeCiJ1nMqvXSILPpvjnLCk6sqpYCJtRgKJq+agSPD4ES7xC
         nMTF7mRb/PkXYDPxU1bQrimJECnLhXINODQ/68XY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Gerow <gerow@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        =?UTF-8?q?Kai=20L=C3=BCke?= <kai@kinvolk.io>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 131/136] crypto: algboss - dont wait during notifier callback
Date:   Tue, 23 Jun 2020 21:59:47 +0200
Message-Id: <20200623195310.402566070@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 crypto/algboss.c |    2 --
 1 file changed, 2 deletions(-)

--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -194,8 +194,6 @@ static int cryptomgr_schedule_probe(stru
 	if (IS_ERR(thread))
 		goto err_put_larval;
 
-	wait_for_completion_interruptible(&larval->completion);
-
 	return NOTIFY_STOP;
 
 err_put_larval:


