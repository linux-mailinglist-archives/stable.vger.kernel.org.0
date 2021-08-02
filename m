Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4810C3DD4C0
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 13:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbhHBLim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 07:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233341AbhHBLil (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 07:38:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4849B60F4B;
        Mon,  2 Aug 2021 11:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627904311;
        bh=5MBnCkQ369CgNQ5mwu26JaHxQhTYh58n7YQ/KomWyio=;
        h=Subject:To:Cc:From:Date:From;
        b=zHRuYnkrh3ZBJ4kBPugZKRFgj8ZPmkj7W5L2YwAixrrD+1+pCUHr2NBgVFgb/Isd/
         J64wMAiuInGAIC+IlnB+0tluf7pR90uRVVmJ6vB2wad4jxzJH5XBgzI9UuRsJgxFW+
         tIvw94fjV/DXoX57YtbOOVaa2elvBtSPa4hy6jLc=
Subject: FAILED: patch "[PATCH] cifs: add missing parsing of backupuid" failed to apply to 5.13-stable tree
To:     lsahlber@redhat.com, sprasad@microsoft.com, stable@vger.kernel.org,
        stfrench@microsoft.com, xifeng@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 Aug 2021 13:38:29 +0200
Message-ID: <1627904309232147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b946dbcfa4df80ec81b442964e07ad37000cc059 Mon Sep 17 00:00:00 2001
From: Ronnie Sahlberg <lsahlber@redhat.com>
Date: Wed, 28 Jul 2021 16:38:29 +1000
Subject: [PATCH] cifs: add missing parsing of backupuid

We lost parsing of backupuid in the switch to new mount API.
Add it back.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Cc: <stable@vger.kernel.org> # v5.11+
Reported-by: Xiaoli Feng <xifeng@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 9a59d7ff9a11..eed59bc1d913 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -925,6 +925,13 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		ctx->cred_uid = uid;
 		ctx->cruid_specified = true;
 		break;
+	case Opt_backupuid:
+		uid = make_kuid(current_user_ns(), result.uint_32);
+		if (!uid_valid(uid))
+			goto cifs_parse_mount_err;
+		ctx->backupuid = uid;
+		ctx->backupuid_specified = true;
+		break;
 	case Opt_backupgid:
 		gid = make_kgid(current_user_ns(), result.uint_32);
 		if (!gid_valid(gid))

