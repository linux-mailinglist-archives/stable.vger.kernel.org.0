Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B007E5AAED7
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236517AbiIBMal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236497AbiIBM3a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:29:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4ED4DA3D0;
        Fri,  2 Sep 2022 05:25:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F4F3B82A98;
        Fri,  2 Sep 2022 12:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC96CC433D7;
        Fri,  2 Sep 2022 12:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121442;
        bh=MTbwheHkHaU8Y3oQb65J0M+2Y9P4BmVCuwgD58ZXwH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CRr1aKNo7Mp0pi6wPTcmz6Ulof9YY23M6tFfz2L/snrYcHRCjbH+vpNz/FEXvrX/y
         Pv8qib3i1F2npSEjdU73vMLACWUQBwa9fDgdiyvkWOzv3McLbWXvcYaQ7/wh+RN/8v
         15odAMqJ9CxQYRSOM7HCeCZjhJ9Ef6dFv9K+2x/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Jan Kara <jack@suse.cz>, Paul Moore <paul@paul-moore.com>
Subject: [PATCH 4.19 01/56] audit: fix potential double free on error path from fsnotify_add_inode_mark
Date:   Fri,  2 Sep 2022 14:18:21 +0200
Message-Id: <20220902121400.270567799@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121400.219861128@linuxfoundation.org>
References: <20220902121400.219861128@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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
@@ -111,6 +111,7 @@ struct audit_fsnotify_mark *audit_alloc_
 
 	ret = fsnotify_add_inode_mark(&audit_mark->mark, inode, true);
 	if (ret < 0) {
+		audit_mark->path = NULL;
 		fsnotify_put_mark(&audit_mark->mark);
 		audit_mark = ERR_PTR(ret);
 	}


