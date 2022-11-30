Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3B363DFE9
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbiK3Svp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbiK3Svg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:51:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6245B63D43
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:51:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFC3E61D59
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0881DC433C1;
        Wed, 30 Nov 2022 18:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834294;
        bh=nUZmhGt3oAptX1QO4ocpry3wQOSVe5Q+F1aUzH4oK2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x69IiJN2OhPJToWlMKabyTXScrk/y90O2VuJH3kXL8DBbL8yXkozR6QSZcf5cVkJS
         /G5Dtr2WRzTjLd5UXG9IODuFlCD6FBbTlfO3UmyN9Z54/ic5tIfP/8oa8Mjq5Yvg7T
         lkspkwzKqHjlsTsPnrbaXA4MjtGCFSrs5kK7aXiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.0 173/289] iio: core: Fix entry not deleted when iio_register_sw_trigger_type() fails
Date:   Wed, 30 Nov 2022 19:22:38 +0100
Message-Id: <20221130180548.052805896@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhongjin <chenzhongjin@huawei.com>

commit 4ad09d956f8eacff61e67e5b13ba8ebec3232f76 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-sw-trigger.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iio/industrialio-sw-trigger.c
+++ b/drivers/iio/industrialio-sw-trigger.c
@@ -58,8 +58,12 @@ int iio_register_sw_trigger_type(struct
 
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


