Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30592106DC5
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731382AbfKVLDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:03:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:56816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731023AbfKVLC6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:02:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20EBF20679;
        Fri, 22 Nov 2019 11:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420577;
        bh=6tKVNmbw+qYOY0gZtKFGEPhIaxF5nM+KLL6j78blHzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0qm6lzZohESOwGoqHKTTaJOHJGlUG53JDN/w5rFzzR2iOAbKQSCBDmHRTLrakojdT
         tW9vTnYluE/lsfc/CYqLw4ft6JblfvnDHJLoBH7tpdbRdenasf802z35pH2jUkqBrH
         MyqTGKY/FbqIoEZtFEpIyCwzLfHjR3qvevG1pjL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Peter Malone <peter.malone@gmail.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Mathieu Malaterre <malat@debian.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 153/220] fbdev: sbuslib: integer overflow in sbusfb_ioctl_helper()
Date:   Fri, 22 Nov 2019 11:28:38 +0100
Message-Id: <20191122100923.730711838@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e5017716adb8aa5c01c52386c1b7470101ffe9c5 ]

The "index + count" addition can overflow.  Both come directly from the
user.  This bug leads to an information leak.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Peter Malone <peter.malone@gmail.com>
Cc: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Mathieu Malaterre <malat@debian.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sbuslib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/sbuslib.c b/drivers/video/fbdev/sbuslib.c
index 90c51330969c2..01a7110e61a76 100644
--- a/drivers/video/fbdev/sbuslib.c
+++ b/drivers/video/fbdev/sbuslib.c
@@ -171,7 +171,7 @@ int sbusfb_ioctl_helper(unsigned long cmd, unsigned long arg,
 		    get_user(ublue, &c->blue))
 			return -EFAULT;
 
-		if (index + count > cmap->len)
+		if (index > cmap->len || count > cmap->len - index)
 			return -EINVAL;
 
 		for (i = 0; i < count; i++) {
-- 
2.20.1



