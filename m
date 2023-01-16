Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B312766C695
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbjAPQVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbjAPQVD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:21:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA5025E04
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:11:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E1A9B81059
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7D5C43392;
        Mon, 16 Jan 2023 16:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885493;
        bh=lomZ4pZK6Ek1cuGNK35hkaOAos1qguTINJQwSxAZRrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sbHzTDWVSik8FNTX0iwB+AdDfGXQY+DbT/BqJf0YXaVaptEdgFB/FYrsHDrp0zbtZ
         ZKykmBmY2k+W8zkghjy0oL4pBYqtGSmj+JkjwUwG/OFsJ6IWfC0aBcuTLtm3c3gM3v
         GBsLqDhoQU+GKerI48hWOrrnrYszEOQG6WG5ANeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Akinobu Mita <akinobu.mita@gmail.com>,
        Zhao Gongyi <zhaogongyi@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Oscar Salvador <osalvador@suse.de>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Yicong Yang <yangyicong@hisilicon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 073/658] lib/notifier-error-inject: fix error when writing -errno to debugfs file
Date:   Mon, 16 Jan 2023 16:42:41 +0100
Message-Id: <20230116154912.960156857@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Akinobu Mita <akinobu.mita@gmail.com>

[ Upstream commit f883c3edd2c432a2931ec8773c70a570115a50fe ]

The simple attribute files do not accept a negative value since the commit
488dac0c9237 ("libfs: fix error cast of negative value in
simple_attr_write()").

This restores the previous behaviour by using newly introduced
DEFINE_SIMPLE_ATTRIBUTE_SIGNED instead of DEFINE_SIMPLE_ATTRIBUTE.

Link: https://lkml.kernel.org/r/20220919172418.45257-3-akinobu.mita@gmail.com
Fixes: 488dac0c9237 ("libfs: fix error cast of negative value in simple_attr_write()")
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reported-by: Zhao Gongyi <zhaogongyi@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/notifier-error-inject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/notifier-error-inject.c b/lib/notifier-error-inject.c
index 21016b32d313..2b24ea6c9497 100644
--- a/lib/notifier-error-inject.c
+++ b/lib/notifier-error-inject.c
@@ -15,7 +15,7 @@ static int debugfs_errno_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(fops_errno, debugfs_errno_get, debugfs_errno_set,
+DEFINE_SIMPLE_ATTRIBUTE_SIGNED(fops_errno, debugfs_errno_get, debugfs_errno_set,
 			"%lld\n");
 
 static struct dentry *debugfs_create_errno(const char *name, umode_t mode,
-- 
2.35.1



