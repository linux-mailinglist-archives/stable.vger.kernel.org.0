Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A924F42DD19
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbhJNPEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232773AbhJNPDE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:03:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17EA861214;
        Thu, 14 Oct 2021 14:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223589;
        bh=QTt2i59o3hcholZQ93IdhnhqzxjeUOjWxaOVPdwi3Rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dEhAuq06PSufTGLGoxo9yAVXz32FsOILIaRhaWocorq/PJEy2sHVIKDJlpcDxUpun
         y8dYeDZRSYcPovmgKNrtqi6G4HtgI9G6zXli3bbwJDKqv8j4HXdhWCFpfcCNQ9rrpp
         u9OJbMNKiZ1Wi2exTsj+0mGXzmhG4sI4CHJeA3Go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 15/22] vboxfs: fix broken legacy mount signature checking
Date:   Thu, 14 Oct 2021 16:54:21 +0200
Message-Id: <20211014145208.479447819@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.979449962@linuxfoundation.org>
References: <20211014145207.979449962@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 9b3b353ef330e20bc2d99bf3165cc044cff26a09 ]

Commit 9d682ea6bcc7 ("vboxsf: Fix the check for the old binary
mount-arguments struct") was meant to fix a build error due to sign
mismatch in 'char' and the use of character constants, but it just moved
the error elsewhere, in that on some architectures characters and signed
and on others they are unsigned, and that's just how the C standard
works.

The proper fix is a simple "don't do that then".  The code was just
being silly and odd, and it should never have cared about signed vs
unsigned characters in the first place, since what it is testing is not
four "characters", but four bytes.

And the way to compare four bytes is by using "memcmp()".

Which compilers will know to just turn into a single 32-bit compare with
a constant, as long as you don't have crazy debug options enabled.

Link: https://lore.kernel.org/lkml/20210927094123.576521-1-arnd@kernel.org/
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/vboxsf/super.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/vboxsf/super.c b/fs/vboxsf/super.c
index d7816c01a4f6..c578e772cbd5 100644
--- a/fs/vboxsf/super.c
+++ b/fs/vboxsf/super.c
@@ -21,10 +21,7 @@
 
 #define VBOXSF_SUPER_MAGIC 0x786f4256 /* 'VBox' little endian */
 
-#define VBSF_MOUNT_SIGNATURE_BYTE_0 ('\000')
-#define VBSF_MOUNT_SIGNATURE_BYTE_1 ('\377')
-#define VBSF_MOUNT_SIGNATURE_BYTE_2 ('\376')
-#define VBSF_MOUNT_SIGNATURE_BYTE_3 ('\375')
+static const unsigned char VBSF_MOUNT_SIGNATURE[4] = "\000\377\376\375";
 
 static int follow_symlinks;
 module_param(follow_symlinks, int, 0444);
@@ -386,12 +383,7 @@ fail_nomem:
 
 static int vboxsf_parse_monolithic(struct fs_context *fc, void *data)
 {
-	unsigned char *options = data;
-
-	if (options && options[0] == VBSF_MOUNT_SIGNATURE_BYTE_0 &&
-		       options[1] == VBSF_MOUNT_SIGNATURE_BYTE_1 &&
-		       options[2] == VBSF_MOUNT_SIGNATURE_BYTE_2 &&
-		       options[3] == VBSF_MOUNT_SIGNATURE_BYTE_3) {
+	if (data && !memcmp(data, VBSF_MOUNT_SIGNATURE, 4)) {
 		vbg_err("vboxsf: Old binary mount data not supported, remove obsolete mount.vboxsf and/or update your VBoxService.\n");
 		return -EINVAL;
 	}
-- 
2.33.0



