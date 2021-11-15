Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E468F4513F4
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348792AbhKOT75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:59:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344148AbhKOTXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F0DD63639;
        Mon, 15 Nov 2021 18:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002366;
        bh=qQjTWBBKkkXc5wVQqANwUpgKMvtUSX+JFcNiZiipAMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EAUWNBiuBoHfkmV64b2h0+8UvoonRyE9WDQQjQiy/5WiFOxdlEclL/kK0e4XEBBCT
         s3+is2s0EyUvWCsR8/uFl1IDvt2C80d/9Mbkj1bcFaYKe3NOnPcBcTAsUag6dv5TPR
         82Ups8Gvx0kLCSAbOXeSYvfmYRaPasb/A1dI51bk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 522/917] libbpf: Fix endianness detection in BPF_CORE_READ_BITFIELD_PROBED()
Date:   Mon, 15 Nov 2021 18:00:17 +0100
Message-Id: <20211115165446.464988910@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 45f2bebc8079788f62f22d9e8b2819afb1789d7b ]

__BYTE_ORDER is supposed to be defined by a libc, and __BYTE_ORDER__ -
by a compiler. bpf_core_read.h checks __BYTE_ORDER == __LITTLE_ENDIAN,
which is true if neither are defined, leading to incorrect behavior on
big-endian hosts if libc headers are not included, which is often the
case.

Fixes: ee26dade0e3b ("libbpf: Add support for relocatable bitfields")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20211026010831.748682-2-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf_core_read.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.h
index 09ebe3db5f2f8..e4aa9996a5501 100644
--- a/tools/lib/bpf/bpf_core_read.h
+++ b/tools/lib/bpf/bpf_core_read.h
@@ -40,7 +40,7 @@ enum bpf_enum_value_kind {
 #define __CORE_RELO(src, field, info)					      \
 	__builtin_preserve_field_info((src)->field, BPF_FIELD_##info)
 
-#if __BYTE_ORDER == __LITTLE_ENDIAN
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
 #define __CORE_BITFIELD_PROBE_READ(dst, src, fld)			      \
 	bpf_probe_read_kernel(						      \
 			(void *)dst,				      \
-- 
2.33.0



