Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4AE12A588C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730048AbgKCUqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:46:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:35362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731164AbgKCUqN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:46:13 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9F1122404;
        Tue,  3 Nov 2020 20:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436373;
        bh=npeycUYnJbqY8UGJ9xukoSNEpWRYml6uA0DH6nGrIMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rtMImW8rQ37AweqQ8XzavskERDSPV+/m2IB16VSGkY4ls+Z9ovy/iD4o958a73KdT
         bxvdA+6zoOpuedKzg3+2EUZ6EomXclYyEC/7YUM/tQbkKkxttiWY3RBl5vBUVVEyT8
         /un2aWQDAnm3dXZwaXHK54eSUQRAZI+70RwMs39M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.9 184/391] md: fix the checking of wrong work queue
Date:   Tue,  3 Nov 2020 21:33:55 +0100
Message-Id: <20201103203359.299471245@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

commit cf0b9b4821a2955f8a23813ef8f422208ced9bd7 upstream.

It should check md_rdev_misc_wq instead of md_misc_wq.

Fixes: cc1ffe61c026 ("md: add new workqueue for delete rdev")
Cc: <stable@vger.kernel.org> # v5.8+
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9545,7 +9545,7 @@ static int __init md_init(void)
 		goto err_misc_wq;
 
 	md_rdev_misc_wq = alloc_workqueue("md_rdev_misc", 0, 0);
-	if (!md_misc_wq)
+	if (!md_rdev_misc_wq)
 		goto err_rdev_misc_wq;
 
 	if ((ret = register_blkdev(MD_MAJOR, "md")) < 0)


