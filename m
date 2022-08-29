Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E838E5A4972
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbiH2LZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbiH2LYW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:24:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583F8DFD7;
        Mon, 29 Aug 2022 04:15:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C26CB80EE6;
        Mon, 29 Aug 2022 11:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A737C433C1;
        Mon, 29 Aug 2022 11:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771190;
        bh=P/LQ/LiPfXrvovDBXBZ9fnnqsUSFQ6KLiLsbKyi7RZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a1um1TE+lPGsH+wB9b0JEm+nKaurkg6IMa1n+l+2XMFRPcqgwaVYaUecfE+dqf8Xg
         LNFRSEtIsYkI3u6UE7BM2r8ZrfmtG6+4mK29l0NPlXKK/3s3dGRw3OFtWmHCx/F5sE
         7rPJ6gHT2Ze9N7r4niJzi0wrZiFwvysvxLgeTvAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Jan Kara <jack@suse.cz>, Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.19 003/158] audit: fix potential double free on error path from fsnotify_add_inode_mark
Date:   Mon, 29 Aug 2022 12:57:33 +0200
Message-Id: <20220829105808.970145922@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

commit ad982c3be4e60c7d39c03f782733503cbd88fd2a upstream.

Audit_alloc_mark() assign pathname to audit_mark->path, on error path
from fsnotify_add_inode_mark(), fsnotify_put_mark will free memory
of audit_mark->path, but the caller of audit_alloc_mark will free
the pathname again, so there will be double free problem.

Fix this by resetting audit_mark->path to NULL pointer on error path
from fsnotify_add_inode_mark().

Cc: stable@vger.kernel.org
Fixes: 7b1293234084d ("fsnotify: Add group pointer in fsnotify_init_mark()")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/audit_fsnotify.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/audit_fsnotify.c
+++ b/kernel/audit_fsnotify.c
@@ -102,6 +102,7 @@ struct audit_fsnotify_mark *audit_alloc_
 
 	ret = fsnotify_add_inode_mark(&audit_mark->mark, inode, 0);
 	if (ret < 0) {
+		audit_mark->path = NULL;
 		fsnotify_put_mark(&audit_mark->mark);
 		audit_mark = ERR_PTR(ret);
 	}


