Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 195A2111C80
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbfLCWoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:44:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:60938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727956AbfLCWop (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:44:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 003B52073C;
        Tue,  3 Dec 2019 22:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413084;
        bh=LtANjkoHYToz+uzM+RsYoOHUKZFGyX8k2IRCUe6MGLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0MGtiVpL2xxFjgVCgNLsxYZn7KP9fHahn/pQg1kx+8UPMKmuJR//H2xWwv7vqVcV6
         lQ4aC2blGMDnMH7Ohw/ytRwd432TmkJJp89kuK0hpQy7ZOp8ffJnnyxmrLEmroPvHk
         iQ2vwrSjHUih28DFjotXWiux86luMBo5O4qzaQaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 088/135] ceph: return -EINVAL if given fsc mount option on kernel w/o support
Date:   Tue,  3 Dec 2019 23:35:28 +0100
Message-Id: <20191203213035.327225900@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
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
index ab4868c7308ec..b565c55ed0648 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -255,6 +255,7 @@ static int parse_fsopt_token(char *c, void *private)
 			return -ENOMEM;
 		break;
 	case Opt_fscache_uniq:
+#ifdef CONFIG_CEPH_FSCACHE
 		kfree(fsopt->fscache_uniq);
 		fsopt->fscache_uniq = kstrndup(argstr[0].from,
 					       argstr[0].to-argstr[0].from,
@@ -263,7 +264,10 @@ static int parse_fsopt_token(char *c, void *private)
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
@@ -340,10 +344,15 @@ static int parse_fsopt_token(char *c, void *private)
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



