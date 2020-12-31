Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DABA92E7F11
	for <lists+stable@lfdr.de>; Thu, 31 Dec 2020 10:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgLaJsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Dec 2020 04:48:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:50232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgLaJsf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 31 Dec 2020 04:48:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E10E2158C;
        Thu, 31 Dec 2020 09:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609408074;
        bh=JQ3ErFr/NlTtKlS43j3eInD/hGftEw13M74sikowFUM=;
        h=Subject:To:From:Date:From;
        b=ADL4RoppJylX/Nir0p1yCy3yC4D1j/yPTixSG3RLbh8npEmCyNoivVVVQ8W+yAnH9
         pOpNISFD0Bqiu3TcsDtNvWfSpcazPF/ORRKVKLssoK9pH9dh44ygYEgOzYMDiHskU1
         ejF1nXPZr8qtY2SpAktTvvgBCtg3Qkl1f2PGeB/g=
Subject: patch "crypto: asym_tpm: correct zero out potential secrets" added to char-misc-linus
To:     gregkh@linuxfoundation.org, ilil.blum.shem-tov@intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 31 Dec 2020 10:49:19 +0100
Message-ID: <1609408159201240@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    crypto: asym_tpm: correct zero out potential secrets

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f93274ef0fe972c120c96b3207f8fce376231a60 Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 4 Dec 2020 09:01:36 +0100
Subject: crypto: asym_tpm: correct zero out potential secrets

The function derive_pub_key() should be calling memzero_explicit()
instead of memset() in case the complier decides to optimize away the
call to memset() because it "knows" no one is going to touch the memory
anymore.

Cc: stable <stable@vger.kernel.org>
Reported-by: Ilil Blum Shem-Tov <ilil.blum.shem-tov@intel.com>
Tested-by: Ilil Blum Shem-Tov <ilil.blum.shem-tov@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/X8ns4AfwjKudpyfe@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/asymmetric_keys/asym_tpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/asym_tpm.c b/crypto/asymmetric_keys/asym_tpm.c
index 511932aa94a6..0959613560b9 100644
--- a/crypto/asymmetric_keys/asym_tpm.c
+++ b/crypto/asymmetric_keys/asym_tpm.c
@@ -354,7 +354,7 @@ static uint32_t derive_pub_key(const void *pub_key, uint32_t len, uint8_t *buf)
 	memcpy(cur, e, sizeof(e));
 	cur += sizeof(e);
 	/* Zero parameters to satisfy set_pub_key ABI. */
-	memset(cur, 0, SETKEY_PARAMS_SIZE);
+	memzero_explicit(cur, SETKEY_PARAMS_SIZE);
 
 	return cur - buf;
 }
-- 
2.30.0


