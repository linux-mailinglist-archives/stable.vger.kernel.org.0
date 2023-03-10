Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC226B494A
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbjCJPLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233930AbjCJPKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:10:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDEEBDC0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:03:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0468761A21
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6C1C433D2;
        Fri, 10 Mar 2023 15:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460581;
        bh=/7Bnecys/UYg8QRXBubyt9f4KDPUIwuBhIGITMq9Zu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xVEz++HWXQYZFw0UAFKJ++9DNrWsMrGiCs4F8gmWNVE+O9LgBYkNicJtKQWvkqxx2
         tWVu5/77KcwC1w4B4EoE+kwXn9L/95NoOHGbNtpXu2VA86tYjoaMUlPtd2ZlUiv1/6
         10qmJypIFhByJLGnIsiwt8IYHo+tB8Kvf0pOZ6Ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+38695a20b8addcbc1084@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.10 352/529] udf: Detect system inodes linked into directory hierarchy
Date:   Fri, 10 Mar 2023 14:38:15 +0100
Message-Id: <20230310133821.329561956@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 85a37983ec69cc9fcd188bc37c4de15ee326355a upstream.

When UDF filesystem is corrupted, hidden system inodes can be linked
into directory hierarchy which is an avenue for further serious
corruption of the filesystem and kernel confusion as noticed by syzbot
fuzzed images. Refuse to access system inodes linked into directory
hierarchy and vice versa.

CC: stable@vger.kernel.org
Reported-by: syzbot+38695a20b8addcbc1084@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1897,8 +1897,13 @@ struct inode *__udf_iget(struct super_bl
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
-	if (!(inode->i_state & I_NEW))
+	if (!(inode->i_state & I_NEW)) {
+		if (UDF_I(inode)->i_hidden != hidden_inode) {
+			iput(inode);
+			return ERR_PTR(-EFSCORRUPTED);
+		}
 		return inode;
+	}
 
 	memcpy(&UDF_I(inode)->i_location, ino, sizeof(struct kernel_lb_addr));
 	err = udf_read_inode(inode, hidden_inode);


