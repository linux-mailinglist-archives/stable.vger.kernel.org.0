Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B1734C79F
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhC2IQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232900AbhC2IPT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:15:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F44561964;
        Mon, 29 Mar 2021 08:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005705;
        bh=X37DBp6Ormim7xfW0XxjlYmJjt/SCXjIhAHFNaJKq0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jKJ56Y40XZDQSMQXCCuqQs0g5kTGVFx8RxosjYp/sGhLGHsTaFMv+s+5W1cjFSGJa
         qbTQN/ZO/8jGUduVB4pgR1Au1kXzbRGpmNL7aGXcs6OjKcoxXlOIXN/3gyEDrCkBza
         QkDH8AnbFxuFgT5f4r2zEn+y87oDUNoUni8Ago+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Tatashin <pasha.tatashin@soleen.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 088/111] arm64: kdump: update ppos when reading elfcorehdr
Date:   Mon, 29 Mar 2021 09:58:36 +0200
Message-Id: <20210329075618.142259406@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
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
index e6e284265f19..58303a9ec32c 100644
--- a/arch/arm64/kernel/crash_dump.c
+++ b/arch/arm64/kernel/crash_dump.c
@@ -64,5 +64,7 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 ssize_t elfcorehdr_read(char *buf, size_t count, u64 *ppos)
 {
 	memcpy(buf, phys_to_virt((phys_addr_t)*ppos), count);
+	*ppos += count;
+
 	return count;
 }
-- 
2.30.1



