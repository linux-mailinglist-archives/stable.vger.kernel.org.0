Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6335D12EC80
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbgABWTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:19:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728547AbgABWTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:19:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C385321582;
        Thu,  2 Jan 2020 22:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003548;
        bh=8IWJOi6KRoy257bmHLGoFSeIOMVROHSJj/ROJ37nNPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tpz0HgDZwiQjSd5kcqVkj1thYnlQpvMU1sIouC0l8fKcy+WS+Zu6YvO2/f5RxLlW+
         YXAU5EaLOlOSmwdTYIRX+hQYhwwfRjXbUakKz7O9B4S8TTnosGKUVr/eJni+nLHwy1
         UWcEn9A5b7Q4l3/i9o1rJkwvTBy0KZthKafRtFwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 015/114] powerpc/tools: Dont quote $objdump in scripts
Date:   Thu,  2 Jan 2020 23:06:27 +0100
Message-Id: <20200102220030.654375518@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
References: <20200102220029.183913184@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit e44ff9ea8f4c8a90c82f7b85bd4f5e497c841960 ]

Some of our scripts are passed $objdump and then call it as
"$objdump". This doesn't work if it contains spaces because we're
using ccache, for example you get errors such as:

  ./arch/powerpc/tools/relocs_check.sh: line 48: ccache ppc64le-objdump: No such file or directory
  ./arch/powerpc/tools/unrel_branch_check.sh: line 26: ccache ppc64le-objdump: No such file or directory

Fix it by not quoting the string when we expand it, allowing the shell
to do the right thing for us.

Fixes: a71aa05e1416 ("powerpc: Convert relocs_check to a shell script using grep")
Fixes: 4ea80652dc75 ("powerpc/64s: Tool to flag direct branches from unrelocated interrupt vectors")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191024004730.32135-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/tools/relocs_check.sh       | 2 +-
 arch/powerpc/tools/unrel_branch_check.sh | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/tools/relocs_check.sh b/arch/powerpc/tools/relocs_check.sh
index ec2d5c835170..d6c16e7faa38 100755
--- a/arch/powerpc/tools/relocs_check.sh
+++ b/arch/powerpc/tools/relocs_check.sh
@@ -23,7 +23,7 @@ objdump="$1"
 vmlinux="$2"
 
 bad_relocs=$(
-"$objdump" -R "$vmlinux" |
+$objdump -R "$vmlinux" |
 	# Only look at relocation lines.
 	grep -E '\<R_' |
 	# These relocations are okay
diff --git a/arch/powerpc/tools/unrel_branch_check.sh b/arch/powerpc/tools/unrel_branch_check.sh
index 1e972df3107e..77114755dc6f 100755
--- a/arch/powerpc/tools/unrel_branch_check.sh
+++ b/arch/powerpc/tools/unrel_branch_check.sh
@@ -18,14 +18,14 @@ vmlinux="$2"
 #__end_interrupts should be located within the first 64K
 
 end_intr=0x$(
-"$objdump" -R "$vmlinux" -d --start-address=0xc000000000000000		\
+$objdump -R "$vmlinux" -d --start-address=0xc000000000000000           \
 		 --stop-address=0xc000000000010000 |
 grep '\<__end_interrupts>:' |
 awk '{print $1}'
 )
 
 BRANCHES=$(
-"$objdump" -R "$vmlinux" -D --start-address=0xc000000000000000		\
+$objdump -R "$vmlinux" -D --start-address=0xc000000000000000           \
 		--stop-address=${end_intr} |
 grep -e "^c[0-9a-f]*:[[:space:]]*\([0-9a-f][0-9a-f][[:space:]]\)\{4\}[[:space:]]*b" |
 grep -v '\<__start_initialization_multiplatform>' |
-- 
2.20.1



