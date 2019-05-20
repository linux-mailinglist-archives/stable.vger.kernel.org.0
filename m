Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36E3C23707
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732236AbfETMTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:19:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730795AbfETMTr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:19:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA96C20815;
        Mon, 20 May 2019 12:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354787;
        bh=Y6EuyZEjvaLernhvKw4omgcW49gcVTdIABeEb1lxmfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQLlp4650Wj78DZdHdLpmNiq1HIXvN8J6GrNVLVGJQQmW7LQdQm2ENTWWPl1tNYGc
         iWkMDWrxbaJzhPT2I2YSxbJwRLgJQas259UgPyGx4LGN9dzDUdyqQVQLiP+w1JS4UD
         HQs6YY3O0Yw5AVDjAWjrNdb1l4jbCpPUG4njihws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 4.14 42/63] ext4: ignore e_value_offs for xattrs with value-in-ea-inode
Date:   Mon, 20 May 2019 14:14:21 +0200
Message-Id: <20190520115235.746611796@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115231.137981521@linuxfoundation.org>
References: <20190520115231.137981521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit e5d01196c0428a206f307e9ee5f6842964098ff0 upstream.

In other places in fs/ext4/xattr.c, if e_value_inum is non-zero, the
code ignores the value in e_value_offs.  The e_value_offs *should* be
zero, but we shouldn't depend upon it, since it might not be true in a
corrupted/fuzzed file system.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202897
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202877
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1698,7 +1698,7 @@ static int ext4_xattr_set_entry(struct e
 
 	/* No failures allowed past this point. */
 
-	if (!s->not_found && here->e_value_size && here->e_value_offs) {
+	if (!s->not_found && here->e_value_size && !here->e_value_inum) {
 		/* Remove the old value. */
 		void *first_val = s->base + min_offs;
 		size_t offs = le16_to_cpu(here->e_value_offs);


