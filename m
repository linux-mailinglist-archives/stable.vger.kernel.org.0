Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDEA420E9A
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235926AbhJDN0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:26:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236644AbhJDNYy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:24:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F36B61B65;
        Mon,  4 Oct 2021 13:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353049;
        bh=5TALvWlUOq5EOSkPIekPioYEakqvrZmH8UFMhndL4BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BysVLhTY4A3XBrCdV6v6YRSCLrfX2Yibs0+mH6zDpCwUJNude2TWZArKrEWCl3TmC
         RJLqvifHb/4YY0Lgl/7Oo4tOCNPd2CtRTVNSvWlhhjb7Su1FxSeyivUg1vYSGFYXwX
         nMxgwhs2fFBUr83weSv7Wp7wa2zahbsjHkKopmGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Nirmoy Das <nirmoy.das@amd.com>
Subject: [PATCH 5.10 70/93] debugfs: debugfs_create_file_size(): use IS_ERR to check for error
Date:   Mon,  4 Oct 2021 14:53:08 +0200
Message-Id: <20211004125036.891440757@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirmoy Das <nirmoy.das@amd.com>

commit af505cad9567f7a500d34bf183696d570d7f6810 upstream.

debugfs_create_file() returns encoded error so use IS_ERR for checking
return value.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Nirmoy Das <nirmoy.das@amd.com>
Fixes: ff9fb72bc077 ("debugfs: return error values, not NULL")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210902102917.2233-1-nirmoy.das@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/debugfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -524,7 +524,7 @@ void debugfs_create_file_size(const char
 {
 	struct dentry *de = debugfs_create_file(name, mode, parent, data, fops);
 
-	if (de)
+	if (!IS_ERR(de))
 		d_inode(de)->i_size = file_size;
 }
 EXPORT_SYMBOL_GPL(debugfs_create_file_size);


