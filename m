Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA10111F53
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbfLCWrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:47:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:37892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728595AbfLCWri (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:47:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 175292084B;
        Tue,  3 Dec 2019 22:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413257;
        bh=zXtXS6SIYCUVKVzjE4NbOS/jPXuUpGnrzSoqzj14EGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXItjUQC4STAYTAyLanNFfYXW5hJ9WPx189BVkpio67ewJWvYAOzWjeyepQYTfFvY
         r86eei9oEWzGCBJB97F1jgPg7MEdktxyaw3P/WN6v7cp8MshplVI+yliIldjvk3woq
         e9LFF9R1eIoRO3J0uvUFksyC+dH/9zGTpMOCUAlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 042/321] ceph: return -EINVAL if given fsc mount option on kernel w/o support
Date:   Tue,  3 Dec 2019 23:31:48 +0100
Message-Id: <20191203223429.300096553@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit ff29fde84d1fc82f233c7da0daa3574a3942bec7 ]

If someone requests fscache on the mount, and the kernel doesn't
support it, it should fail the mount.

[ Drop ceph prefix -- it's provided by pr_err. ]

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/super.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index ccab249a37f6a..2bd0b1ed9708e 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -248,6 +248,7 @@ static int parse_fsopt_token(char *c, void *private)
 			return -ENOMEM;
 		break;
 	case Opt_fscache_uniq:
+#ifdef CONFIG_CEPH_FSCACHE
 		kfree(fsopt->fscache_uniq);
 		fsopt->fscache_uniq = kstrndup(argstr[0].from,
 					       argstr[0].to-argstr[0].from,
@@ -256,7 +257,10 @@ static int parse_fsopt_token(char *c, void *private)
 			return -ENOMEM;
 		fsopt->flags |= CEPH_MOUNT_OPT_FSCACHE;
 		break;
-		/* misc */
+#else
+		pr_err("fscache support is disabled\n");
+		return -EINVAL;
+#endif
 	case Opt_wsize:
 		if (intval < (int)PAGE_SIZE || intval > CEPH_MAX_WRITE_SIZE)
 			return -EINVAL;
@@ -328,10 +332,15 @@ static int parse_fsopt_token(char *c, void *private)
 		fsopt->flags &= ~CEPH_MOUNT_OPT_INO32;
 		break;
 	case Opt_fscache:
+#ifdef CONFIG_CEPH_FSCACHE
 		fsopt->flags |= CEPH_MOUNT_OPT_FSCACHE;
 		kfree(fsopt->fscache_uniq);
 		fsopt->fscache_uniq = NULL;
 		break;
+#else
+		pr_err("fscache support is disabled\n");
+		return -EINVAL;
+#endif
 	case Opt_nofscache:
 		fsopt->flags &= ~CEPH_MOUNT_OPT_FSCACHE;
 		kfree(fsopt->fscache_uniq);
-- 
2.20.1



