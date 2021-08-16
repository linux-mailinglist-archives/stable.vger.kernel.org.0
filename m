Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84BBD3ED48F
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236425AbhHPNEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:04:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236427AbhHPNED (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:04:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCD9B632AB;
        Mon, 16 Aug 2021 13:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119012;
        bh=KiUG4rsHow+0PFikHCyH1/xyjo/m+2DX3my7nks4ITg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NxEtS20Bwrb36be7WKHxO59IC/U/k5uK8anS8W1ezn/MKPC9jH/mW0EFRO2mn2hlJ
         rm5Vv0lIQqQk69PLh6Bn1e4456EKnJsxRHO6uwNCOMKpi9Mnfz25iOY6oO6tVci0Ql
         QncQKqindDcOJS89dya1TQt8+QFMg2+r30zEeSf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.4 06/62] i2c: dev: zero out array used for i2c reads from userspace
Date:   Mon, 16 Aug 2021 15:01:38 +0200
Message-Id: <20210816125428.416806739@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125428.198692661@linuxfoundation.org>
References: <20210816125428.198692661@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 86ff25ed6cd8240d18df58930bd8848b19fce308 upstream.

If an i2c driver happens to not provide the full amount of data that a
user asks for, it is possible that some uninitialized data could be sent
to userspace.  While all in-kernel drivers look to be safe, just be sure
by initializing the buffer to zero before it is passed to the i2c driver
so that any future drivers will not have this issue.

Also properly copy the amount of data recvieved to the userspace buffer,
as pointed out by Dan Carpenter.

Reported-by: Eric Dumazet <edumazet@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-dev.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -141,7 +141,7 @@ static ssize_t i2cdev_read(struct file *
 	if (count > 8192)
 		count = 8192;
 
-	tmp = kmalloc(count, GFP_KERNEL);
+	tmp = kzalloc(count, GFP_KERNEL);
 	if (tmp == NULL)
 		return -ENOMEM;
 
@@ -150,7 +150,8 @@ static ssize_t i2cdev_read(struct file *
 
 	ret = i2c_master_recv(client, tmp, count);
 	if (ret >= 0)
-		ret = copy_to_user(buf, tmp, count) ? -EFAULT : ret;
+		if (copy_to_user(buf, tmp, ret))
+			ret = -EFAULT;
 	kfree(tmp);
 	return ret;
 }


