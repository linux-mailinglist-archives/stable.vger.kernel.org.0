Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189DD29008B
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405342AbgJPJG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:06:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405337AbgJPJG5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:06:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3043720848;
        Fri, 16 Oct 2020 09:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839216;
        bh=uPl725diAniH+EKCxObvvKRteIJ0bNRguYi2KdV3+vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rNslfnaAZWrylxGet0vK7st6MvQVpmrMyR7XJN2VUJdzGPc6MaWWJ/eC5777XbQpI
         0zeUgtEn2aU/g1KwVzo+lY1iRk0Q+vXzQdhM+BDVECZZvaYZLEGT7qiVGzFsOBZ11r
         jrxAnSLqm02rv3LfHhULjJoZOxPiRYdj4zoUH23g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yangerkun <yangerkun@huawei.com>
Subject: [PATCH 4.4 15/16] spi: unbinding slave before calling spi_destroy_queue
Date:   Fri, 16 Oct 2020 11:07:08 +0200
Message-Id: <20201016090436.166047102@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090435.423923738@linuxfoundation.org>
References: <20201016090435.423923738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

We make a mistake while backport 'commit 84855678add8 ("spi: Fix
controller unregister order")'. What we should do is call __unreigster
for each device before spi_destroy_queue. This problem exist in
linux-4.4.y/linux-4.9.y.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 drivers/spi/spi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1917,13 +1917,13 @@ static int __unregister(struct device *d
  */
 void spi_unregister_master(struct spi_master *master)
 {
+	device_for_each_child(&master->dev, NULL, __unregister);
+
 	if (master->queued) {
 		if (spi_destroy_queue(master))
 			dev_err(&master->dev, "queue remove failed\n");
 	}
 
-	device_for_each_child(&master->dev, NULL, __unregister);
-
 	mutex_lock(&board_lock);
 	list_del(&master->list);
 	mutex_unlock(&board_lock);


