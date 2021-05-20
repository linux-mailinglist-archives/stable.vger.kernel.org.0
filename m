Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2625D38A353
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbhETJvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:51:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234309AbhETJtO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:49:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B49F06147F;
        Thu, 20 May 2021 09:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503301;
        bh=2Ibpr1tVezbnyXLqAAOhzFOS/unwy5c0Vjqp9+L7hkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yOVQPse81nWE3XCUzLLqZobOqVMCsmfVOro3bMXGgF8SdKMK64VXu9exSErLNuOXB
         K3jIWFWrkGIJ5keeC1QbLH4BwpRbOEkOxZ+xLmt6y6ygtBBeedOu36ha5f+WZrCnTa
         fJg82fmSWLL5fbAQxJorA8k4g2ag0AbUilkM5LjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.19 160/425] ovl: fix missing revert_creds() on error path
Date:   Thu, 20 May 2021 11:18:49 +0200
Message-Id: <20210520092136.717014589@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 7b279bbfd2b230c7a210ff8f405799c7e46bbf48 upstream.

Smatch complains about missing that the ovl_override_creds() doesn't
have a matching revert_creds() if the dentry is disconnected.  Fix this
by moving the ovl_override_creds() until after the disconnected check.

Fixes: aa3ff3c152ff ("ovl: copy up of disconnected dentries")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -824,7 +824,7 @@ static int ovl_copy_up_one(struct dentry
 int ovl_copy_up_flags(struct dentry *dentry, int flags)
 {
 	int err = 0;
-	const struct cred *old_cred = ovl_override_creds(dentry->d_sb);
+	const struct cred *old_cred;
 	bool disconnected = (dentry->d_flags & DCACHE_DISCONNECTED);
 
 	/*
@@ -835,6 +835,7 @@ int ovl_copy_up_flags(struct dentry *den
 	if (WARN_ON(disconnected && d_is_dir(dentry)))
 		return -EIO;
 
+	old_cred = ovl_override_creds(dentry->d_sb);
 	while (!err) {
 		struct dentry *next;
 		struct dentry *parent = NULL;


