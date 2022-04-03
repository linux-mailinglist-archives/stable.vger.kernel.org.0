Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68B2E4F0921
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 13:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357054AbiDCLqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 07:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357049AbiDCLqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 07:46:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D4424F0B
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 04:44:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5B22610A1
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 11:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FEAC340ED;
        Sun,  3 Apr 2022 11:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648986294;
        bh=aQNsGADtBW82zL5bQTWI1a7onUMnK5jECmf53f21QoE=;
        h=Subject:To:Cc:From:Date:From;
        b=ippP/spaHdN5WrprSk1qiOCT1gbX2BItbrhNTl4gB89gzZiVtFLd6NFu6uMDe3IxX
         Vb7EvisBH/qdBW6aBcKGdDDS9hX8QTk5r9ZC6OfO3uxXRuwhJz6tpPixPi6qPBWV+k
         STTUucK+53ah+MRdenM1GsDbt5BsSC8yJMabIb7Y=
Subject: FAILED: patch "[PATCH] ubifs: rename_whiteout: correct old_dir size computing" failed to apply to 4.9-stable tree
To:     libaokun1@huawei.com, chengzhihao1@huawei.com, richard@nod.at
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Apr 2022 13:43:39 +0200
Message-ID: <1648986219206167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 705757274599e2e064dd3054aabc74e8af31a095 Mon Sep 17 00:00:00 2001
From: Baokun Li <libaokun1@huawei.com>
Date: Tue, 15 Feb 2022 12:07:36 +0800
Subject: [PATCH] ubifs: rename_whiteout: correct old_dir size computing

When renaming the whiteout file, the old whiteout file is not deleted.
Therefore, we add the old dentry size to the old dir like XFS.
Otherwise, an error may be reported due to `fscki->calc_sz != fscki->size`
in check_indes.

Fixes: 9e0a1fff8db56ea ("ubifs: Implement RENAME_WHITEOUT")
Reported-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index ae082a0be2a3..86151889548e 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1402,6 +1402,9 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
 			iput(whiteout);
 			goto out_release;
 		}
+
+		/* Add the old_dentry size to the old_dir size. */
+		old_sz -= CALC_DENT_SIZE(fname_len(&old_nm));
 	}
 
 	lock_4_inodes(old_dir, new_dir, new_inode, whiteout);

