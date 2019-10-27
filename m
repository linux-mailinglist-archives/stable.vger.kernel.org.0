Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7480E67C8
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732480AbfJ0VYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:24:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730777AbfJ0VYR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:24:17 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1931521726;
        Sun, 27 Oct 2019 21:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211456;
        bh=t69A56lr0lOMmewix5iSiPHCFZCowdC0rRu0+B5hnBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJux7bHx8bwNBX+spHP+RVrVwwr2QdOFbhszpB1oe6EW2zZ5f30IGwRuNF7xfFa+8
         63OlEWNSwIMqoHwCczXfVs/hwdJG7xXLNWzynJ2gOwevIVOclH1pt0aos3C4MBoIkr
         6pju2HGzM+R/p7dqDDmW8vJ+lelaReqRn9A1hLvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Johan Hovold <johan@kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.3 158/197] s390/zcrypt: fix memleak at release
Date:   Sun, 27 Oct 2019 22:01:16 +0100
Message-Id: <20191027203400.212151946@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 388bb19be8eab4674a660e0c97eaf60775362bc7 upstream.

If a process is interrupted while accessing the crypto device and the
global ap_perms_mutex is contented, release() could return early and
fail to free related resources.

Fixes: 00fab2350e6b ("s390/zcrypt: multiple zcrypt device nodes support")
Cc: <stable@vger.kernel.org> # 4.19
Cc: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/crypto/zcrypt_api.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -539,8 +539,7 @@ static int zcrypt_release(struct inode *
 	if (filp->f_inode->i_cdev == &zcrypt_cdev) {
 		struct zcdn_device *zcdndev;
 
-		if (mutex_lock_interruptible(&ap_perms_mutex))
-			return -ERESTARTSYS;
+		mutex_lock(&ap_perms_mutex);
 		zcdndev = find_zcdndev_by_devt(filp->f_inode->i_rdev);
 		mutex_unlock(&ap_perms_mutex);
 		if (zcdndev) {


