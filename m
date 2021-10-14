Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609F342DD61
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbhJNPGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:06:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233764AbhJNPFC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:05:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70409611ED;
        Thu, 14 Oct 2021 15:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223668;
        bh=h1r+01+bF1W4rNRlzlINU1xqjPxqNBGPgJfiX6Iw/Y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RaRkowWgCT89vau3O2yc/jJuJpmbkknNC3kps8sK9cjnuznbKw3GU743GZnKtt+XU
         s68TjYYpO/ST0e/49tOxcREedGdo4s506iYjya2v1hT0EEBlqzX41yqFdHBANtvfyI
         bw5zfgyFNiHLHxwPLmM/qmOVK1NwR+pjPbY9OA64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 21/30] vboxfs: fix broken legacy mount signature checking
Date:   Thu, 14 Oct 2021 16:54:26 +0200
Message-Id: <20211014145210.226999653@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145209.520017940@linuxfoundation.org>
References: <20211014145209.520017940@linuxfoundation.org>
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
index 4f5e59f06284..37dd3fe5b1e9 100644
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



