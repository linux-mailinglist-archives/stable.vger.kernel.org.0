Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF6081B36
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730168AbfHENMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730274AbfHENJ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:09:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E98432087B;
        Mon,  5 Aug 2019 13:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010595;
        bh=2VID9je89f2HovuhxPIOTTpBneUuIvmnOWdBH/NvQJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IGUOBxry90y05hO5kT0deqN48ilBaACHoyrVjiBtulAsmoqp4GRfaHP65BFErqCXe
         xwNKXNIqfxrrwqotq8Y31er03JGGrKp+oEhoosqOKUPXdvh5SY62MAVxq5uRRUpGGS
         k1NOwfi46wHf6JgrZOQ/XRLOVfJkYkSEiUJOFxFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhouyang Jia <jiazhouyang09@gmail.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>,
        Arnd Bergmann <arnd@arndb.de>,
        Colin Ian King <colin.king@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Fabian Frederick <fabf@skynet.be>,
        Mikko Rapeli <mikko.rapeli@iki.fi>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 31/74] coda: add error handling for fget
Date:   Mon,  5 Aug 2019 15:02:44 +0200
Message-Id: <20190805124938.266379089@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 02551c23bcd85f0c68a8259c7b953d49d44f86af ]

When fget fails, the lack of error-handling code may cause unexpected
results.

This patch adds error-handling code after calling fget.

Link: http://lkml.kernel.org/r/2514ec03df9c33b86e56748513267a80dd8004d9.1558117389.git.jaharkes@cs.cmu.edu
Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Yann Droneaud <ydroneaud@opteya.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/coda/psdev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index c5234c21b5394..55824cba32453 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -187,8 +187,11 @@ static ssize_t coda_psdev_write(struct file *file, const char __user *buf,
 	if (req->uc_opcode == CODA_OPEN_BY_FD) {
 		struct coda_open_by_fd_out *outp =
 			(struct coda_open_by_fd_out *)req->uc_data;
-		if (!outp->oh.result)
+		if (!outp->oh.result) {
 			outp->fh = fget(outp->fd);
+			if (!outp->fh)
+				return -EBADF;
+		}
 	}
 
         wake_up(&req->uc_sleep);
-- 
2.20.1



