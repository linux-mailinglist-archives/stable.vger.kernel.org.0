Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9C229B71D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798619AbgJ0P3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:29:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798444AbgJ0P2A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:28:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAA91206E9;
        Tue, 27 Oct 2020 15:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812480;
        bh=+cwNwv6qjsb5YJODqEPijhAolfDeP6rDsLXPpxdyTWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PEOSRMr3Uy8Go+/uYWlG4aFPGtcD6z4IBdOtJ13GLNKGTMiEwZoPMxnZk/Qwa7Ssz
         Zf6q5t3aJjo6M2xtpmYZ2Cxuy/AoN7wO3tTwlFeBhjbWzu1ySyDgMQjxPM40+wgf1t
         n2r0U0JhcQ/lX7CFb32l8hA6A3+sBwsh+k+mLMJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anatoly Pugachev <matorola@gmail.com>,
        Jiri Kosina <trivial@kernel.org>,
        Shuah Khan <shuah@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 225/757] selftests: vm: add fragment CONFIG_GUP_BENCHMARK
Date:   Tue, 27 Oct 2020 14:47:55 +0100
Message-Id: <20201027135501.165835678@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anatoly Pugachev <matorola@gmail.com>

[ Upstream commit cae1d5a2c5a491141faa747e9944ba40ab4ab786 ]

When running gup_benchmark test the following output states that
the config options is missing.

$ sudo ./gup_benchmark
open: No such file or directory

$ sudo strace -e trace=file ./gup_benchmark 2>&1 | tail -3
openat(AT_FDCWD, "/sys/kernel/debug/gup_benchmark", O_RDWR) = -1 ENOENT
(No such file or directory)
open: No such file or directory
+++ exited with 1 +++

Fix it by adding config option fragment.

Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
Signed-off-by: Anatoly Pugachev <matorola@gmail.com>
CC: Jiri Kosina <trivial@kernel.org>
CC: Shuah Khan <shuah@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/vm/config b/tools/testing/selftests/vm/config
index 3ba674b64fa9f..69dd0d1aa30b2 100644
--- a/tools/testing/selftests/vm/config
+++ b/tools/testing/selftests/vm/config
@@ -3,3 +3,4 @@ CONFIG_USERFAULTFD=y
 CONFIG_TEST_VMALLOC=m
 CONFIG_DEVICE_PRIVATE=y
 CONFIG_TEST_HMM=m
+CONFIG_GUP_BENCHMARK=y
-- 
2.25.1



