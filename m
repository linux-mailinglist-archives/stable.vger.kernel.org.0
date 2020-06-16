Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42FB11FB9F8
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730697AbgFPPqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:46:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731694AbgFPPqr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:46:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B28EF21475;
        Tue, 16 Jun 2020 15:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322407;
        bh=bzr/AX9iv/cLZSte631JwVq5+ZiXXYC5kSpMu6k8j4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1RMvEshryjm/MgaLQTu7N0HbZ/rjFaa4jIx8EqIvRyEb2CJuJW2avjIV3aCKNxm77
         ypkMI9p29mVJnenBQ5jb2c0+n54kfnoUS/z/T3YsnHtHbiIG1vLtIBvvDojTBYt42B
         tPtFoZjjr0oRAS/d79RzkDCdonvnSHRqyJo4DiLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 5.7 118/163] exfat: fix incorrect update of stream entry in __exfat_truncate()
Date:   Tue, 16 Jun 2020 17:34:52 +0200
Message-Id: <20200616153112.458363768@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

commit 29bbb14bfc80dd760b07d2be0a27e610562982e3 upstream.

At truncate, there is a problem of incorrect updating in the file entry
pointer instead of stream entry. This will cause the problem of
overwriting the time field of the file entry to new_size. Fix it to
update stream entry.

Fixes: 98d917047e8b ("exfat: add file operations")
Cc: stable@vger.kernel.org # v5.7
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/exfat/file.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -170,11 +170,11 @@ int __exfat_truncate(struct inode *inode
 
 		/* File size should be zero if there is no cluster allocated */
 		if (ei->start_clu == EXFAT_EOF_CLUSTER) {
-			ep->dentry.stream.valid_size = 0;
-			ep->dentry.stream.size = 0;
+			ep2->dentry.stream.valid_size = 0;
+			ep2->dentry.stream.size = 0;
 		} else {
-			ep->dentry.stream.valid_size = cpu_to_le64(new_size);
-			ep->dentry.stream.size = ep->dentry.stream.valid_size;
+			ep2->dentry.stream.valid_size = cpu_to_le64(new_size);
+			ep2->dentry.stream.size = ep->dentry.stream.valid_size;
 		}
 
 		if (new_size == 0) {


