Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6873320E83D
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391836AbgF2WEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:04:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbgF2SfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E61C246B3;
        Mon, 29 Jun 2020 15:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444008;
        bh=5ZilBD8b4awJ7XRyq9tntI+OmekGDGgyK6digP59zWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCkvbJGFbiBANH7/FwctO1Z8OfhA5FwYLsgoIafDOe+hKjA/0Zzb2kx1vSpmTc6Vh
         ew8BOd7AIjfGIxvIMTuC/T3OUzH5VwI+VIXCEmgwspxDATy88p0BwRRkYentBJYjwU
         esMYfwgzau/bfostSp0v/NDQlZoGmysUB1ona0SM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philipp Fent <fent@in.tum.de>, Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 114/265] efi/libstub: Fix path separator regression
Date:   Mon, 29 Jun 2020 11:15:47 -0400
Message-Id: <20200629151818.2493727-115-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Fent <fent@in.tum.de>

[ Upstream commit 7a88a6227dc7f2e723bba11ece05e57bd8dce8e4 ]

Commit 9302c1bb8e47 ("efi/libstub: Rewrite file I/O routine") introduced a
regression that made a couple of (badly configured) systems fail to
boot [1]: Until 5.6, we silently accepted Unix-style file separators in
EFI paths, which might violate the EFI standard, but are an easy to make
mistake. This fix restores the pre-5.7 behaviour.

[1] https://bbs.archlinux.org/viewtopic.php?id=256273

Fixes: 9302c1bb8e47 ("efi/libstub: Rewrite file I/O routine")
Signed-off-by: Philipp Fent <fent@in.tum.de>
Link: https://lore.kernel.org/r/20200615115109.7823-1-fent@in.tum.de
[ardb: rewrite as chained if/else statements]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/file.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/libstub/file.c b/drivers/firmware/efi/libstub/file.c
index ea66b1f16a79d..f1c4faf58c764 100644
--- a/drivers/firmware/efi/libstub/file.c
+++ b/drivers/firmware/efi/libstub/file.c
@@ -104,12 +104,20 @@ static int find_file_option(const efi_char16_t *cmdline, int cmdline_len,
 	if (!found)
 		return 0;
 
+	/* Skip any leading slashes */
+	while (cmdline[i] == L'/' || cmdline[i] == L'\\')
+		i++;
+
 	while (--result_len > 0 && i < cmdline_len) {
-		if (cmdline[i] == L'\0' ||
-		    cmdline[i] == L'\n' ||
-		    cmdline[i] == L' ')
+		efi_char16_t c = cmdline[i++];
+
+		if (c == L'\0' || c == L'\n' || c == L' ')
 			break;
-		*result++ = cmdline[i++];
+		else if (c == L'/')
+			/* Replace UNIX dir separators with EFI standard ones */
+			*result++ = L'\\';
+		else
+			*result++ = c;
 	}
 	*result = L'\0';
 	return i;
-- 
2.25.1

