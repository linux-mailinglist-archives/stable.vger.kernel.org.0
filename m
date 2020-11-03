Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D742A580D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731372AbgKCVrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:47:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730995AbgKCUux (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:50:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E97F722409;
        Tue,  3 Nov 2020 20:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436653;
        bh=sV/Yv3u/CgRzUxZRXdXgLhLtMxiN2mSsEmZZMiXjVao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2UE+hFVU3wur7fhKmphdV94B0HqRbS+3mlMTn7YA8JOJMPASyQzX0lpcqO+v+NFul
         JVOS6OPvDxVqKTtVQ5nryl9bMD1XS4y4CS+3m3iqh/8NR75smFC/YDBFDeRkOuBoyv
         7903D4pEn/qsO++604PmdS7+o2zsOU7fxAPPOQN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.9 306/391] ubifs: Fix a memleak after dumping authentication mount options
Date:   Tue,  3 Nov 2020 21:35:57 +0100
Message-Id: <20201103203407.748227315@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
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
@@ -1141,6 +1141,18 @@ static int ubifs_parse_options(struct ub
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
@@ -1650,8 +1662,7 @@ static void ubifs_umount(struct ubifs_in
 	ubifs_lpt_free(c, 0);
 	ubifs_exit_authentication(c);
 
-	kfree(c->auth_key_name);
-	kfree(c->auth_hash_name);
+	ubifs_release_options(c);
 	kfree(c->cbuf);
 	kfree(c->rcvrd_mst_node);
 	kfree(c->mst_node);
@@ -2219,6 +2230,7 @@ out_umount:
 out_unlock:
 	mutex_unlock(&c->umount_mutex);
 out_close:
+	ubifs_release_options(c);
 	ubi_close_volume(c->ubi);
 out:
 	return err;


