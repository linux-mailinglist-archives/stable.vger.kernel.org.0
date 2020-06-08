Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003541F2C23
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731723AbgFIAVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730538AbgFHXRx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:17:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A00CF2085B;
        Mon,  8 Jun 2020 23:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658273;
        bh=dFnDNSHS2+OAHO0LGMtY8LKC5e1OPYAD0D0Dw5/i9t8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r8CCl1UmXpo4iTzv9wshBjKFxVk3yzmx2Vfn3CTs5PHRU2zjxtCgS5+7NetG5pX8G
         tvGtj8HMma7BgpU9C99IKlE8dIMngUIHy4iqnZZg0eXrD+l5yBqCieURFQFRywctwR
         V8E8i1c93JUPQ5r6Ri4ZMKH1Uu1HmQADoZ5Jzhw8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liu Yibin <jiulong@linux.alibaba.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>, linux-csky@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 279/606] csky: Fixup msa highest 3 bits mask
Date:   Mon,  8 Jun 2020 19:06:44 -0400
Message-Id: <20200608231211.3363633-279-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
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

