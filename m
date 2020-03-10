Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D05DF17F7AF
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgCJMl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:41:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726837AbgCJMl2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:41:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B2D624698;
        Tue, 10 Mar 2020 12:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844086;
        bh=uOxiZGB6cB8mzQhBTuIRU4Z3aQ39w41B7Hx6Zi24a34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWHvDJYZzQk/ShEHfdMrqfAgzTWQR/WjcNVZghvQXM2g72dac2YUc35IzTLDQiEwm
         cVkAM9Jk3p8XaQDSFQ3YUupipzdzqWl5Vbclxp4XOspI/j8xO25N5VuHQ26daDSOEd
         aUN8HgtRNe58TEMfkvqjBYPgUACteQ4vSlvvdsXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 4.4 26/72] ecryptfs: Fix up bad backport of fe2e082f5da5b4a0a92ae32978f81507ef37ec66
Date:   Tue, 10 Mar 2020 13:38:39 +0100
Message-Id: <20200310123608.241254542@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123601.053680753@linuxfoundation.org>
References: <20200310123601.053680753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

When doing the 4.9 merge into certain Android trees, I noticed a warning
from Android's deprecated GCC 4.9.4, which causes a build failure in
those trees due to basically -Werror:

fs/ecryptfs/keystore.c: In function 'ecryptfs_parse_packet_set':
fs/ecryptfs/keystore.c:1357:2: warning: 'auth_tok_list_item' may be used
uninitialized in this function [-Wmaybe-uninitialized]
  memset(auth_tok_list_item, 0,
  ^
fs/ecryptfs/keystore.c:1260:38: note: 'auth_tok_list_item' was declared
here
  struct ecryptfs_auth_tok_list_item *auth_tok_list_item;
                                      ^

GCC 9.2.0 was not able to pick up this warning when I tested it.

Turns out that Clang warns as well when -Wuninitialized is used, which
is not the case in older stable trees at the moment (but shows value in
potentially backporting the various warning fixes currently in upstream
to get more coverage).

fs/ecryptfs/keystore.c:1284:6: warning: variable 'auth_tok_list_item' is
used uninitialized whenever 'if' condition is true
[-Wsometimes-uninitialized]
        if (data[(*packet_size)++] != ECRYPTFS_TAG_1_PACKET_TYPE) {
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fs/ecryptfs/keystore.c:1360:4: note: uninitialized use occurs here
                        auth_tok_list_item);
                        ^~~~~~~~~~~~~~~~~~
fs/ecryptfs/keystore.c:1284:2: note: remove the 'if' if its condition is
always false
        if (data[(*packet_size)++] != ECRYPTFS_TAG_1_PACKET_TYPE) {
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fs/ecryptfs/keystore.c:1260:56: note: initialize the variable
'auth_tok_list_item' to silence this warning
        struct ecryptfs_auth_tok_list_item *auth_tok_list_item;
                                                              ^
                                                               = NULL
1 warning generated.

Somehow, commit fe2e082f5da5 ("ecryptfs: fix a memory leak bug in
parse_tag_1_packet()") upstream was not applied in the correct if block
in 4.4.215, 4.9.215, and 4.14.172, which will indeed lead to use of
uninitialized memory. Fix it up by undoing the bad backport in those
trees then reapplying the patch in the proper location.

Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ecryptfs/keystore.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1280,7 +1280,7 @@ parse_tag_1_packet(struct ecryptfs_crypt
 		printk(KERN_ERR "Enter w/ first byte != 0x%.2x\n",
 		       ECRYPTFS_TAG_1_PACKET_TYPE);
 		rc = -EINVAL;
-		goto out_free;
+		goto out;
 	}
 	/* Released: wipe_auth_tok_list called in ecryptfs_parse_packet_set or
 	 * at end of function upon failure */
@@ -1330,7 +1330,7 @@ parse_tag_1_packet(struct ecryptfs_crypt
 		printk(KERN_WARNING "Tag 1 packet contains key larger "
 		       "than ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES");
 		rc = -EINVAL;
-		goto out;
+		goto out_free;
 	}
 	memcpy((*new_auth_tok)->session_key.encrypted_key,
 	       &data[(*packet_size)], (body_size - (ECRYPTFS_SIG_SIZE + 2)));


