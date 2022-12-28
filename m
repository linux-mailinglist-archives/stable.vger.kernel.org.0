Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8DDE658465
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235344AbiL1Q5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235301AbiL1Q4j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:56:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA0EC58
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:52:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A61556156B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE72BC433D2;
        Wed, 28 Dec 2022 16:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246363;
        bh=EsVgcSyGk4Pqdt2kx22dkDCMFqpGKOiIq2/4yPeyngk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iltXNBk3YSfXE6CkgKHFh3f6YNx6fvHQzvwgi18gpMXaG4+2yxa+/qYWuSKv1VK6u
         I/T6IQzm7jYP23IVaBsUxLQuovO7dvp+HZkmsn439Pu7/ybdwvmhb0+Shp/SiHxRyr
         ZPbBBz5RfXtAu1zrUxKa5C5AJFrsQuh8tuu2oEmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        syzbot+a4055c78774bbf3498bb@syzkaller.appspotmail.com
Subject: [PATCH 6.0 1055/1073] ovl: fix use inode directly in rcu-walk mode
Date:   Wed, 28 Dec 2022 15:44:03 +0100
Message-Id: <20221228144356.883947222@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

commit 672e4268b2863d7e4978dfed29552b31c2f9bd4e upstream.

ovl_dentry_revalidate_common() can be called in rcu-walk mode.  As document
said, "in rcu-walk mode, d_parent and d_inode should not be used without
care".

Check inode here to protect access under rcu-walk mode.

Fixes: bccece1ead36 ("ovl: allow remote upper")
Reported-and-tested-by: syzbot+a4055c78774bbf3498bb@syzkaller.appspotmail.com
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Cc: <stable@vger.kernel.org> # v5.7
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/super.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -138,11 +138,16 @@ static int ovl_dentry_revalidate_common(
 					unsigned int flags, bool weak)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
+	struct inode *inode = d_inode_rcu(dentry);
 	struct dentry *upper;
 	unsigned int i;
 	int ret = 1;
 
-	upper = ovl_dentry_upper(dentry);
+	/* Careful in RCU mode */
+	if (!inode)
+		return -ECHILD;
+
+	upper = ovl_i_dentry_upper(inode);
 	if (upper)
 		ret = ovl_revalidate_real(upper, flags, weak);
 


