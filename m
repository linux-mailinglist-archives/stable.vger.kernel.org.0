Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4A7168E11
	for <lists+stable@lfdr.de>; Sat, 22 Feb 2020 10:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgBVJsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 04:48:07 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:41304 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726689AbgBVJsG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Feb 2020 04:48:06 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3BFBC96D7D7CF1D8649E;
        Sat, 22 Feb 2020 17:48:04 +0800 (CST)
Received: from localhost.localdomain (10.175.124.28) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Sat, 22 Feb 2020 17:47:56 +0800
From:   yangerkun <yangerkun@huawei.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <yangerkun@huawei.com>
Subject: [PATCH 4.4-stable] slip: stop double free sl->dev in slip_open
Date:   Sat, 22 Feb 2020 17:46:49 +0800
Message-ID: <20200222094649.10933-1-yangerkun@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After commit e4c157955483 ("slip: Fix use-after-free Read in slip_open"),
we will double free sl->dev since sl_free_netdev will free sl->dev too.
It's fine for mainline since sl_free_netdev in mainline won't free
sl->dev.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 drivers/net/slip/slip.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index ef6b25ec75a1..7fe9183fad0e 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -861,7 +861,6 @@ err_free_chan:
 	tty->disc_data = NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
 	sl_free_netdev(sl->dev);
-	free_netdev(sl->dev);
 
 err_exit:
 	rtnl_unlock();
-- 
2.17.2

