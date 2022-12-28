Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3E36577BD
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiL1O0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbiL1O0S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:26:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA93DFCE6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:26:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 441AF6152E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7EBC433EF;
        Wed, 28 Dec 2022 14:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672237576;
        bh=iSHrzpuUOX+9qxLgedR3RRfLrlWnJg48VWKuTNRAIg4=;
        h=Subject:To:Cc:From:Date:From;
        b=gBb0p4fTE7D7wJ/rCF+18Bn7w0Q61LY/59D6kOv7CO8uTaKihhUBx43W/GQQnXdjG
         XioWfxT7nlyZDOIG/1TWEdd+mMc74ETzWqCltF5rdw7HLQXNDofavy68hUx9jTKlyi
         8FUAAneMMCFFBIhuJ9PIEV2huygE5ITqk54ymiXg=
Subject: FAILED: patch "[PATCH] cifs: don't leak -ENOMEM in smb2_open_file()" failed to apply to 6.0-stable tree
To:     pc@cjr.nz, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Dec 2022 15:26:08 +0100
Message-ID: <1672237568120216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f60ffa662d14 ("cifs: don't leak -ENOMEM in smb2_open_file()")
a9e17d3d74d1 ("cifs: fix static checker warning")
76894f3e2f71 ("cifs: improve symlink handling for smb2+")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f60ffa662d1427cfd31fe9d895c3566ac50bfe52 Mon Sep 17 00:00:00 2001
From: Paulo Alcantara <pc@cjr.nz>
Date: Mon, 19 Dec 2022 10:21:50 -0300
Subject: [PATCH] cifs: don't leak -ENOMEM in smb2_open_file()

A NULL error response might be a valid case where smb2_reconnect()
failed to reconnect the session and tcon due to a disconnected server
prior to issuing the I/O operation, so don't leak -ENOMEM to userspace
on such occasions.

Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index ffbd9a99fc12..ba6cc50af390 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -122,8 +122,8 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 		struct smb2_hdr *hdr = err_iov.iov_base;
 
 		if (unlikely(!err_iov.iov_base || err_buftype == CIFS_NO_BUFFER))
-			rc = -ENOMEM;
-		else if (hdr->Status == STATUS_STOPPED_ON_SYMLINK) {
+			goto out;
+		if (hdr->Status == STATUS_STOPPED_ON_SYMLINK) {
 			rc = smb2_parse_symlink_response(oparms->cifs_sb, &err_iov,
 							 &data->symlink_target);
 			if (!rc) {

