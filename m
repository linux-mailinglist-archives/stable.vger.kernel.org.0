Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B998627F98
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237673AbiKNNAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237665AbiKNNAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:00:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570A8286F4
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:00:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AF14B80EC2
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F42C433D6;
        Mon, 14 Nov 2022 13:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430841;
        bh=A2uZ4Ip+tHv+FK3kUEA0ZuXtdZktkDaepej8/P8O8L4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kwSUzdC9+6Fzuv3IxIvcJP8ttJapm8sXLorJoAXBKFJichHjyfiT9DwY5s3Nt6M5p
         BlSpTiIdUMm6u+XDTG2HJGh0A/MI+4ig3AlHEPElbHJLHwWU/CHlol9DJous4YVAi9
         +TM3hww5FMJKtD4QAYHfSKHr5XnddELLWq2+c2L4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 004/190] KVM: debugfs: Return retval of simple_attr_open() if it fails
Date:   Mon, 14 Nov 2022 13:43:48 +0100
Message-Id: <20221114124459.001406228@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

[ Upstream commit 180418e2eb33be5c8d0b703c843e0ebc045aef80 ]

Although simple_attr_open() fails only with -ENOMEM with current code
base, it would be nicer to return retval of simple_attr_open() directly
in kvm_debugfs_open().

No functional change intended.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Message-Id: <69d64d93accd1f33691b8a383ae555baee80f943.1665975828.git.houwenlong.hwl@antgroup.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4c5259828efd..b76c775f61f9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5404,6 +5404,7 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
 			   int (*get)(void *, u64 *), int (*set)(void *, u64),
 			   const char *fmt)
 {
+	int ret;
 	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)
 					  inode->i_private;
 
@@ -5415,15 +5416,13 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
 	if (!kvm_get_kvm_safe(stat_data->kvm))
 		return -ENOENT;
 
-	if (simple_attr_open(inode, file, get,
-		    kvm_stats_debugfs_mode(stat_data->desc) & 0222
-		    ? set : NULL,
-		    fmt)) {
+	ret = simple_attr_open(inode, file, get,
+			       kvm_stats_debugfs_mode(stat_data->desc) & 0222
+			       ? set : NULL, fmt);
+	if (ret)
 		kvm_put_kvm(stat_data->kvm);
-		return -ENOMEM;
-	}
 
-	return 0;
+	return ret;
 }
 
 static int kvm_debugfs_release(struct inode *inode, struct file *file)
-- 
2.35.1



