Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACF95F27B
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 07:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfGDFzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 01:55:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbfGDFzW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jul 2019 01:55:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3929221882;
        Thu,  4 Jul 2019 05:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562219721;
        bh=2htda0EGf+huXRNyQdxAYDyZqCZUGN2uy6IYRSktq5g=;
        h=Subject:To:From:Date:From;
        b=OSAnQfELK7e4tMPjzVCv0KvMwcUkfaPHp02yakDrEH+VzBuWbwCcf2el0etfX5FKU
         YtYaU5dlrpg2HbQHJ/Kveh42BTEfq561UM59kYi5c0zMm9/I9IarhW2SeAsE1NIT2B
         mz7e187bTXQe1lERJtRP4K3kYRL5zUc6eYg5NSYw=
Subject: patch "coresight: Potential uninitialized variable in probe()" added to char-misc-next
To:     dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        mathieu.poirier@linaro.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 04 Jul 2019 07:52:20 +0200
Message-ID: <156221954015369@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    coresight: Potential uninitialized variable in probe()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 0530ef6b41e80c5cc979e0e50682302161edb6b7 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 20 Jun 2019 16:12:37 -0600
Subject: coresight: Potential uninitialized variable in probe()

The "drvdata->atclk" clock is optional, but if it gets set to an error
pointer then we're accidentally return an uninitialized variable instead
of success.

Fixes: 78e6427b4e7b ("coresight: funnel: Support static funnel")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190620221237.3536-6-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/coresight/coresight-funnel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwtracing/coresight/coresight-funnel.c b/drivers/hwtracing/coresight/coresight-funnel.c
index 5867fcb4503b..fa97cb9ab4f9 100644
--- a/drivers/hwtracing/coresight/coresight-funnel.c
+++ b/drivers/hwtracing/coresight/coresight-funnel.c
@@ -244,6 +244,7 @@ static int funnel_probe(struct device *dev, struct resource *res)
 	}
 
 	pm_runtime_put(dev);
+	ret = 0;
 
 out_disable_clk:
 	if (ret && !IS_ERR_OR_NULL(drvdata->atclk))
-- 
2.22.0


