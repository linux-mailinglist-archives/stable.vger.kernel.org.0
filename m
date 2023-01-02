Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD5265B116
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbjABLaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbjABL3e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:29:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AF1642F
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:29:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DFD1ACE0E1D
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC37C433EF;
        Mon,  2 Jan 2023 11:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658943;
        bh=brgNw/t9C+5VCrcvkooNJ83yLfbdV95Y/k4DoRWcK6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2stFDLTim5KDOVtJ/8p3VlQUnTIN718QGCKHQkMH1nnvunzP8HUw8NsWNuHYptfUF
         Gw0vWjBvgZDRVwfmAYctlBT9WFLZv1MDJw8aDczjSe4lGZFRSIGkpvgtXOYF4XaNEj
         1n9pJ61aFfeDrL+rOHSreDmuS7Anf2fAmyfdr7tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pierre Labastie <pierre.labastie@neuf.fr>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.0 58/74] ovl: update ->f_iocb_flags when ovl_change_flags() modifies ->f_flags
Date:   Mon,  2 Jan 2023 12:22:31 +0100
Message-Id: <20230102110554.574408722@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

commit 456b59e757b0c558df550764a4fd5ae6877e93f8 upstream.

ovl_change_flags() is an open-coded variant of fs/fcntl.c:setfl() and it
got missed by commit 164f4064ca81 ("keep iocb_flags() result cached in
struct file"); the same change applies there.

Reported-by: Pierre Labastie <pierre.labastie@neuf.fr>
Fixes: 164f4064ca81 ("keep iocb_flags() result cached in struct file")
Cc: <stable@vger.kernel.org> # v6.0
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216738
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index a1a22f58ba18..dd688a842b0b 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -96,6 +96,7 @@ static int ovl_change_flags(struct file *file, unsigned int flags)
 
 	spin_lock(&file->f_lock);
 	file->f_flags = (file->f_flags & ~OVL_SETFL_MASK) | flags;
+	file->f_iocb_flags = iocb_flags(file);
 	spin_unlock(&file->f_lock);
 
 	return 0;
-- 
2.39.0



