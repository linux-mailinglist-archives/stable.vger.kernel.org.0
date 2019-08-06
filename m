Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E0C83BC3
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbfHFVhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:37:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729525AbfHFVhw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:37:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A074D21874;
        Tue,  6 Aug 2019 21:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127471;
        bh=bciCVAO771nWd3gcn770/n2Rb6usypvaCcgPlLxEQ58=;
        h=From:To:Cc:Subject:Date:From;
        b=LzPVLC186TZSh+QRWSP8aTLXnXkh8CrHPOnH3rrZoPYm+skP3SarGBy7RbpKhXFNa
         kVBHvt5pOd0F7Gl812+x/+UOBnqYfl3MaznlxVTIixpD3EeNenpkCxQ0/5FgkPJrA4
         fV+rWTN60E3RIWMvQkM3IGHrwxLAGpdWduUBln94=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Filippov <jcmvbkbc@gmail.com>, Sasha Levin <sashal@kernel.org>,
        linux-xtensa@linux-xtensa.org
Subject: [PATCH AUTOSEL 4.4 01/14] xtensa: fix build for cores with coprocessors
Date:   Tue,  6 Aug 2019 17:37:35 -0400
Message-Id: <20190806213749.20689-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

[ Upstream commit e3cacb73e626d885b8cf24103fed0ae26518e3c4 ]

Assembly entry/return abstraction change didn't add asmmacro.h include
statement to coprocessor.S, resulting in references to undefined macros
abi_entry and abi_ret on cores that define XTENSA_HAVE_COPROCESSORS.
Fix that by including asm/asmmacro.h from the coprocessor.S.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/kernel/coprocessor.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/xtensa/kernel/coprocessor.S b/arch/xtensa/kernel/coprocessor.S
index a482df5df2b2c..c5d6285201252 100644
--- a/arch/xtensa/kernel/coprocessor.S
+++ b/arch/xtensa/kernel/coprocessor.S
@@ -14,6 +14,7 @@
 
 #include <linux/linkage.h>
 #include <asm/asm-offsets.h>
+#include <asm/asmmacro.h>
 #include <asm/processor.h>
 #include <asm/coprocessor.h>
 #include <asm/thread_info.h>
-- 
2.20.1

