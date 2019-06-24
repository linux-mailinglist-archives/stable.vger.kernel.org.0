Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 302D550849
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbfFXKQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:16:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730228AbfFXKQR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:16:17 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2861C205C9;
        Mon, 24 Jun 2019 10:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371376;
        bh=KrAKWW5IpsGHd1sDRLiz0BAsr+MVpsf80lL8mL0hDLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A82ehgmCwz/Eux2ovLwS4d7KIXF1EXzyW2hr68N4FQnmeuZsZxbO8W8I80ozJoBdv
         ffqf6w4MldkacDHK3yn44M1QUUk1+9bRY9P2pKw76DwpQb5qOixICv6ogEDoBc/DVE
         Ie6slJj8/nDq8rs/HASxmdiMre9v2h+FW3bK3Cgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Brauner <christian@brauner.io>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 081/121] tests: fix pidfd-test compilation
Date:   Mon, 24 Jun 2019 17:56:53 +0800
Message-Id: <20190624092324.997360765@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1fcd0eb356ad56c4e405f06e31dd9fde2109d5ab ]

Define __NR_pidfd_send_signal if it isn't to prevent a potential
compilation error.

To make pidfd-test compile on all arches, irrespective of whether
or not syscall numbers are assigned, define the syscall number to -1.
If it isn't defined this will cause the kernel to return -ENOSYS.

Fixes: 575a0ae9744d ("selftests: add tests for pidfd_send_signal()")
Signed-off-by: Christian Brauner <christian@brauner.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/pidfd/pidfd_test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/pidfd/pidfd_test.c b/tools/testing/selftests/pidfd/pidfd_test.c
index d59378a93782..20323f55613a 100644
--- a/tools/testing/selftests/pidfd/pidfd_test.c
+++ b/tools/testing/selftests/pidfd/pidfd_test.c
@@ -16,6 +16,10 @@
 
 #include "../kselftest.h"
 
+#ifndef __NR_pidfd_send_signal
+#define __NR_pidfd_send_signal -1
+#endif
+
 static inline int sys_pidfd_send_signal(int pidfd, int sig, siginfo_t *info,
 					unsigned int flags)
 {
-- 
2.20.1



