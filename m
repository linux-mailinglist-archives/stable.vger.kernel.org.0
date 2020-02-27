Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A12C3171C89
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388933AbgB0ONC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:13:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:51852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729545AbgB0ONA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:13:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE3FD24690;
        Thu, 27 Feb 2020 14:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812780;
        bh=+Xbv5ReAxFmQEW1jkTzzswaOV3iBkq7ZlaBz9xuXs4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZvXsIEiGEf4hrEFT2il7GK+GcTRFkxlZdiPzk1z/PZmlqbqAQtRcjlFkPpLCP5UXW
         u0KyNGGKc/6bRdWQKhd1vD44iE04PnjX5jFkmndZ471/7SHyde17wSKUoVVkcQJZe3
         34IxhU2ygx+oZp8SO+8EVJUyy5tF7xn6Xse1pc4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Tyler Hicks <tyhicks@canonical.com>
Subject: [PATCH 5.5 014/150] ecryptfs: fix a memory leak bug in parse_tag_1_packet()
Date:   Thu, 27 Feb 2020 14:35:51 +0100
Message-Id: <20200227132234.778031974@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

commit fe2e082f5da5b4a0a92ae32978f81507ef37ec66 upstream.

In parse_tag_1_packet(), if tag 1 packet contains a key larger than
ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES, no cleanup is executed, leading to a
memory leak on the allocated 'auth_tok_list_item'. To fix this issue, go to
the label 'out_free' to perform the cleanup work.

Cc: stable@vger.kernel.org
Fixes: dddfa461fc89 ("[PATCH] eCryptfs: Public key; packet management")
Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/keystore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1304,7 +1304,7 @@ parse_tag_1_packet(struct ecryptfs_crypt
 		printk(KERN_WARNING "Tag 1 packet contains key larger "
 		       "than ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES\n");
 		rc = -EINVAL;
-		goto out;
+		goto out_free;
 	}
 	memcpy((*new_auth_tok)->session_key.encrypted_key,
 	       &data[(*packet_size)], (body_size - (ECRYPTFS_SIG_SIZE + 2)));


