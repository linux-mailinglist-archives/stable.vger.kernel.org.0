Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8DCB43FF8
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388963AbfFMQBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:01:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731408AbfFMIr6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:47:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6838D20851;
        Thu, 13 Jun 2019 08:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415677;
        bh=R+J2GFuWWAezQyQpmaUHq2znXbw+AdAzBsI4QI5nUWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FncZgWe8dEO64ykPtyfX9/0P67N14ZVXBpykWid+pGqiI+NOYkeIKrCdMGlEN3Xee
         kCoy7gsK9rQrC5/4JHkB5BgFU+toPlXKxrIcuezufYehtz4ZXagSJt5HjFRfAXMbEK
         0lqaoEmk1HQIuOrLrf0FOh2DjOgmQyj2H0geP9do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 086/155] nfsd: allow fh_want_write to be called twice
Date:   Thu, 13 Jun 2019 10:33:18 +0200
Message-Id: <20190613075657.904410856@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
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
index a7e107309f76..db351247892d 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -120,8 +120,11 @@ void		nfsd_put_raparams(struct file *file, struct raparms *ra);
 
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



