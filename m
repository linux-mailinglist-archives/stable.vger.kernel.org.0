Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4A2408F32
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242520AbhIMNkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243167AbhIMNiW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:38:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AB6661263;
        Mon, 13 Sep 2021 13:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539711;
        bh=27IrT8vsW4e8GkIYRRNTNr2+Lx8YE0AXCSgSjVcfQLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sJdGbDK3hfVJ5vgL+Cb2RLdooyhDRDbNqNJUDs6sgq9ZKtWLSX5YFH7bZZlzCSiS+
         lk+8aS1QPe8sgMQkUBzEc4q4d2NdbuvioOyzUAVnXsLeDb47DDSQxMwqS3LPAGJ1eu
         A4CUc/VrZT2XiUlK1bwNyaRV9oC5mNd9Q8KvPn9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?q?M=C3=A1rio=20Lopes?= <ml@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/236] debugfs: Return error during {full/open}_proxy_open() on rmmod
Date:   Mon, 13 Sep 2021 15:13:54 +0200
Message-Id: <20210913131104.753295134@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 112cedc8e600b668688eb809bf11817adec58ddc ]

If a kernel module gets unloaded then it printed report about a leak before
commit 275678e7a9be ("debugfs: Check module state before warning in
{full/open}_proxy_open()"). An additional check was added in this commit to
avoid this printing. But it was forgotten that the function must return an
error in this case because it was not actually opened.

As result, the systems started to crash or to hang when a module was
unloaded while something was trying to open a file.

Fixes: 275678e7a9be ("debugfs: Check module state before warning in {full/open}_proxy_open()")
Cc: Taehee Yoo <ap420073@gmail.com>
Reported-by: Mário Lopes <ml@simonwunderlich.de>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Link: https://lore.kernel.org/r/20210802162444.7848-1-sven@narfation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/debugfs/file.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 686e0ad28788..3aa5eb9ce498 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -179,8 +179,10 @@ static int open_proxy_open(struct inode *inode, struct file *filp)
 	if (!fops_get(real_fops)) {
 #ifdef CONFIG_MODULES
 		if (real_fops->owner &&
-		    real_fops->owner->state == MODULE_STATE_GOING)
+		    real_fops->owner->state == MODULE_STATE_GOING) {
+			r = -ENXIO;
 			goto out;
+		}
 #endif
 
 		/* Huh? Module did not clean up after itself at exit? */
@@ -314,8 +316,10 @@ static int full_proxy_open(struct inode *inode, struct file *filp)
 	if (!fops_get(real_fops)) {
 #ifdef CONFIG_MODULES
 		if (real_fops->owner &&
-		    real_fops->owner->state == MODULE_STATE_GOING)
+		    real_fops->owner->state == MODULE_STATE_GOING) {
+			r = -ENXIO;
 			goto out;
+		}
 #endif
 
 		/* Huh? Module did not cleanup after itself at exit? */
-- 
2.30.2



