Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182B2409602
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345403AbhIMOrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:47:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348266AbhIMOpE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:45:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09C4563216;
        Mon, 13 Sep 2021 13:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541481;
        bh=9IRgH9aahkMqStjkv0Z+jIoQe74LC1kvQUx7khhunR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ayX71FwqEyBdzruRamvdGrt26jdnUU3RWpQ+9oPAS1E/shH0nrruDy85jFJvFoibv
         xDVggZb9f7bC6os8TnTjw/PdLEm5U64UztwGWoRndOrIY/bNGvapcelLh4fF/T54Mu
         pzSoXO2nV5s9KTycw16Qw7A0Kj4ZY4LgyND4Xdcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.14 307/334] smb3: fix posix extensions mount option
Date:   Mon, 13 Sep 2021 15:16:01 +0200
Message-Id: <20210913131123.803546229@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
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
@@ -1266,10 +1266,17 @@ static int smb3_fs_context_parse_param(s
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


