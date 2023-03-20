Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1236C17F7
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbjCTPTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbjCTPSk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:18:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2562A35ECC
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:13:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D024B80EDD
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD45C433D2;
        Mon, 20 Mar 2023 15:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325160;
        bh=Hr9VKbCEh5dpIQ9mXWc9ZNs6Ogo1h4vKSR3ROQm6D60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ihu0bfqYYdV0fNo0pBIAKuQstuhe11YZHeKJ6KTd8xpbyukb9GYFY2B4jqFQNnpRd
         QrTFPAxeBFtJgB6PsenlQhJQ5cvzPQRkitLDffIms6hBpCJyjmgo/atiSS2petYibY
         NxDZgpzH6Fq9WZ+3RiI3MRNutG7JGBl+QJSXaCag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miklos Szeredi <miklos@szeredi.hu>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 96/99] fs: use consistent setgid checks in is_sxid()
Date:   Mon, 20 Mar 2023 15:55:14 +0100
Message-Id: <20230320145447.445372729@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

commit 8d84e39d76bd83474b26cb44f4b338635676e7e8 upstream.

Now that we made the VFS setgid checking consistent an inode can't be
marked security irrelevant even if the setgid bit is still set. Make
this function consistent with all other helpers.

Note that enforcing consistent setgid stripping checks for file
modification and mode- and ownership changes will cause the setgid bit
to be lost in more cases than useed to be the case. If an unprivileged
user wrote to a non-executable setgid file that they don't have
privilege over the setgid bit will be dropped. This will lead to
temporary failures in some xfstests until they have been updated.

Reported-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3408,7 +3408,7 @@ int __init get_filesystem_list(char *buf
 
 static inline bool is_sxid(umode_t mode)
 {
-	return (mode & S_ISUID) || ((mode & S_ISGID) && (mode & S_IXGRP));
+	return mode & (S_ISUID | S_ISGID);
 }
 
 static inline int check_sticky(struct inode *dir, struct inode *inode)


