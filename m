Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16EEB11347F
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbfLDSBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:01:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:42990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729697AbfLDSBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:01:53 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AFCA2073B;
        Wed,  4 Dec 2019 18:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482513;
        bh=mSYlVqTT4mzdDnqYvPJaPY365m8OV48o+5QmSRC5j20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfZoh3NZZaZ/pRqkp2qafVmcBFsdglJU5JTx0Oqm5bFItsZdfRiS+ZP24sEQZ38Bk
         s7Vjy/Ve35G0OkDpHdbY2T8XlmwSjd/bYqitU1dO4tFXyZY4yEM9knDgnyOYPqGyZq
         aYyCOWwpYym1mhzONIq21Hp2Ls1aa5HlWGnL2e6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 026/209] ceph: return -EINVAL if given fsc mount option on kernel w/o support
Date:   Wed,  4 Dec 2019 18:53:58 +0100
Message-Id: <20191204175323.301915647@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
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
index f0694293b31a2..088c4488b4492 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -232,6 +232,7 @@ static int parse_fsopt_token(char *c, void *private)
 			return -ENOMEM;
 		break;
 	case Opt_fscache_uniq:
+#ifdef CONFIG_CEPH_FSCACHE
 		kfree(fsopt->fscache_uniq);
 		fsopt->fscache_uniq = kstrndup(argstr[0].from,
 					       argstr[0].to-argstr[0].from,
@@ -240,7 +241,10 @@ static int parse_fsopt_token(char *c, void *private)
 			return -ENOMEM;
 		fsopt->flags |= CEPH_MOUNT_OPT_FSCACHE;
 		break;
-		/* misc */
+#else
+		pr_err("fscache support is disabled\n");
+		return -EINVAL;
+#endif
 	case Opt_wsize:
 		if (intval < PAGE_SIZE || intval > CEPH_MAX_WRITE_SIZE)
 			return -EINVAL;
@@ -312,8 +316,13 @@ static int parse_fsopt_token(char *c, void *private)
 		fsopt->flags &= ~CEPH_MOUNT_OPT_INO32;
 		break;
 	case Opt_fscache:
+#ifdef CONFIG_CEPH_FSCACHE
 		fsopt->flags |= CEPH_MOUNT_OPT_FSCACHE;
 		break;
+#else
+		pr_err("fscache support is disabled\n");
+		return -EINVAL;
+#endif
 	case Opt_nofscache:
 		fsopt->flags &= ~CEPH_MOUNT_OPT_FSCACHE;
 		break;
-- 
2.20.1



