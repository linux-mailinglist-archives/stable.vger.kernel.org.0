Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DE3330DC3
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhCHMcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:32:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:40978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231804AbhCHMbv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:31:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2974651CC;
        Mon,  8 Mar 2021 12:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206711;
        bh=glepnS2PyHI4cIirF6sXbPDf6waIMx8obG42NtzmUmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GB2c7dsRnKaYGPq5Yta2wJK1n7MqSBWvGZAvN5v8Q4KtQ48w6VXaaf3AWdKGxuK16
         PzuhsG2fkL8hItPvzGOwl3ifneRz2aN2EI+AE3c0B1wSOTYb6TiJcBZbntiGyyqA9d
         ccHVqmC/VLwgc1rp80JLc4+1Ne8pr7oxnDK4xK5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Chen Jun <chenjun102@huawei.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 20/22] ftrace: Have recordmcount use w8 to read relp->r_info in arm64_is_fake_mcount
Date:   Mon,  8 Mar 2021 13:30:37 +0100
Message-Id: <20210308122715.374350160@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122714.391917404@linuxfoundation.org>
References: <20210308122714.391917404@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Jun <chenjun102@huawei.com>

[ Upstream commit 999340d51174ce4141dd723105d4cef872b13ee9 ]

On little endian system, Use aarch64_be(gcc v7.3) downloaded from
linaro.org to build image with CONFIG_CPU_BIG_ENDIAN = y,
CONFIG_FTRACE = y, CONFIG_DYNAMIC_FTRACE = y.

gcc will create symbols of _mcount but recordmcount can not create
mcount_loc for *.o.
aarch64_be-linux-gnu-objdump -r fs/namei.o | grep mcount
00000000000000d0 R_AARCH64_CALL26  _mcount
...
0000000000007190 R_AARCH64_CALL26  _mcount

The reason is than funciton arm64_is_fake_mcount can not work correctly.
A symbol of _mcount in *.o compiled with big endian compiler likes:
00 00 00 2d 00 00 01 1b
w(rp->r_info) will return 0x2d instead of 0x011b. Because w() takes
uint32_t as parameter, which truncates rp->r_info.

Use w8() instead w() to read relp->r_info

Link: https://lkml.kernel.org/r/20210222135840.56250-1-chenjun102@huawei.com

Fixes: ea0eada45632 ("recordmcount: only record relocation of type R_AARCH64_CALL26 on arm64.")
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Chen Jun <chenjun102@huawei.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/recordmcount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index b9c2ee7ab43f..cce12e1971d8 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -438,7 +438,7 @@ static int arm_is_fake_mcount(Elf32_Rel const *rp)
 
 static int arm64_is_fake_mcount(Elf64_Rel const *rp)
 {
-	return ELF64_R_TYPE(w(rp->r_info)) != R_AARCH64_CALL26;
+	return ELF64_R_TYPE(w8(rp->r_info)) != R_AARCH64_CALL26;
 }
 
 /* 64-bit EM_MIPS has weird ELF64_Rela.r_info.
-- 
2.30.1



