Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAB734C654
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhC2IGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:06:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231801AbhC2IFz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:05:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD3936197C;
        Mon, 29 Mar 2021 08:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005155;
        bh=9MQyLpCails/PN83xj+HAIVPTBA/Vb/18ZlIJRwSNJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2POH8oE4ZPgVq0VUXbEGxejUMICY4oX0eNH/SHs/kqIkHsVmsNKj2sOa744IpFUV
         cM4sAmTOk0ZDfbrpjJTpd4RX4nj2qiQG6Tlo5N+141N/VJgTySrOLVooR4BqogP7lz
         uTY831iG1Do2NGW3SD/EniEeD7ugIxVSBP0SWIvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Tatashin <pasha.tatashin@soleen.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 45/59] arm64: kdump: update ppos when reading elfcorehdr
Date:   Mon, 29 Mar 2021 09:58:25 +0200
Message-Id: <20210329075610.364027927@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
References: <20210329075608.898173317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Tatashin <pasha.tatashin@soleen.com>

[ Upstream commit 141f8202cfa4192c3af79b6cbd68e7760bb01b5a ]

The ppos points to a position in the old kernel memory (and in case of
arm64 in the crash kernel since elfcorehdr is passed as a segment). The
function should update the ppos by the amount that was read. This bug is
not exposed by accident, but other platforms update this value properly.
So, fix it in ARM64 version of elfcorehdr_read() as well.

Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Fixes: e62aaeac426a ("arm64: kdump: provide /proc/vmcore file")
Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Link: https://lore.kernel.org/r/20210319205054.743368-1-pasha.tatashin@soleen.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/crash_dump.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/crash_dump.c b/arch/arm64/kernel/crash_dump.c
index f46d57c31443..76905a258550 100644
--- a/arch/arm64/kernel/crash_dump.c
+++ b/arch/arm64/kernel/crash_dump.c
@@ -67,5 +67,7 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 ssize_t elfcorehdr_read(char *buf, size_t count, u64 *ppos)
 {
 	memcpy(buf, phys_to_virt((phys_addr_t)*ppos), count);
+	*ppos += count;
+
 	return count;
 }
-- 
2.30.1



