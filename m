Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F227776A39
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387651AbfGZNlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387646AbfGZNlT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:41:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 089D42238C;
        Fri, 26 Jul 2019 13:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148478;
        bh=ptKtaveQ3yKe3/5Pc3//7p3ISJd2LGyZwvCXaM6HbKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zwC4t6O+PZ9OnS+AAwEXSUlDhoUZK6U+s7nWQ/xN65cC3HnFMS7sZtY0lOeW42w0g
         vSSn0t93SfOkP8+Z+P3IDgt3gll2UgVXKbB0YP24+mSF7GXM5HYa6y1Tks/hIIpMoR
         ZssEwse12d7Vl3lMBdtkUNmPbB0e5cFD4ssqVvKU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhouyang Jia <jiazhouyang09@gmail.com>,
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
        Sasha Levin <sashal@kernel.org>, codalist@coda.cs.cmu.edu
Subject: [PATCH AUTOSEL 5.2 60/85] coda: add error handling for fget
Date:   Fri, 26 Jul 2019 09:39:10 -0400
Message-Id: <20190726133936.11177-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhouyang Jia <jiazhouyang09@gmail.com>

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
index 0ceef32e6fae..241f7e04ad04 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -182,8 +182,11 @@ static ssize_t coda_psdev_write(struct file *file, const char __user *buf,
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

