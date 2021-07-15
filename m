Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1773CA64E
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236794AbhGOSrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:47:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238541AbhGOSrD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:47:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C550613D2;
        Thu, 15 Jul 2021 18:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374649;
        bh=M+F6BmugNILsthoEZGHxwsnnWekLE5M474umSlmbt+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MdkJSVvge4Shl5QgjCQN9XQL+1If+HOSsB94IAFOhGs/aXG9xLUFVCilj6cJhHvNG
         FpgjKnEbFi9Tz/m6Pd/FlNsJchYMrW81ASHVeQr7GxmWSu9B9+sdIx1D9tApsGGxn5
         Czmr5UFapjAyfP1EGXP8rEi0orILGAY0msDKfodg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.4 072/122] fscrypt: dont ignore minor_hash when hash is 0
Date:   Thu, 15 Jul 2021 20:38:39 +0200
Message-Id: <20210715182508.798967886@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
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
@@ -273,13 +273,8 @@ int fscrypt_fname_disk_to_usr(struct ino
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


