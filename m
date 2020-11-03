Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEA62A562B
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730526AbgKCVZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:25:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:39380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387614AbgKCVCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:02:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9762220658;
        Tue,  3 Nov 2020 21:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437340;
        bh=NCgEeXgIGtG26G81EP7Rjb5PupTf60OODIdNFZgVuYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ke4pVpumifRFuJA06vdJ+TMgX7AfGmt1vdggeQZt7lVQP4OU2/dPXL+hBC0uhiZjk
         nS3fFIteQ2GaAknP9gk0GMLl/sbgc4/z7s53LkpyhZlrL+QTNq+LxufidPQfi+xlAQ
         yJxUCO+MlB6X0SbZC4qnUvlB7UMmjdNS+wilAhX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org,
        Theodore Tso" <tytso@mit.edu>, Eric Biggers <ebiggers@google.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4.19 033/191] fscrypt: only set dentry_operations on ciphertext dentries
Date:   Tue,  3 Nov 2020 21:35:25 +0100
Message-Id: <20201103203237.007655514@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit d456a33f041af4b54f3ce495a86d00c246165032 upstream.

Plaintext dentries are always valid, so only set fscrypt_d_ops on
ciphertext dentries.

Besides marginally improved performance, this allows overlayfs to use an
fscrypt-encrypted upperdir, provided that all the following are true:

    (1) The fscrypt encryption key is placed in the keyring before
	mounting overlayfs, and remains while the overlayfs is mounted.

    (2) The overlayfs workdir uses the same encryption policy.

    (3) No dentries for the ciphertext names of subdirectories have been
	created in the upperdir or workdir yet.  (Since otherwise
	d_splice_alias() will reuse the old dentry with ->d_op set.)

One potential use case is using an ephemeral encryption key to encrypt
all files created or changed by a container, so that they can be
securely erased ("crypto-shredded") after the container stops.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/crypto/hooks.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -115,9 +115,8 @@ int __fscrypt_prepare_lookup(struct inod
 		spin_lock(&dentry->d_lock);
 		dentry->d_flags |= DCACHE_ENCRYPTED_NAME;
 		spin_unlock(&dentry->d_lock);
+		d_set_d_op(dentry, &fscrypt_d_ops);
 	}
-
-	d_set_d_op(dentry, &fscrypt_d_ops);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__fscrypt_prepare_lookup);


