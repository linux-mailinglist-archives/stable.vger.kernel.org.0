Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E4729BD78
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811040AbgJ0Qgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:36:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802407AbgJ0PsR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:48:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B707A2065C;
        Tue, 27 Oct 2020 15:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813697;
        bh=k+cPmTeIbGQU95EpsKmgqLAHOubXZ/k+yM7N2m0h/YU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJcF7tUGgYdf1cZc5bR33M4fXK/ZNtzIcJrUU5vWL9tLNnWu7kpa5ETbgxWISw9H/
         WL03PeEcC7HU0B0srZ4q1+17B0Dc6OPuWrE4T6aYVB+NfEPfD/tK2LBDkVVSTbjdrY
         3mMhPREVXrgxF6w8sjAz7c47fNEQwrezqq3nedgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Grant <al.grant@foss.arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 638/757] perf: correct SNOOPX field offset
Date:   Tue, 27 Oct 2020 14:54:48 +0100
Message-Id: <20201027135520.487397739@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Grant <al.grant@foss.arm.com>

[ Upstream commit f3d301c1f2f5676465cdf3259737ea19cc82731f ]

perf_event.h has macros that define the field offsets in the
data_src bitmask in perf records. The SNOOPX and REMOTE offsets
were both 37. These are distinct fields, and the bitfield layout
in perf_mem_data_src confirms that SNOOPX should be at offset 38.

Fixes: 52839e653b5629bd ("perf tools: Add support for printing new mem_info encodings")
Signed-off-by: Al Grant <al.grant@foss.arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Link: https://lkml.kernel.org/r/4ac9f5cc-4388-b34a-9999-418a4099415d@foss.arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/perf_event.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 077e7ee69e3d8..b95d3c485d27e 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -1196,7 +1196,7 @@ union perf_mem_data_src {
 
 #define PERF_MEM_SNOOPX_FWD	0x01 /* forward */
 /* 1 free */
-#define PERF_MEM_SNOOPX_SHIFT	37
+#define PERF_MEM_SNOOPX_SHIFT  38
 
 /* locked instruction */
 #define PERF_MEM_LOCK_NA	0x01 /* not available */
-- 
2.25.1



