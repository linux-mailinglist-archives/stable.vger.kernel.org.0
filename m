Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30F2023440
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388991AbfETMZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:25:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388989AbfETMZH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:25:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DA6A20675;
        Mon, 20 May 2019 12:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355106;
        bh=6RLYkUuvGgMflWixEZkW796FKXNDlG8rxgC9dmlFQsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SP8nQ3uhsMx1rTD/zjNt5Yy5h8U6G4jRYmc886oas5QgiJkmsNmqSj0rjwsQBmAmr
         WXhLr2PriIhc2lmElj9mSE44f66v7SaE/gAzciidTJmMdPWzhj/qSAoEU1IQNFN8YG
         ooIeiBUcRKCkTOEKlmYETx/ccCbl8rkD7haa7mM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Kees Cook <keescook@chromium.org>,
        Guenter Roeck <groeck@chromium.org>
Subject: [PATCH 4.19 100/105] pstore: Allocate compression during late_initcall()
Date:   Mon, 20 May 2019 14:14:46 +0200
Message-Id: <20190520115254.135611751@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Fernandes (Google) <joel@joelfernandes.org>

commit 416031653eb55f844e3547fb8f8576399a800da0 upstream.

ramoops's call of pstore_register() was recently moved to run during
late_initcall() because the crypto backend may not have been ready during
postcore_initcall(). This meant early-boot crash dumps were not getting
caught by pstore any more.

Instead, lets allow calls to pstore_register() earlier, and once crypto
is ready we can initialize the compression.

Reported-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Tested-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Fixes: cb3bee0369bc ("pstore: Use crypto compress API")
[kees: trivial rebase]
Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/pstore/platform.c |   10 +++++++++-
 fs/pstore/ram.c      |    2 +-
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -786,13 +786,21 @@ static int __init pstore_init(void)
 
 	pstore_choose_compression();
 
+	/*
+	 * Check if any pstore backends registered earlier but did not
+	 * initialize compression because crypto was not ready. If so,
+	 * initialize compression now.
+	 */
+	if (psinfo && !tfm)
+		allocate_buf_for_compression();
+
 	ret = pstore_init_fs();
 	if (ret)
 		return ret;
 
 	return 0;
 }
-module_init(pstore_init)
+late_initcall(pstore_init);
 
 static void __exit pstore_exit(void)
 {
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -956,7 +956,7 @@ static int __init ramoops_init(void)
 
 	return ret;
 }
-late_initcall(ramoops_init);
+postcore_initcall(ramoops_init);
 
 static void __exit ramoops_exit(void)
 {


