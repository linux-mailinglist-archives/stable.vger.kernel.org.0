Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455C0409300
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245627AbhIMOQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:16:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345038AbhIMOOt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:14:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB10E61AEF;
        Mon, 13 Sep 2021 13:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540637;
        bh=k6QrmouAQnh3bcPZYG3BkcLiWo6qCAT+FpjzOobLcLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ug0usjFgj6jPL/YrJjzEUPpPZ7icSTZRz6ebSMi6t92q6uoCz+DNkKHTNwkq5fgFW
         Ia1jtlJw2eLMO2mSWrZlbVyJJ+1NHXTu2HDSWqPbFqplI0PipWDyvoVucRiInKhS/2
         nFQo5LaSH3iNDtUDNoN2XamPlnDiWJy1q7981eg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.13 275/300] smb3: fix posix extensions mount option
Date:   Mon, 13 Sep 2021 15:15:36 +0200
Message-Id: <20210913131118.622507712@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 7321be2663da5922343cc121f1ff04924cee2e76 upstream.

We were incorrectly initializing the posix extensions in the
conversion to the new mount API.

CC: <stable@vger.kernel.org> # 5.11+
Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Suggested-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/fs_context.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -1259,10 +1259,17 @@ static int smb3_fs_context_parse_param(s
 			ctx->posix_paths = 1;
 		break;
 	case Opt_unix:
-		if (result.negated)
+		if (result.negated) {
+			if (ctx->linux_ext == 1)
+				pr_warn_once("conflicting posix mount options specified\n");
 			ctx->linux_ext = 0;
-		else
 			ctx->no_linux_ext = 1;
+		} else {
+			if (ctx->no_linux_ext == 1)
+				pr_warn_once("conflicting posix mount options specified\n");
+			ctx->linux_ext = 1;
+			ctx->no_linux_ext = 0;
+		}
 		break;
 	case Opt_nocase:
 		ctx->nocase = 1;


