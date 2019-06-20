Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 074B14D8BD
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbfFTSD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:03:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727626AbfFTSDZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:03:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A574204FD;
        Thu, 20 Jun 2019 18:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053804;
        bh=1H2OOZ5xJRq9mj4X0Y/7+7y3oHkhm0n8Pn1EyciXXso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bm8xLgsDBWlH9XiZUlIjy/oteyA6Bv2lMwvsuYHtJaAi2+HIJyjlwLaeUYkszYEZf
         7CFrUoJvUAjDz8hqCIbx+qEKJCXXiUvXFpdKt7psqLMBed07p498fw7hE8A/HZDdYc
         xilu//9mxtMWzp/YHppgmsH0Bj50x1bvRlCpF1Jw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 032/117] nfsd: allow fh_want_write to be called twice
Date:   Thu, 20 Jun 2019 19:56:06 +0200
Message-Id: <20190620174353.921173617@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
References: <20190620174351.964339809@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0b8f62625dc309651d0efcb6a6247c933acd8b45 ]

A fuzzer recently triggered lockdep warnings about potential sb_writers
deadlocks caused by fh_want_write().

Looks like we aren't careful to pair each fh_want_write() with an
fh_drop_write().

It's not normally a problem since fh_put() will call fh_drop_write() for
us.  And was OK for NFSv3 where we'd do one operation that might call
fh_want_write(), and then put the filehandle.

But an NFSv4 protocol fuzzer can do weird things like call unlink twice
in a compound, and then we get into trouble.

I'm a little worried about this approach of just leaving everything to
fh_put().  But I think there are probably a lot of
fh_want_write()/fh_drop_write() imbalances so for now I think we need it
to be more forgiving.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index 0bf9e7bf5800..9140b9cf3870 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -116,8 +116,11 @@ void		nfsd_put_raparams(struct file *file, struct raparms *ra);
 
 static inline int fh_want_write(struct svc_fh *fh)
 {
-	int ret = mnt_want_write(fh->fh_export->ex_path.mnt);
+	int ret;
 
+	if (fh->fh_want_write)
+		return 0;
+	ret = mnt_want_write(fh->fh_export->ex_path.mnt);
 	if (!ret)
 		fh->fh_want_write = true;
 	return ret;
-- 
2.20.1



