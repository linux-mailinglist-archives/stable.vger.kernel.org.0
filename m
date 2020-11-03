Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559CD2A569C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733080AbgKCU7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:59:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:34212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733088AbgKCU7O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:59:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82D6222226;
        Tue,  3 Nov 2020 20:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437154;
        bh=AEjNpfgNS/by2nCOTPsKsz2AxJQ8Kb9EBXRz7/Ycyxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VDb7oI+OwA36yBjCM+W18qcvMOTp9Wh+/dt97z44/Tl1aYJLN9x8fPWGb3qWcz013
         SzvtuBlIWkK3rZERlJf3pm98wgynzm2DTYBX8iI4fyY8r3OORVrKJ6CRlqBdK3HDu6
         P8I7ydpzKLdGtlUCyJampQ2LqvfArhUzLlewdUlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.4 170/214] ubifs: Fix a memleak after dumping authentication mount options
Date:   Tue,  3 Nov 2020 21:36:58 +0100
Message-Id: <20201103203306.692028642@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit 47f6d9ce45b03a40c34b668a9884754c58122b39 upstream.

Fix a memory leak after dumping authentication mount options in error
handling branch.

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: <stable@vger.kernel.org>  # 4.20+
Fixes: d8a22773a12c6d7 ("ubifs: Enable authentication support")
Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/super.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1123,6 +1123,18 @@ static int ubifs_parse_options(struct ub
 	return 0;
 }
 
+/*
+ * ubifs_release_options - release mount parameters which have been dumped.
+ * @c: UBIFS file-system description object
+ */
+static void ubifs_release_options(struct ubifs_info *c)
+{
+	kfree(c->auth_key_name);
+	c->auth_key_name = NULL;
+	kfree(c->auth_hash_name);
+	c->auth_hash_name = NULL;
+}
+
 /**
  * destroy_journal - destroy journal data structures.
  * @c: UBIFS file-system description object
@@ -1632,8 +1644,7 @@ static void ubifs_umount(struct ubifs_in
 	ubifs_lpt_free(c, 0);
 	ubifs_exit_authentication(c);
 
-	kfree(c->auth_key_name);
-	kfree(c->auth_hash_name);
+	ubifs_release_options(c);
 	kfree(c->cbuf);
 	kfree(c->rcvrd_mst_node);
 	kfree(c->mst_node);
@@ -2201,6 +2212,7 @@ out_umount:
 out_unlock:
 	mutex_unlock(&c->umount_mutex);
 out_close:
+	ubifs_release_options(c);
 	ubi_close_volume(c->ubi);
 out:
 	return err;


