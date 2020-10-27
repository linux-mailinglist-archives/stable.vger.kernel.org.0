Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A696E29AC02
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 13:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440918AbgJ0MYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 08:24:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436636AbgJ0MYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 08:24:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86A7522447;
        Tue, 27 Oct 2020 12:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603801449;
        bh=YGG2AZkSpAcEmpTHGJ8bG7WWHjyC/E3o+pr+1dHnM/k=;
        h=Subject:To:From:Date:From;
        b=qiJG02b0OczfPbYSD92Po2tlmDHe4GIryfZEZ25/pMQ/jfv4zqpaGKyN88xnaqrqc
         5x8C5CAEvVcmZRt2p5iPnWUnHRVrQ9WGhKwMNCyffHqFIANZ7n4kE88xNTs/O/bjiN
         GbX+t/sj+GypTbaAVZHbCZWrKvMDqhQN/POHR9pU=
Subject: patch "staging: fieldbus: anybuss: jump to correct label in an error path" added to staging-linus
To:     jingxiangfeng@huawei.com, TheSven73@gmail.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 27 Oct 2020 13:25:04 +0100
Message-ID: <1603801504178119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: fieldbus: anybuss: jump to correct label in an error path

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7e97e4cbf30026b49b0145c3bfe06087958382c5 Mon Sep 17 00:00:00 2001
From: Jing Xiangfeng <jingxiangfeng@huawei.com>
Date: Mon, 12 Oct 2020 21:24:04 +0800
Subject: staging: fieldbus: anybuss: jump to correct label in an error path

In current code, controller_probe() misses to call ida_simple_remove()
in an error path. Jump to correct label to fix it.

Fixes: 17614978ed34 ("staging: fieldbus: anybus-s: support the Arcx anybus controller")
Reviewed-by: Sven Van Asbroeck <TheSven73@gmail.com>
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201012132404.113031-1-jingxiangfeng@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/fieldbus/anybuss/arcx-anybus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/fieldbus/anybuss/arcx-anybus.c b/drivers/staging/fieldbus/anybuss/arcx-anybus.c
index 5b8d0bae9ff3..b5fded15e8a6 100644
--- a/drivers/staging/fieldbus/anybuss/arcx-anybus.c
+++ b/drivers/staging/fieldbus/anybuss/arcx-anybus.c
@@ -293,7 +293,7 @@ static int controller_probe(struct platform_device *pdev)
 	regulator = devm_regulator_register(dev, &can_power_desc, &config);
 	if (IS_ERR(regulator)) {
 		err = PTR_ERR(regulator);
-		goto out_reset;
+		goto out_ida;
 	}
 	/* make controller info visible to userspace */
 	cd->class_dev = kzalloc(sizeof(*cd->class_dev), GFP_KERNEL);
-- 
2.29.1


