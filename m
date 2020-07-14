Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C8021F4A8
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 16:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgGNOk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 10:40:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729381AbgGNOka (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 10:40:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EBE322224;
        Tue, 14 Jul 2020 14:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594737630;
        bh=E8GGfYTP6aEG4HFq9D6Klka2eaIy5f/oaUK+llhHQ/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZN/9Xtzd86l0UPD1FsvB6Dmt6Sw17CkYSsk0A4TVG0okezCX8yo18QlguhXiQq+8k
         qdwhABXoxIgzadpwqd3SLvH60PTssrr2qpvIzA9BoZtaMtWRKOAR+KUl6wdzdMP36g
         2enXb35Bi9xXvk9rLLHThovIXvOETXQciibphHHM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Filippov <jcmvbkbc@gmail.com>, Sasha Levin <sashal@kernel.org>,
        linux-xtensa@linux-xtensa.org
Subject: [PATCH AUTOSEL 4.4 5/9] xtensa: update *pos in cpuinfo_op.next
Date:   Tue, 14 Jul 2020 10:40:19 -0400
Message-Id: <20200714144024.4036118-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200714144024.4036118-1-sashal@kernel.org>
References: <20200714144024.4036118-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

[ Upstream commit 0d5ab144429e8bd80889b856a44d56ab4a5cd59b ]

Increment *pos in the cpuinfo_op.next to fix the following warning
triggered by cat /proc/cpuinfo:

  seq_file: buggy .next function c_next did not update position index

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/kernel/setup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index 49ccbd9022f61..92f5a259e2517 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -716,7 +716,8 @@ c_start(struct seq_file *f, loff_t *pos)
 static void *
 c_next(struct seq_file *f, void *v, loff_t *pos)
 {
-	return NULL;
+	++*pos;
+	return c_start(f, pos);
 }
 
 static void
-- 
2.25.1

