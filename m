Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84532ABCFF
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbgKINmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:42:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:55188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730549AbgKINBI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:01:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8FDA20789;
        Mon,  9 Nov 2020 13:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926867;
        bh=99OUfKmhEX8Y8oEVWQie1vocVS/5EWsoArtu+G30j/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Y5bfnbkrO3Bdp5PnVCU7K16yod3ChG8IH5au2GKYLV1Nkujy1ACEynEyMJxGrcXd
         PqN58xz54LdTntuvIoOoaJoIA6NIJdtfopSBpGNLQofTjc3OBGPRxNjBo9wEVtopf3
         GAuN/p+KsQP4Vytm+dn8Q9soOsNzbo+tqAFeifgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.9 014/117] fscrypt: use EEXIST when file already uses different policy
Date:   Mon,  9 Nov 2020 13:54:00 +0100
Message-Id: <20201109125026.326180094@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 8488cd96ff88966ccb076e4f3654f59d84ba686d upstream.

As part of an effort to clean up fscrypt-related error codes, make
FS_IOC_SET_ENCRYPTION_POLICY fail with EEXIST when the file already uses
a different encryption policy.  This is more descriptive than EINVAL,
which was ambiguous with some of the other error cases.

I am not aware of any users who might be relying on the previous error
code of EINVAL, which was never documented anywhere.

This failure case will be exercised by an xfstest.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 fs/crypto/policy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -131,7 +131,7 @@ int fscrypt_ioctl_set_policy(struct file
 		printk(KERN_WARNING
 		       "%s: Policy inconsistent with encryption context\n",
 		       __func__);
-		ret = -EINVAL;
+		ret = -EEXIST;
 	}
 
 	inode_unlock(inode);


