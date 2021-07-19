Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7EF3CDC9D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244783AbhGSOxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:53:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237760AbhGSOoY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:44:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AE9261289;
        Mon, 19 Jul 2021 15:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708160;
        bh=gxhcqkHoM/1Y1HETiG7A29+Ysk5Z7gPNT4XZ4ymtUBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8yptGg2tTZOGBSiENMFQuzt4cCMIn1tTwZt2OlWnOD2VtSxsTJfDnwd0A6tAx4Dn
         s1Z7La7aisHqonTTsVX0MOOW6AEodiaIzHztUEoQMlWwqj58dF1mlbiYA0tkm2WurH
         UR9N2lmFYWA7oe9BrMv9Dzh4ua7svs0elecyskGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anatoly Trosinenko <anatoly.trosinenko@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.14 204/315] fuse: reject internal errno
Date:   Mon, 19 Jul 2021 16:51:33 +0200
Message-Id: <20210719144950.137738648@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 49221cf86d18bb66fe95d3338cb33bd4b9880ca5 upstream.

Don't allow userspace to report errors that could be kernel-internal.

Reported-by: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
Fixes: 334f485df85a ("[PATCH] FUSE - device functions")
Cc: <stable@vger.kernel.org> # v2.6.14
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1889,7 +1889,7 @@ static ssize_t fuse_dev_do_write(struct
 	}
 
 	err = -EINVAL;
-	if (oh.error <= -1000 || oh.error > 0)
+	if (oh.error <= -512 || oh.error > 0)
 		goto err_finish;
 
 	spin_lock(&fpq->lock);


