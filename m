Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5281A639B44
	for <lists+stable@lfdr.de>; Sun, 27 Nov 2022 15:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiK0OND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Nov 2022 09:13:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiK0ONB (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 27 Nov 2022 09:13:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43D02AFD
        for <Stable@vger.kernel.org>; Sun, 27 Nov 2022 06:13:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58F3FB80AF9
        for <Stable@vger.kernel.org>; Sun, 27 Nov 2022 14:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D384C43470;
        Sun, 27 Nov 2022 14:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669558378;
        bh=JSlAcCodbT8dlGPFbZ9eWAbhIvR4Kbto6RSlR26r0Jg=;
        h=Subject:To:From:Date:From;
        b=YaGz2W2Nt0Kqg/oNTrVqxpC5XfxHOkLcHDIcNnYPBuIPDUI9H5ytwbcKFrFIaGTRD
         vanNzhhBOxGSWWl1wGRQmPmohC2p5f/DaJbD7L3re7cHMtww+pvLNI7/Fbn3xyDDwp
         vZHoeXlahRdjDbR418TgSw/OsiASDy+UrxTWd2Og=
Subject: patch "iio: core: Fix entry not deleted when iio_register_sw_trigger_type()" added to char-misc-testing
To:     chenzhongjin@huawei.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Nov 2022 15:05:54 +0100
Message-ID: <1669557954110143@kroah.com>
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
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

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


