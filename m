Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3736A6BB2BB
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbjCOMiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbjCOMh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:37:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B236A18B7
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:36:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 885F66128D
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959F5C433D2;
        Wed, 15 Mar 2023 12:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883815;
        bh=jez07NPNbeloQ0W4CNLmkdHmbG+SEt7LRb7joAVLHUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Zzu+SarQuvSncAGc9Kztn1BCUm7qqd5YRpz20xzPQqiaIE6TgS9we7ksA6RRRgCs
         pd00AtqZ757RvCbd9653ndKMJK+vDqwobbqQQuqEl/o43fOkjjMPE0zunFlYMS2YHv
         MPRKuOLcBu7/n5CvVCkiyI2WjY4OQ+nBf48A+/WI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Seth Forshee (DigitalOcean)" <sforshee@kernel.org>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>
Subject: [PATCH 6.1 141/143] filelocks: use mount idmapping for setlease permission check
Date:   Wed, 15 Mar 2023 13:13:47 +0100
Message-Id: <20230315115744.919936821@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seth Forshee <sforshee@kernel.org>

commit 42d0c4bdf753063b6eec55415003184d3ca24f6e upstream.

A user should be allowed to take out a lease via an idmapped mount if
the fsuid matches the mapped uid of the inode. generic_setlease() is
checking the unmapped inode uid, causing these operations to be denied.

Fix this by comparing against the mapped inode uid instead of the
unmapped uid.

Fixes: 9caccd41541a ("fs: introduce MOUNT_ATTR_IDMAP")
Cc: stable@vger.kernel.org
Signed-off-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/locks.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1862,9 +1862,10 @@ int generic_setlease(struct file *filp,
 			void **priv)
 {
 	struct inode *inode = locks_inode(filp);
+	vfsuid_t vfsuid = i_uid_into_vfsuid(file_mnt_user_ns(filp), inode);
 	int error;
 
-	if ((!uid_eq(current_fsuid(), inode->i_uid)) && !capable(CAP_LEASE))
+	if ((!vfsuid_eq_kuid(vfsuid, current_fsuid())) && !capable(CAP_LEASE))
 		return -EACCES;
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;


