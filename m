Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 418DB83CD9
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfHFVqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:46:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726942AbfHFVd3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:33:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2958621743;
        Tue,  6 Aug 2019 21:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127208;
        bh=XY2QX3qJfoMkOIP+rWhBjSsKuOC6qblAAdm2SefGMC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y6eacG1rHP0NnlHgEWTeoanz4fUEYY/rBul+8XY56tUe2u4vO+p91fJFQI4zN99bY
         9lyfF+OX+M5wD3lSqsYM0DENwvGF+hJFDdc9wBHcq7G2Z6OYu+AAhWtSHusxlCwdN2
         6OmcJX9DRtM9+HibhHJAAvibpHWNOgA/DokslqTM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Filippov <jcmvbkbc@gmail.com>, Sasha Levin <sashal@kernel.org>,
        linux-xtensa@linux-xtensa.org
Subject: [PATCH AUTOSEL 5.2 07/59] xtensa: fix build for cores with coprocessors
Date:   Tue,  6 Aug 2019 17:32:27 -0400
Message-Id: <20190806213319.19203-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213319.19203-1-sashal@kernel.org>
References: <20190806213319.19203-1-sashal@kernel.org>
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
index 92bf24a9da929..e723129c36688 100644
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

