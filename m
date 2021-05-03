Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F713714D4
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbhECMBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 08:01:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233884AbhECMBF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 08:01:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1928361249;
        Mon,  3 May 2021 12:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043210;
        bh=z4jA2YSG6DY4IEYnUj3gPzy8Xzv+I2pFPoHTbThNSVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L1/WZhe1Ht+rh7cKNR+eb9m3ldvEyRW2n/kOXxbk97SUYOUcHL0dbAX7ttU3qU+Tt
         eh9fkMjDq9yl9E0lKOTs23WB28ZHtogBJF2JyX0aCnw7iSJsIuOAT/BdN7Xvj6lgQh
         GialgzMZHvKD+yhTbwMC97+J9h47W0v5/suGK/bk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>, Wenwen Wang <wenwen@cs.uga.edu>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 02/69] Revert "ACPI: custom_method: fix memory leaks"
Date:   Mon,  3 May 2021 13:56:29 +0200
Message-Id: <20210503115736.2104747-3-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

This reverts commit 03d1571d9513369c17e6848476763ebbd10ec2cb.

While /sys/kernel/debug/acpi/custom_method is already a privileged-only
API providing proxied arbitrary write access to kernel memory[1][2],
with existing race conditions[3] in buffer allocation and use that could
lead to memory leaks and use-after-free conditions, the above commit
appears to accidentally make the use-after-free conditions even easier
to accomplish. ("buf" is a global variable and prior kfree()s would set
buf back to NULL.)

This entire interface needs to be reworked (if not entirely removed).

[1] https://lore.kernel.org/lkml/20110222193250.GA23913@outflux.net/
[2] https://lore.kernel.org/lkml/201906221659.B618D83@keescook/
[3] https://lore.kernel.org/lkml/20170109231323.GA89642@beast/

Cc: Wenwen Wang <wenwen@cs.uga.edu>
Fixes: 03d1571d9513 ("ACPI: custom_method: fix memory leaks")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/custom_method.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/acpi/custom_method.c b/drivers/acpi/custom_method.c
index 443fdf62dd22..72469a49837d 100644
--- a/drivers/acpi/custom_method.c
+++ b/drivers/acpi/custom_method.c
@@ -53,10 +53,8 @@ static ssize_t cm_write(struct file *file, const char __user *user_buf,
 	if ((*ppos > max_size) ||
 	    (*ppos + count > max_size) ||
 	    (*ppos + count < count) ||
-	    (count > uncopied_bytes)) {
-		kfree(buf);
+	    (count > uncopied_bytes))
 		return -EINVAL;
-	}
 
 	if (copy_from_user(buf + (*ppos), user_buf, count)) {
 		kfree(buf);
@@ -76,7 +74,6 @@ static ssize_t cm_write(struct file *file, const char __user *user_buf,
 		add_taint(TAINT_OVERRIDDEN_ACPI_TABLE, LOCKDEP_NOW_UNRELIABLE);
 	}
 
-	kfree(buf);
 	return count;
 }
 
-- 
2.31.1

