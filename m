Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C44F344154
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbhCVMcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:32:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231448AbhCVMcH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:32:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D235619A9;
        Mon, 22 Mar 2021 12:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416316;
        bh=4c2RAuqgwg1MwBlAh/lKpuHRFObYcLGScn0rKCOiQBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FDT7P5MgAnIty2PYq3UsJkbVyrkJLAwRWXCIGPyF3BKR/11KelrrozdAm47qCXUwO
         E3nEEg7IWUerTR+IxRgfzB8ljKtBN6Cj6fg+D2t1bL7a7eOj6z5Ol7CcvQkZO/bHF8
         lHhkmef2oApCIyHOjhUPhFS+iLgef9Qa8ZP1pigM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.11 060/120] cifs: warn and fail if trying to use rootfs without the config option
Date:   Mon, 22 Mar 2021 13:27:23 +0100
Message-Id: <20210322121931.692909895@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurelien Aptel <aaptel@suse.com>

commit af3ef3b1031634724a3763606695ebcd113d782b upstream.

If CONFIG_CIFS_ROOT is not set, rootfs mount option is invalid

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
CC: <stable@vger.kernel.org> # v5.11
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/fs_context.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -1175,9 +1175,11 @@ static int smb3_fs_context_parse_param(s
 		pr_warn_once("Witness protocol support is experimental\n");
 		break;
 	case Opt_rootfs:
-#ifdef CONFIG_CIFS_ROOT
-		ctx->rootfs = true;
+#ifndef CONFIG_CIFS_ROOT
+		cifs_dbg(VFS, "rootfs support requires CONFIG_CIFS_ROOT config option\n");
+		goto cifs_parse_mount_err;
 #endif
+		ctx->rootfs = true;
 		break;
 	case Opt_posixpaths:
 		if (result.negated)


