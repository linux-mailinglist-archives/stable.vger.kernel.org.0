Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76B2D560C7
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbfFZDpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727672AbfFZDoz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:44:55 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-98.mobile.att.net [107.77.172.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F394205ED;
        Wed, 26 Jun 2019 03:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520694;
        bh=g1AqxlpC/K+EHPzuRDTLPzY8UiHg+nSu3duo6vExiaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pkf1agFENhP6yTkE6TcjhXVe4BZfl2Og867un3bnMqy/PDsUjTUqQNzJoXLR3Tgcj
         WjupB7nh/1eet1BcqlrMzBQOfjWhcHsaiPIZ+1E3CGwfeRmJhvL+cVrVCMHKc31gdQ
         5JSz50y5nu//nlqL5KbCczTRDu8e7XLm1erCtt9U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manuel Traut <manut@linutronix.de>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 30/34] scripts/decode_stacktrace.sh: prefix addr2line with $CROSS_COMPILE
Date:   Tue, 25 Jun 2019 23:43:31 -0400
Message-Id: <20190626034335.23767-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034335.23767-1-sashal@kernel.org>
References: <20190626034335.23767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manuel Traut <manut@linutronix.de>

[ Upstream commit c04e32e911653442fc834be6e92e072aeebe01a1 ]

At least for ARM64 kernels compiled with the crosstoolchain from
Debian/stretch or with the toolchain from kernel.org the line number is
not decoded correctly by 'decode_stacktrace.sh':

  $ echo "[  136.513051]  f1+0x0/0xc [kcrash]" | \
    CROSS_COMPILE=/opt/gcc-8.1.0-nolibc/aarch64-linux/bin/aarch64-linux- \
   ./scripts/decode_stacktrace.sh /scratch/linux-arm64/vmlinux \
                                  /scratch/linux-arm64 \
                                  /nfs/debian/lib/modules/4.20.0-devel
  [  136.513051] f1 (/linux/drivers/staging/kcrash/kcrash.c:68) kcrash

If addr2line from the toolchain is used the decoded line number is correct:

  [  136.513051] f1 (/linux/drivers/staging/kcrash/kcrash.c:57) kcrash

Link: http://lkml.kernel.org/r/20190527083425.3763-1-manut@linutronix.de
Signed-off-by: Manuel Traut <manut@linutronix.de>
Acked-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/decode_stacktrace.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/decode_stacktrace.sh b/scripts/decode_stacktrace.sh
index 98a7d63a723e..c4a9ddb174bc 100755
--- a/scripts/decode_stacktrace.sh
+++ b/scripts/decode_stacktrace.sh
@@ -66,7 +66,7 @@ parse_symbol() {
 	if [[ "${cache[$module,$address]+isset}" == "isset" ]]; then
 		local code=${cache[$module,$address]}
 	else
-		local code=$(addr2line -i -e "$objfile" "$address")
+		local code=$(${CROSS_COMPILE}addr2line -i -e "$objfile" "$address")
 		cache[$module,$address]=$code
 	fi
 
-- 
2.20.1

