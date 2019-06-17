Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F20E549251
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbfFQVTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:19:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728555AbfFQVTB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:19:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 989DB2089E;
        Mon, 17 Jun 2019 21:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806340;
        bh=rlODXlwcieK5G7VrkLfAk+yjUpoAtfbVZYrEhVic2EM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zR+nEQGZcTahb1sTi5GspU9xExELuYRUO7QdKq04UP6fEfD5f8YfszsBrgwUh22tN
         s8qBVn22cKLylOiKHlFmOQ4vpHC6SAIjfkpTYZ1fgzQKvgf7wp5Fl0ty27GFIhvbUG
         RFCxJkLXcBbnjEtWbTr4YEMeJFyFEguTLK7rnPPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gen Zhang <blackgod016574@gmail.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.1 019/115] selinux: fix a missing-check bug in selinux_sb_eat_lsm_opts()
Date:   Mon, 17 Jun 2019 23:08:39 +0200
Message-Id: <20190617210800.895511185@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gen Zhang <blackgod016574@gmail.com>

commit fec6375320c6399c708fa9801f8cfbf950fee623 upstream.

In selinux_sb_eat_lsm_opts(), 'arg' is allocated by kmemdup_nul(). It
returns NULL when fails. So 'arg' should be checked. And 'mnt_opts'
should be freed when error.

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
Fixes: 99dbbb593fe6 ("selinux: rewrite selinux_sb_eat_lsm_opts()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/selinux/hooks.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2612,10 +2612,11 @@ static int selinux_sb_eat_lsm_opts(char
 	char *from = options;
 	char *to = options;
 	bool first = true;
+	int rc;
 
 	while (1) {
 		int len = opt_len(from);
-		int token, rc;
+		int token;
 		char *arg = NULL;
 
 		token = match_opt_prefix(from, len, &arg);
@@ -2631,15 +2632,15 @@ static int selinux_sb_eat_lsm_opts(char
 						*q++ = c;
 				}
 				arg = kmemdup_nul(arg, q - arg, GFP_KERNEL);
+				if (!arg) {
+					rc = -ENOMEM;
+					goto free_opt;
+				}
 			}
 			rc = selinux_add_opt(token, arg, mnt_opts);
 			if (unlikely(rc)) {
 				kfree(arg);
-				if (*mnt_opts) {
-					selinux_free_mnt_opts(*mnt_opts);
-					*mnt_opts = NULL;
-				}
-				return rc;
+				goto free_opt;
 			}
 		} else {
 			if (!first) {	// copy with preceding comma
@@ -2657,6 +2658,13 @@ static int selinux_sb_eat_lsm_opts(char
 	}
 	*to = '\0';
 	return 0;
+
+free_opt:
+	if (*mnt_opts) {
+		selinux_free_mnt_opts(*mnt_opts);
+		*mnt_opts = NULL;
+	}
+	return rc;
 }
 
 static int selinux_sb_remount(struct super_block *sb, void *mnt_opts)


