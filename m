Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A624639B4A
	for <lists+stable@lfdr.de>; Sun, 27 Nov 2022 15:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiK0ON3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Nov 2022 09:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiK0ON2 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 27 Nov 2022 09:13:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787A02ADC
        for <Stable@vger.kernel.org>; Sun, 27 Nov 2022 06:13:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CBFA60C98
        for <Stable@vger.kernel.org>; Sun, 27 Nov 2022 14:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DD9C433C1;
        Sun, 27 Nov 2022 14:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669558406;
        bh=iZDUetSboenmHN8EXzJcOwFRO1bmPLQEOpTGrt4BshY=;
        h=Subject:To:From:Date:From;
        b=tgRGaa022NA0sjcRy7f5mzMy74Ls3siyn09N66Kuj6kI6NNykY6gYTl+iwSAS+af+
         xzTb3lMFgMpJsFNug7U1fv5J0feJY4MG/5el+W4K6e/ajeYBuCpBRGfPDOIWxx/RoO
         Rbue8E4SLeB22Vtf7ubERrOc5/DMJhqPtsvFqQcs=
Subject: patch "iio: core: Fix entry not deleted when iio_register_sw_trigger_type()" added to char-misc-next
To:     chenzhongjin@huawei.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Nov 2022 15:06:10 +0100
Message-ID: <16695579701983@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: core: Fix entry not deleted when iio_register_sw_trigger_type()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 4ad09d956f8eacff61e67e5b13ba8ebec3232f76 Mon Sep 17 00:00:00 2001
From: Chen Zhongjin <chenzhongjin@huawei.com>
Date: Tue, 8 Nov 2022 11:28:02 +0800
Subject: iio: core: Fix entry not deleted when iio_register_sw_trigger_type()
 fails

In iio_register_sw_trigger_type(), configfs_register_default_group() is
possible to fail, but the entry add to iio_trigger_types_list is not
deleted.

This leaves wild in iio_trigger_types_list, which can cause page fault
when module is loading again. So fix this by list_del(&t->list) in error
path.

BUG: unable to handle page fault for address: fffffbfff81d7400
Call Trace:
<TASK>
 iio_register_sw_trigger_type
 do_one_initcall
 do_init_module
 load_module
 ...

Fixes: b662f809d410 ("iio: core: Introduce IIO software triggers")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Link: https://lore.kernel.org/r/20221108032802.168623-1-chenzhongjin@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/industrialio-sw-trigger.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/industrialio-sw-trigger.c b/drivers/iio/industrialio-sw-trigger.c
index 994f03a71520..d86a3305d9e8 100644
--- a/drivers/iio/industrialio-sw-trigger.c
+++ b/drivers/iio/industrialio-sw-trigger.c
@@ -58,8 +58,12 @@ int iio_register_sw_trigger_type(struct iio_sw_trigger_type *t)
 
 	t->group = configfs_register_default_group(iio_triggers_group, t->name,
 						&iio_trigger_type_group_type);
-	if (IS_ERR(t->group))
+	if (IS_ERR(t->group)) {
+		mutex_lock(&iio_trigger_types_lock);
+		list_del(&t->list);
+		mutex_unlock(&iio_trigger_types_lock);
 		ret = PTR_ERR(t->group);
+	}
 
 	return ret;
 }
-- 
2.38.1


