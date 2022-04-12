Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84A24FD856
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344347AbiDLHpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353257AbiDLHZS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667CC4E39F;
        Tue, 12 Apr 2022 00:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06B91B81B4F;
        Tue, 12 Apr 2022 07:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718E3C385A6;
        Tue, 12 Apr 2022 07:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746818;
        bh=c+omZP6b97ce8PuNMw7NgKdL3P/XKwm+AoC4Zyoc8Sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wsIoX2Kyc+IUGFTnK/xP/DTEMCRnkmPTuQmiRVVEOdKduGdYHDGWqE+5AJYACqC1Z
         5BUu1GrrJhtJi2M0FS4Dz57cB8ET1dOpKwg4IrRUxp1bNxTzZa4vekH1owIk0JtKeY
         VdtRBiDSy1LON2T7KuGsrRcLYhFrmFVovi+NpoTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TCS Robot <tcs_robot@tencent.com>,
        Haimin Zhang <tcs_kernel@tencent.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 141/285] jfs: prevent NULL deref in diFree
Date:   Tue, 12 Apr 2022 08:29:58 +0200
Message-Id: <20220412062947.738757217@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

From: Haimin Zhang <tcs_kernel@tencent.com>

[ Upstream commit a53046291020ec41e09181396c1e829287b48d47 ]

Add validation check for JFS_IP(ipimap)->i_imap to prevent a NULL deref
in diFree since diFree uses it without do any validations.
When function jfs_mount calls diMount to initialize fileset inode
allocation map, it can fail and JFS_IP(ipimap)->i_imap won't be
initialized. Then it calls diFreeSpecial to close fileset inode allocation
map inode and it will flow into jfs_evict_inode. Function jfs_evict_inode
just validates JFS_SBI(inode->i_sb)->ipimap, then calls diFree. diFree use
JFS_IP(ipimap)->i_imap directly, then it will cause a NULL deref.

Reported-by: TCS Robot <tcs_robot@tencent.com>
Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 57ab424c05ff..072821b50ab9 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -146,12 +146,13 @@ void jfs_evict_inode(struct inode *inode)
 		dquot_initialize(inode);
 
 		if (JFS_IP(inode)->fileset == FILESYSTEM_I) {
+			struct inode *ipimap = JFS_SBI(inode->i_sb)->ipimap;
 			truncate_inode_pages_final(&inode->i_data);
 
 			if (test_cflag(COMMIT_Freewmap, inode))
 				jfs_free_zero_link(inode);
 
-			if (JFS_SBI(inode->i_sb)->ipimap)
+			if (ipimap && JFS_IP(ipimap)->i_imap)
 				diFree(inode);
 
 			/*
-- 
2.35.1



