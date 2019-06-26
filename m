Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D158F560E3
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbfFZDtu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:49:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726912AbfFZDn0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:43:26 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DD1220659;
        Wed, 26 Jun 2019 03:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520605;
        bh=pvyaoqE/CGwLTREJutyweVUmIWowGZERg9Z0/N5L6U0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t7N7MOjlnYtf6U2LOuZ4Z2AXJOQ9vVJNYyOaPLC3kadYLA/by5JmuvzQxwUrbLpyt
         2Vmz1IMXxJf9QueOa4usU4S7m3q8prMtYvLewWPlsop/i5t/bq2l18hC1CIF9nkOLj
         dZLKCrFGRvIXQOA7rbHW7LdzgwKsxbs7yzzckiKI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manuel Traut <manut@linutronix.de>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 47/51] scripts/decode_stacktrace.sh: prefix addr2line with $CROSS_COMPILE
Date:   Tue, 25 Jun 2019 23:41:03 -0400
Message-Id: <20190626034117.23247-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034117.23247-1-sashal@kernel.org>
References: <20190626034117.23247-1-sashal@kernel.org>
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

