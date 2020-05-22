Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A0E1DEAF5
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 16:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730821AbgEVO5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 10:57:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730744AbgEVOuf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 10:50:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A779022248;
        Fri, 22 May 2020 14:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159035;
        bh=dFnDNSHS2+OAHO0LGMtY8LKC5e1OPYAD0D0Dw5/i9t8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EsOQ1GTAJpxvNtaSaR1aamNI8/+/63EX3vvLgQtEgfwX50movQ89QQ4PNrv4gvVXv
         C9GsbjxTKWfK9MDkwH7UUUIhiZfRBP2Frr3cSOgehx81QDgOZQC8F0dMJvgEuSs050
         6s732rFcW/PwdpPbUDS4JSU9nG/ByUx5u+fnEEW0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liu Yibin <jiulong@linux.alibaba.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 32/41] csky: Fixup msa highest 3 bits mask
Date:   Fri, 22 May 2020 10:49:49 -0400
Message-Id: <20200522144959.434379-32-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522144959.434379-1-sashal@kernel.org>
References: <20200522144959.434379-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Yibin <jiulong@linux.alibaba.com>

[ Upstream commit 165f2d2858013253042809df082b8df7e34e86d7 ]

Just as comment mentioned, the msa format:

 cr<30/31, 15> MSA register format:
 31 - 29 | 28 - 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0
   BA     Reserved  SH  WA  B   SO SEC  C   D   V

So we should shift 29 bits not 28 bits for mask

Signed-off-by: Liu Yibin <jiulong@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/abiv1/inc/abi/entry.h | 4 ++--
 arch/csky/abiv2/inc/abi/entry.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/csky/abiv1/inc/abi/entry.h b/arch/csky/abiv1/inc/abi/entry.h
index 5056ebb902d1..61d94ec7dd16 100644
--- a/arch/csky/abiv1/inc/abi/entry.h
+++ b/arch/csky/abiv1/inc/abi/entry.h
@@ -167,8 +167,8 @@
 	 *   BA     Reserved  C   D   V
 	 */
 	cprcr	r6, cpcr30
-	lsri	r6, 28
-	lsli	r6, 28
+	lsri	r6, 29
+	lsli	r6, 29
 	addi	r6, 0xe
 	cpwcr	r6, cpcr30
 
diff --git a/arch/csky/abiv2/inc/abi/entry.h b/arch/csky/abiv2/inc/abi/entry.h
index 111973c6c713..9023828ede97 100644
--- a/arch/csky/abiv2/inc/abi/entry.h
+++ b/arch/csky/abiv2/inc/abi/entry.h
@@ -225,8 +225,8 @@
 	 */
 	mfcr	r6, cr<30, 15> /* Get MSA0 */
 2:
-	lsri	r6, 28
-	lsli	r6, 28
+	lsri	r6, 29
+	lsli	r6, 29
 	addi	r6, 0x1ce
 	mtcr	r6, cr<30, 15> /* Set MSA0 */
 
-- 
2.25.1

