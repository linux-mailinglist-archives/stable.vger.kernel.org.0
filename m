Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51563579900
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 13:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237492AbiGSL5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 07:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237574AbiGSL5O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 07:57:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA3445077;
        Tue, 19 Jul 2022 04:56:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FA0F6165E;
        Tue, 19 Jul 2022 11:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7DDC341D1;
        Tue, 19 Jul 2022 11:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231797;
        bh=n0mhtTbRmKMrtDsxbt0+8JC74G0b+EOPSqVSehfbq3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B53K555nLn695Z5fuo3dRZIPlPWF3HDjIWPdqwjM4ePwcmVYk7vMEyuiAhYzcKrYU
         hRH8lajEXglYndkJHRoJr47XhB8RsnYEDPgXLHVJgcgnm4DAhvgjPBdk4fyLzrN8IV
         TsWh4yCfDhOzyTj/PIRQ2DkcATZESNl0DFEwCie4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Tommy Pettersson <ptp@lysator.liu.se>,
        Ciprian Craciun <ciprian.craciun@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.9 06/28] nilfs2: fix incorrect masking of permission flags for symlinks
Date:   Tue, 19 Jul 2022 13:53:44 +0200
Message-Id: <20220719114457.110414851@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114455.701304968@linuxfoundation.org>
References: <20220719114455.701304968@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 5924e6ec1585445f251ea92713eb15beb732622a upstream.

The permission flags of newly created symlinks are wrongly dropped on
nilfs2 with the current umask value even though symlinks should have 777
(rwxrwxrwx) permissions:

 $ umask
 0022
 $ touch file && ln -s file symlink; ls -l file symlink
 -rw-r--r--. 1 root root 0 Jun 23 16:29 file
 lrwxr-xr-x. 1 root root 4 Jun 23 16:29 symlink -> file

This fixes the bug by inserting a missing check that excludes
symlinks.

Link: https://lkml.kernel.org/r/1655974441-5612-1-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: Tommy Pettersson <ptp@lysator.liu.se>
Reported-by: Ciprian Craciun <ciprian.craciun@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/nilfs.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -212,6 +212,9 @@ static inline int nilfs_acl_chmod(struct
 
 static inline int nilfs_init_acl(struct inode *inode, struct inode *dir)
 {
+	if (S_ISLNK(inode->i_mode))
+		return 0;
+
 	inode->i_mode &= ~current_umask();
 	return 0;
 }


