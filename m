Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59DBF634256
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 18:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbiKVRT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 12:19:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbiKVRT2 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 22 Nov 2022 12:19:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D771F6E576
        for <Stable@vger.kernel.org>; Tue, 22 Nov 2022 09:19:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63248B81CF4
        for <Stable@vger.kernel.org>; Tue, 22 Nov 2022 17:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D5DC433D6;
        Tue, 22 Nov 2022 17:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669137565;
        bh=7dN7/JhuOsWBlXjpotfRn9d9qDrjy7SAhB32ZztK0Hk=;
        h=Subject:To:From:Date:From;
        b=iqOyGzKa7olM4x36vpoozpdfjRWPdvk7F4LMjFxNAUW7GlhVynxwAd4Bkzlj8++v/
         iYHu0dC8RMLO8Xu7U+Av97UOMRkAk4lK1AsFN3n09v91kzz9UwKVLM3KHqO9+MYdip
         WxVTWqqRADFiBHKyhOaLxOk090BtF0vYARAITGVs=
Subject: patch "iio: core: Fix entry not deleted when iio_register_sw_trigger_type()" added to char-misc-linus
To:     chenzhongjin@huawei.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 22 Nov 2022 18:19:06 +0100
Message-ID: <1669137546200128@kroah.com>
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
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

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


