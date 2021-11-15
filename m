Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDCA6450E2B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240322AbhKOSNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:13:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:46098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240091AbhKOSFf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 830E763385;
        Mon, 15 Nov 2021 17:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998124;
        bh=5ZRyhR1sQ/XjuYxHdwM/gQ4abtkBchC2RBxuua8zseA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hieZAhzHra7Hw4VEi1CtiK3OL6z2pscgatbIf/SBmFc8ziFHz6VHskbmPr4EKvFaN
         L0ZOVc8XftbRj4BoAAfCZwUjpgPLNI/RReVNVT8dR3sJPd/0b7wIZHQIKVplXCzc4x
         bk+AKGtzb9N1g1++wl81tLNkJbIT4pIdRcOWvIww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 363/575] libbpf: Fix endianness detection in BPF_CORE_READ_BITFIELD_PROBED()
Date:   Mon, 15 Nov 2021 18:01:28 +0100
Message-Id: <20211115165356.359557579@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 4538ed762a209..f05cfc082915d 100644
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



