Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0143CDC9E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244809AbhGSOxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:53:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237759AbhGSOoY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:44:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2AE561287;
        Mon, 19 Jul 2021 15:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708155;
        bh=+cuDqX5PpSsMLKiVqFTjDpSLudQy9uoeZ1BfxJC7dc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hp6t3zssKIB5ceFTwvWIXR8sLXOr+ubgdaXbD1llJKfPIvNdHW38pQ12AUWcPRUsz
         DK/VKufIFEmb67rqcq135uwpqw3En6XIbaX68+IcPX8H9CZ5LRDhElKsXuiLlnWipt
         Re2QxFwfyg8KhwTc5D0RVz2xdIazP0R7qS2nisBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.14 202/315] fscrypt: dont ignore minor_hash when hash is 0
Date:   Mon, 19 Jul 2021 16:51:31 +0200
Message-Id: <20210719144950.070572738@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 77f30bfcfcf484da7208affd6a9e63406420bf91 upstream.

When initializing a no-key name, fscrypt_fname_disk_to_usr() sets the
minor_hash to 0 if the (major) hash is 0.

This doesn't make sense because 0 is a valid hash code, so we shouldn't
ignore the filesystem-provided minor_hash in that case.  Fix this by
removing the special case for 'hash == 0'.

This is an old bug that appears to have originated when the encryption
code in ext4 and f2fs was moved into fs/crypto/.  The original ext4 and
f2fs code passed the hash by pointer instead of by value.  So
'if (hash)' actually made sense then, as it was checking whether a
pointer was NULL.  But now the hashes are passed by value, and
filesystems just pass 0 for any hashes they don't have.  There is no
need to handle this any differently from the hashes actually being 0.

It is difficult to reproduce this bug, as it only made a difference in
the case where a filename's 32-bit major hash happened to be 0.
However, it probably had the largest chance of causing problems on
ubifs, since ubifs uses minor_hash to do lookups of no-key names, in
addition to using it as a readdir cookie.  ext4 only uses minor_hash as
a readdir cookie, and f2fs doesn't use minor_hash at all.

Fixes: 0b81d0779072 ("fs crypto: move per-file encryption from f2fs tree to fs/crypto")
Cc: <stable@vger.kernel.org> # v4.6+
Link: https://lore.kernel.org/r/20210527235236.2376556-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/crypto/fname.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -304,13 +304,8 @@ int fscrypt_fname_disk_to_usr(struct ino
 					   oname->name);
 		return 0;
 	}
-	if (hash) {
-		digested_name.hash = hash;
-		digested_name.minor_hash = minor_hash;
-	} else {
-		digested_name.hash = 0;
-		digested_name.minor_hash = 0;
-	}
+	digested_name.hash = hash;
+	digested_name.minor_hash = minor_hash;
 	memcpy(digested_name.digest,
 	       FSCRYPT_FNAME_DIGEST(iname->name, iname->len),
 	       FSCRYPT_FNAME_DIGEST_SIZE);


