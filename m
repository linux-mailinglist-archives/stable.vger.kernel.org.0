Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33882EA776
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 10:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbhAEJ3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 04:29:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:49740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728398AbhAEJ3y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 04:29:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6881F2255F;
        Tue,  5 Jan 2021 09:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609838917;
        bh=gMsNqKJZDuk4ZcuwnLe9zXaIYdpN/cXIbf4pPVDIPbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RElERCOmc1oUrG4QHr/+yNY7FVGe7Gw9CWUtRvjoxLVTcOlLsl12pN+4EIGPmzbdW
         8OZfV7RWx1wQc+TT1rI4XuoZM/yTh5y/ouzsFsQPBWknxINb19SS55FnRNpLgfi+wD
         lVWF7HCgmIqhGhynEhPVNambk7XMUr65MCDR4yao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.19 03/29] ext4: prevent creating duplicate encrypted filenames
Date:   Tue,  5 Jan 2021 10:28:49 +0100
Message-Id: <20210105090818.962261088@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210105090818.518271884@linuxfoundation.org>
References: <20210105090818.518271884@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 75d18cd1868c2aee43553723872c35d7908f240f upstream.

As described in "fscrypt: add fscrypt_is_nokey_name()", it's possible to
create a duplicate filename in an encrypted directory by creating a file
concurrently with adding the directory's encryption key.

Fix this bug on ext4 by rejecting no-key dentries in ext4_add_entry().

Note that the duplicate check in ext4_find_dest_de() sometimes prevented
this bug.  However in many cases it didn't, since ext4_find_dest_de()
doesn't examine every dentry.

Fixes: 4461471107b7 ("ext4 crypto: enable filename encryption")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201118075609.120337-3-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2106,6 +2106,9 @@ static int ext4_add_entry(handle_t *hand
 	if (!dentry->d_name.len)
 		return -EINVAL;
 
+	if (fscrypt_is_nokey_name(dentry))
+		return -ENOKEY;
+
 	retval = ext4_fname_setup_filename(dir, &dentry->d_name, 0, &fname);
 	if (retval)
 		return retval;


