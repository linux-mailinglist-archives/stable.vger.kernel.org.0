Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130D449A499
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369552AbiAYACJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449269AbiAXX2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7986FC01D7FA;
        Mon, 24 Jan 2022 13:31:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 183DD614E1;
        Mon, 24 Jan 2022 21:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F64C340E4;
        Mon, 24 Jan 2022 21:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059912;
        bh=JGviIA0qFo66pV1MrdQu8TN/MHhkm1Foo3NvPRqNvQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQ0KFCC9wxpwK8A4hfh/6TwuJkzoN4YvMH5sx8a/yamBNAt3k4CHHYJRmJaRl2CQf
         +EbqezRtoxt+WGNaMMXaupUfd+sR2Jq69lgnD785HnQzPgpoxkBuoMcTflUdZVcTvx
         nngA84ms4Oc50zjbiNE0fuMC0lNR/VLSRDGx9aqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dani Liberman <dliberman@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0777/1039] habanalabs: change wait for interrupt timeout to 64 bit
Date:   Mon, 24 Jan 2022 19:42:46 +0100
Message-Id: <20220124184151.409534616@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



