Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258D84228E2
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbhJENyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:54:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:32832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235680AbhJENxI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:53:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D7C2617E3;
        Tue,  5 Oct 2021 13:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441878;
        bh=eQyrhUBqAGxOp4OQ8SRKA+qeUo7Jb3TpkpwhaY0OqBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NGcZ5oGZfXUCQjK/0b7aKMyGc0sAMDFizgFX3U780Vpan5yIEE/Qazjsy91++qT/x
         av6mNFIjXk+mf+F1G0Blc1rfjo8olSBZYYHEd9foEMpvDaHZDOrWJg7HL48cG/0LSr
         j3hY23MiV+kSD+rCsE4vYxA6sq0qKGg0cTr6tHlmhoVsfvSvoUOhpNo60u/NIOZXB9
         bhXIDoyWLrpjA2gkR8jHxiz1V6P6nyAUclJvkWs2pd9CyY6AaZlnB2KaTjDueJftUj
         2nq/DTMgPMoTorOsif+hTdhtv897KeDw1o/T+z9U36ncrI8GXVUyTvJ7EOiqqkuXrh
         jrT3+lLNee80A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 30/40] vboxfs: fix broken legacy mount signature checking
Date:   Tue,  5 Oct 2021 09:50:09 -0400
Message-Id: <20211005135020.214291-30-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
@@ -386,12 +383,7 @@ static int vboxsf_setup(void)
 
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

