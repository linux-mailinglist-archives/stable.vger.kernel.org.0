Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA890490D50
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241388AbiAQRCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:02:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48848 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241617AbiAQRBJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:01:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAE2DB8114E;
        Mon, 17 Jan 2022 17:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C492C36B01;
        Mon, 17 Jan 2022 17:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438866;
        bh=JGviIA0qFo66pV1MrdQu8TN/MHhkm1Foo3NvPRqNvQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HLpBZNJrvnEKGoEbn1GQl88NgEdVmEzKDqsqZmuTRoYheESZQng/odtHqAk5ZJ1gV
         kXjb+Q9RMB6pNHkwZh7diQoNrSD//NFiB1aPA/yRPJ8NTbv8T/cbXGHcQXXp+WZY/b
         4JTtsEhlrfaHQmgncdzBEhF0HoPHrnOtKVbkpxSy4kNhAc8QOzZSTQQHS5EgLq3TpN
         01uNfrSeq/dN+M7vCn3bdcPA0w1XaZedbnQ5yjcy5eaQUUoc1OSsP27BeJ5Xye2IZ6
         ngCG5LEPp6X3ARugXkd9Ttrrc4c+0gFu0EsM8NYRljHgRfjr6cctUCtWACIvrM7S+5
         2VhiMI70csCbg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dani Liberman <dliberman@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        obitton@habana.ai, osharabi@habana.ai, fkassabri@habana.ai
Subject: [PATCH AUTOSEL 5.16 47/52] habanalabs: change wait for interrupt timeout to 64 bit
Date:   Mon, 17 Jan 2022 11:58:48 -0500
Message-Id: <20220117165853.1470420-47-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117165853.1470420-1-sashal@kernel.org>
References: <20220117165853.1470420-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dani Liberman <dliberman@habana.ai>

[ Upstream commit 48f31169830f589e4c7ac475ccc7414951ded3f0 ]

In order to increase maximum wait-for-interrupt timeout, change it
to 64 bit variable. This wait is used only by newer ASICs, so no
problem in changing this interface at this time.

Signed-off-by: Dani Liberman <dliberman@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../habanalabs/common/command_submission.c    | 22 ++++++++++++++-----
 include/uapi/misc/habanalabs.h                | 18 +++++++++------
 2 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/misc/habanalabs/common/command_submission.c b/drivers/misc/habanalabs/common/command_submission.c
index 4c8000fd246cd..9451e4bae05df 100644
--- a/drivers/misc/habanalabs/common/command_submission.c
+++ b/drivers/misc/habanalabs/common/command_submission.c
@@ -2765,8 +2765,23 @@ static int hl_cs_wait_ioctl(struct hl_fpriv *hpriv, void *data)
 	return 0;
 }
 
+static inline unsigned long hl_usecs64_to_jiffies(const u64 usecs)
+{
+	if (usecs <= U32_MAX)
+		return usecs_to_jiffies(usecs);
+
+	/*
+	 * If the value in nanoseconds is larger than 64 bit, use the largest
+	 * 64 bit value.
+	 */
+	if (usecs >= ((u64)(U64_MAX / NSEC_PER_USEC)))
+		return nsecs_to_jiffies(U64_MAX);
+
+	return nsecs_to_jiffies(usecs * NSEC_PER_USEC);
+}
+
 static int _hl_interrupt_wait_ioctl(struct hl_device *hdev, struct hl_ctx *ctx,
-				u32 timeout_us, u64 user_address,
+				u64 timeout_us, u64 user_address,
 				u64 target_value, u16 interrupt_offset,
 				enum hl_cs_wait_status *status,
 				u64 *timestamp)
@@ -2778,10 +2793,7 @@ static int _hl_interrupt_wait_ioctl(struct hl_device *hdev, struct hl_ctx *ctx,
 	long completion_rc;
 	int rc = 0;
 
-	if (timeout_us == U32_MAX)
-		timeout = timeout_us;
-	else
-		timeout = usecs_to_jiffies(timeout_us);
+	timeout = hl_usecs64_to_jiffies(timeout_us);
 
 	hl_ctx_get(hdev, ctx);
 
diff --git a/include/uapi/misc/habanalabs.h b/include/uapi/misc/habanalabs.h
index 00b3095904995..c5760acebdd1d 100644
--- a/include/uapi/misc/habanalabs.h
+++ b/include/uapi/misc/habanalabs.h
@@ -911,14 +911,18 @@ struct hl_wait_cs_in {
 	 */
 	__u32 flags;
 
-	/* Multi CS API info- valid entries in multi-CS array */
-	__u8 seq_arr_len;
-	__u8 pad[3];
+	union {
+		struct {
+			/* Multi CS API info- valid entries in multi-CS array */
+			__u8 seq_arr_len;
+			__u8 pad[7];
+		};
 
-	/* Absolute timeout to wait for an interrupt in microseconds.
-	 * Relevant only when HL_WAIT_CS_FLAGS_INTERRUPT is set
-	 */
-	__u32 interrupt_timeout_us;
+		/* Absolute timeout to wait for an interrupt in microseconds.
+		 * Relevant only when HL_WAIT_CS_FLAGS_INTERRUPT is set
+		 */
+		__u64 interrupt_timeout_us;
+	};
 };
 
 #define HL_WAIT_CS_STATUS_COMPLETED	0
-- 
2.34.1

