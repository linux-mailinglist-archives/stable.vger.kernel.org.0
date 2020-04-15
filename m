Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B61E1AA12F
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369737AbgDOMeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:34:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409063AbgDOLoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:44:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 461AA214AF;
        Wed, 15 Apr 2020 11:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951052;
        bh=/irDkQP3S01BEZbw9nCn3Y6bK2sKx+ShTIuFgYre9FA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VqftkIhNL8i79/4Dwad+1yjvM63LLMvw25gLlTTKZQ7u8gioypnq/2+uCFI1wTZGD
         zRS6qliz316dvK8k4TV2Y5D9PvyHl0o3pmrByiwKqeTBbHKI0zKsqTCkggcQJdpV25
         rFTLITUNwSxODdEbiMgP+Vqp0uq12665oJWnfFVQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>, linux-um@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 086/106] um: falloc.h needs to be directly included for older libc
Date:   Wed, 15 Apr 2020 07:42:06 -0400
Message-Id: <20200415114226.13103-86-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit 35f3401317a3b26aa01fde8facfd320f2628fdcc ]

When building UML with glibc 2.17 installed, compilation
of arch/um/os-Linux/file.c fails due to failure to find
FALLOC_FL_PUNCH_HOLE and FALLOC_FL_KEEP_SIZE definitions.

It appears that /usr/include/bits/fcntl-linux.h (indirectly
included by /usr/include/fcntl.h) does not include falloc.h
with an older glibc, whereas a more up-to-date version
does.

Adding the direct include to file.c resolves the issue
and does not cause problems for more recent glibc.

Fixes: 50109b5a03b4 ("um: Add support for DISCARD in the UBD Driver")
Cc: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/os-Linux/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/um/os-Linux/file.c b/arch/um/os-Linux/file.c
index 5133e3afb96f7..3996937e2c0dd 100644
--- a/arch/um/os-Linux/file.c
+++ b/arch/um/os-Linux/file.c
@@ -8,6 +8,7 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <signal.h>
+#include <linux/falloc.h>
 #include <sys/ioctl.h>
 #include <sys/mount.h>
 #include <sys/socket.h>
-- 
2.20.1

