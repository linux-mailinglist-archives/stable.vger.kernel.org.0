Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612B021F481
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 16:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbgGNOkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 10:40:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729226AbgGNOkE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 10:40:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C3512256F;
        Tue, 14 Jul 2020 14:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594737603;
        bh=sBlIDratQge2VL5mKrYyOWXeH5CBn8//65YLzsUrzDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZDb4RrsG1BtBiVb3lrVbq65gZyQJS3zcHD3M72RV5PbtsWLYa79Qn389YY8x4DLAB
         q50w+nhDH9XHb20ONdix5HdEV6e+9d18LRDuS8zwXAI0cU+o5Uwf/yahWL770kqIpe
         HwycL3UeJIUUmRDFcGNjXoObjWPAjT8iahSNSC0c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Filippov <jcmvbkbc@gmail.com>, Sasha Levin <sashal@kernel.org>,
        linux-xtensa@linux-xtensa.org
Subject: [PATCH AUTOSEL 4.14 07/12] xtensa: update *pos in cpuinfo_op.next
Date:   Tue, 14 Jul 2020 10:39:49 -0400
Message-Id: <20200714143954.4035840-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200714143954.4035840-1-sashal@kernel.org>
References: <20200714143954.4035840-1-sashal@kernel.org>
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
index 92fb20777bb0e..a19c61b261422 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -711,7 +711,8 @@ c_start(struct seq_file *f, loff_t *pos)
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

