Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2744F33D9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245545AbiDEI4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241091AbiDEIcs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA145140E3;
        Tue,  5 Apr 2022 01:27:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3A12FCE1C05;
        Tue,  5 Apr 2022 08:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DADC385A4;
        Tue,  5 Apr 2022 08:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147231;
        bh=dXFWPeFlgT6CyzZ310/ga2U0bPPCNAqe3eAdLbGPkzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYfoE0SOpl1CpVMC3kjqsCYdpwvQ+OvaO9kTrAThDV524Ho0+wEbt3UKfrHqx55UE
         Yw+BCNmo3yHb3FEwDN4jTJ3PbE9NeaHv6aVpFz+W29JrMb/afC/wVol0zumEz0Wn/Y
         Sl3MisGE3nb9WR2eezyZrr5ZIstP4oJSouOIuiB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.17 1010/1126] ubifs: setflags: Make dirtied_ino_d 8 bytes aligned
Date:   Tue,  5 Apr 2022 09:29:17 +0200
Message-Id: <20220405070437.134950528@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit 1b83ec057db16b4d0697dc21ef7a9743b6041f72 upstream.

Make 'ui->data_len' aligned with 8 bytes before it is assigned to
dirtied_ino_d. Since 8871d84c8f8b0c6b("ubifs: convert to fileattr")
applied, 'setflags()' only affects regular files and directories, only
xattr inode, symlink inode and special inode(pipe/char_dev/block_dev)
have none- zero 'ui->data_len' field, so assertion
'!(req->dirtied_ino_d & 7)' cannot fail in ubifs_budget_space().
To avoid assertion fails in future evolution(eg. setflags can operate
special inodes), it's better to make dirtied_ino_d 8 bytes aligned,
after all aligned size is still zero for regular files.

Fixes: 1e51764a3c2ac05a ("UBIFS: add new flash file system")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ubifs/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ubifs/ioctl.c
+++ b/fs/ubifs/ioctl.c
@@ -108,7 +108,7 @@ static int setflags(struct inode *inode,
 	struct ubifs_inode *ui = ubifs_inode(inode);
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
 	struct ubifs_budget_req req = { .dirtied_ino = 1,
-					.dirtied_ino_d = ui->data_len };
+			.dirtied_ino_d = ALIGN(ui->data_len, 8) };
 
 	err = ubifs_budget_space(c, &req);
 	if (err)


