Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA56F582F4A
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241922AbiG0RWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235333AbiG0RVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:21:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C198751A1B;
        Wed, 27 Jul 2022 09:45:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08F9AB821A6;
        Wed, 27 Jul 2022 16:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67594C433C1;
        Wed, 27 Jul 2022 16:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940313;
        bh=1YJj+zf8oi0rxQU45OyHdE/CCMttpqbIvrrCYGyaOQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YxWWuAbRn5PlWl5w4uG3Hvvw9jlQXL0UbE257FJATS5182g8+1QvHaLP7hioyabwv
         65nf+S5gWapbsL0Vzkgqc0hYnUnjH7oDKwR10DXUceS2+GlzpztkPDLPPAss7MeESv
         GUC7AF6DZJYFLjBPmgEwMjPRAl+z/DiBQ20OkfpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Yugui <wangyugui@e16-tech.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5.15 181/201] exfat: use updated exfat_chain directly during renaming
Date:   Wed, 27 Jul 2022 18:11:25 +0200
Message-Id: <20220727161035.302903018@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sungjong Seo <sj1557.seo@samsung.com>

commit 204e6ceaa1035cb7b92b156517e88842ebb4c7ff upstream.

In order for a file to access its own directory entry set,
exfat_inode_info(ei) has two copied values. One is ei->dir, which is
a snapshot of exfat_chain of the parent directory, and the other is
ei->entry, which is the offset of the start of the directory entry set
in the parent directory.

Since the parent directory can be updated after the snapshot point,
it should be used only for accessing one's own directory entry set.

However, as of now, during renaming, it could try to traverse or to
allocate clusters via snapshot values, it does not make sense.

This potential problem has been revealed when exfat_update_parent_info()
was removed by commit d8dad2588add ("exfat: fix referencing wrong parent
directory information after renaming"). However, I don't think it's good
idea to bring exfat_update_parent_info() back.

Instead, let's use the updated exfat_chain of parent directory diectly.

Fixes: d8dad2588add ("exfat: fix referencing wrong parent directory information after renaming")
Reported-by: Wang Yugui <wangyugui@e16-tech.com>
Signed-off-by: Sungjong Seo <sj1557.seo@samsung.com>
Tested-by: Wang Yugui <wangyugui@e16-tech.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/namei.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -1190,7 +1190,9 @@ static int __exfat_rename(struct inode *
 		return -ENOENT;
 	}
 
-	exfat_chain_dup(&olddir, &ei->dir);
+	exfat_chain_set(&olddir, EXFAT_I(old_parent_inode)->start_clu,
+		EXFAT_B_TO_CLU_ROUND_UP(i_size_read(old_parent_inode), sbi),
+		EXFAT_I(old_parent_inode)->flags);
 	dentry = ei->entry;
 
 	ep = exfat_get_dentry(sb, &olddir, dentry, &old_bh, NULL);


