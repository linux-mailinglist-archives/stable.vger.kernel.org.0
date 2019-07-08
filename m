Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E425B62383
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387611AbfGHPf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:35:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390853AbfGHPfA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:35:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E0F4217D9;
        Mon,  8 Jul 2019 15:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562600099;
        bh=mRPp/zK5V6l69aHKM5b/TkXMBJAtLcfaKxPp1RIEfOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZRZc2/lX3pAJiuDj4Bxbz3m45Rl8oyLNsslPgEB8aZ26dmbYILM51gl4JP+46aCo
         ljKECYwerFHtOGB+4DbHg4Yqw0P606e9V60uyJCTIXG3JQ1oFbmBiymv3g5Radw0mZ
         fliyGkdL1M+ttX4FTod4umrzCMr4AcvkyTpxaEZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manuel Traut <manut@linutronix.de>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 51/96] scripts/decode_stacktrace.sh: prefix addr2line with $CROSS_COMPILE
Date:   Mon,  8 Jul 2019 17:13:23 +0200
Message-Id: <20190708150529.278685117@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index bcdd45df3f51..a7a36209a193 100755
--- a/scripts/decode_stacktrace.sh
+++ b/scripts/decode_stacktrace.sh
@@ -73,7 +73,7 @@ parse_symbol() {
 	if [[ "${cache[$module,$address]+isset}" == "isset" ]]; then
 		local code=${cache[$module,$address]}
 	else
-		local code=$(addr2line -i -e "$objfile" "$address")
+		local code=$(${CROSS_COMPILE}addr2line -i -e "$objfile" "$address")
 		cache[$module,$address]=$code
 	fi
 
-- 
2.20.1



