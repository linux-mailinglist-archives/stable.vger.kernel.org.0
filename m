Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01E128B63E
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbgJLNcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730157AbgJLNcL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:32:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2D6720878;
        Mon, 12 Oct 2020 13:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509530;
        bh=fUO2QKNsziJ1Qr/+PrPwFO45/cSqjWJbF/1xruF7Z78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NmTz5fgl+BCrc2ZtsF4aUwHoRNy0rbIiLacwTLUPhWx65qE+4r8vFwCXQjfNNY/Tw
         pr6+RMA2n0skWBrBK1etyCUvqszCjcXjTrWLdeikmHInCCxsE/2x8e99wuPUHeOSLa
         dNx52CriyvMCKBtqwuLKLNVQMtKSLbmes/lvraM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.4 15/39] ep_create_wakeup_source(): dentry name can change under you...
Date:   Mon, 12 Oct 2020 15:26:45 +0200
Message-Id: <20201012132628.857082482@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132628.130632267@linuxfoundation.org>
References: <20201012132628.130632267@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 3701cb59d892b88d569427586f01491552f377b1 upstream.

or get freed, for that matter, if it's a long (separately stored)
name.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/eventpoll.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1232,7 +1232,7 @@ static int reverse_path_check(void)
 
 static int ep_create_wakeup_source(struct epitem *epi)
 {
-	const char *name;
+	struct name_snapshot n;
 	struct wakeup_source *ws;
 
 	if (!epi->ep->ws) {
@@ -1241,8 +1241,9 @@ static int ep_create_wakeup_source(struc
 			return -ENOMEM;
 	}
 
-	name = epi->ffd.file->f_path.dentry->d_name.name;
-	ws = wakeup_source_register(name);
+	take_dentry_name_snapshot(&n, epi->ffd.file->f_path.dentry);
+	ws = wakeup_source_register(n.name);
+	release_dentry_name_snapshot(&n);
 
 	if (!ws)
 		return -ENOMEM;


