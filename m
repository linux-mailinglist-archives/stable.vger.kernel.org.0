Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8392239136
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730652AbfFGPmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:42:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730648AbfFGPmp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:42:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA83C214AF;
        Fri,  7 Jun 2019 15:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922164;
        bh=e2KFDJLz9Lsataaan3BzvauG6mpgnuRbx5NYfA9C6yU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e9Bf0kvCZnJe9P+77jhg1+y6O6VcUhjH5Dg9gILyHxj+uuiyVrMaxddTPUn5Lw06v
         KTsr/DmxLfwAfStkHH0Iape8+rSDdDjJ81Zr007TadHDQVGH6MMnBZ+uBXR6ZIrbqH
         V0ssVhH/EK2YmkCx70rxeyXlgdxFTCVqXc8uaB+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Coddington <bcodding@redhat.com>,
        XueWei Zhang <xueweiz@google.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 4.14 60/69] Revert "lockd: Show pid of lockd for remote locks"
Date:   Fri,  7 Jun 2019 17:39:41 +0200
Message-Id: <20190607153855.452656175@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.271562617@linuxfoundation.org>
References: <20190607153848.271562617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Coddington <bcodding@redhat.com>

commit 141731d15d6eb2fd9aaefbf9b935ce86ae243074 upstream.

This reverts most of commit b8eee0e90f97 ("lockd: Show pid of lockd for
remote locks"), which caused remote locks to not be differentiated between
remote processes for NLM.

We retain the fixup for setting the client's fl_pid to a negative value.

Fixes: b8eee0e90f97 ("lockd: Show pid of lockd for remote locks")
Cc: stable@vger.kernel.org

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: XueWei Zhang <xueweiz@google.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/lockd/xdr.c  |    4 ++--
 fs/lockd/xdr4.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/fs/lockd/xdr.c
+++ b/fs/lockd/xdr.c
@@ -127,7 +127,7 @@ nlm_decode_lock(__be32 *p, struct nlm_lo
 
 	locks_init_lock(fl);
 	fl->fl_owner = current->files;
-	fl->fl_pid   = current->tgid;
+	fl->fl_pid   = (pid_t)lock->svid;
 	fl->fl_flags = FL_POSIX;
 	fl->fl_type  = F_RDLCK;		/* as good as anything else */
 	start = ntohl(*p++);
@@ -269,7 +269,7 @@ nlmsvc_decode_shareargs(struct svc_rqst
 	memset(lock, 0, sizeof(*lock));
 	locks_init_lock(&lock->fl);
 	lock->svid = ~(u32) 0;
-	lock->fl.fl_pid = current->tgid;
+	lock->fl.fl_pid = (pid_t)lock->svid;
 
 	if (!(p = nlm_decode_cookie(p, &argp->cookie))
 	 || !(p = xdr_decode_string_inplace(p, &lock->caller,
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -119,7 +119,7 @@ nlm4_decode_lock(__be32 *p, struct nlm_l
 
 	locks_init_lock(fl);
 	fl->fl_owner = current->files;
-	fl->fl_pid   = current->tgid;
+	fl->fl_pid   = (pid_t)lock->svid;
 	fl->fl_flags = FL_POSIX;
 	fl->fl_type  = F_RDLCK;		/* as good as anything else */
 	p = xdr_decode_hyper(p, &start);
@@ -266,7 +266,7 @@ nlm4svc_decode_shareargs(struct svc_rqst
 	memset(lock, 0, sizeof(*lock));
 	locks_init_lock(&lock->fl);
 	lock->svid = ~(u32) 0;
-	lock->fl.fl_pid = current->tgid;
+	lock->fl.fl_pid = (pid_t)lock->svid;
 
 	if (!(p = nlm4_decode_cookie(p, &argp->cookie))
 	 || !(p = xdr_decode_string_inplace(p, &lock->caller,


