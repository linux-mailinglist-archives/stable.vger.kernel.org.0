Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16685A47C5
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiH2LCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiH2LBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:01:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9E663F1E;
        Mon, 29 Aug 2022 04:01:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55A7C6119A;
        Mon, 29 Aug 2022 11:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED60C433C1;
        Mon, 29 Aug 2022 11:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661770883;
        bh=CJRQTFu+wUrdMa03M09XgGm0xY+TyLR5hIcc/xMR2wQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NKnd0bIi7ugSGbsfjM7pvZ7q0rFCMgQOi2zH2nNMx8vpkw/Fkq/S9w21txF2EHogp
         Vo5EhHP7TjKgRG2LiD8vqBgFYkV6EMjOlIIE/aiC4xoH18cVLmnV5QTteO0Jcnlxlu
         ceSyo9PRtesGTUUjeABQ51VqierrcNxz/fM7S6c4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Jan Kara <jack@suse.cz>, Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.15 003/136] audit: fix potential double free on error path from fsnotify_add_inode_mark
Date:   Mon, 29 Aug 2022 12:57:50 +0200
Message-Id: <20220829105804.767752511@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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
 
 	ret = fsnotify_add_inode_mark(&audit_mark->mark, inode, true);
 	if (ret < 0) {
+		audit_mark->path = NULL;
 		fsnotify_put_mark(&audit_mark->mark);
 		audit_mark = ERR_PTR(ret);
 	}


