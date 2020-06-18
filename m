Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7911FE44F
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729607AbgFRBT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:19:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730203AbgFRBTv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:19:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47534221F3;
        Thu, 18 Jun 2020 01:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443186;
        bh=7M6z7fs61XZxQuQan2QJTeDa90sui9RkFFPu1DKBAzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/ZK264UmK+/dBsWKwD7vUwdd8lY3xg8mpBUlRsvM1WzDjrWx66wO6V8F5a1wBlKs
         63JwyYv9ifXQ8i5hFPqUBIex+fFnOGgZE051J6D2+9V8JUvviKq0hZL8gvmAalgnIu
         Ms8sXEZwQOAw6mHbZdoVhhEHcZMnuaKBvvvnMTl0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oded Gabbay <oded.gabbay@gmail.com>,
        Omer Shpigelman <oshpigelman@habana.ai>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 148/266] habanalabs: increase timeout during reset
Date:   Wed, 17 Jun 2020 21:14:33 -0400
Message-Id: <20200618011631.604574-148-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oded Gabbay <oded.gabbay@gmail.com>

[ Upstream commit 7a65ee046b2238e053f6ebb610e1a082cfc49490 ]

When doing training, the DL framework (e.g. tensorflow) performs hundreds
of thousands of memory allocations and mappings. In case the driver needs
to perform hard-reset during training, the driver kills the application and
unmaps all those memory allocations. Unfortunately, because of that large
amount of mappings, the driver isn't able to do that in the current timeout
(5 seconds). Therefore, increase the timeout significantly to 30 seconds
to avoid situation where the driver resets the device with active mappings,
which sometime can cause a kernel bug.

BTW, it doesn't mean we will spend all the 30 seconds because the reset
thread checks every one second if the unmap operation is done.

Reviewed-by: Omer Shpigelman <oshpigelman@habana.ai>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/habanalabs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/habanalabs/habanalabs.h b/drivers/misc/habanalabs/habanalabs.h
index 75862be53c60..30addffd76f5 100644
--- a/drivers/misc/habanalabs/habanalabs.h
+++ b/drivers/misc/habanalabs/habanalabs.h
@@ -23,7 +23,7 @@
 
 #define HL_MMAP_CB_MASK			(0x8000000000000000ull >> PAGE_SHIFT)
 
-#define HL_PENDING_RESET_PER_SEC	5
+#define HL_PENDING_RESET_PER_SEC	30
 
 #define HL_DEVICE_TIMEOUT_USEC		1000000 /* 1 s */
 
-- 
2.25.1

