Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE5A35400B
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240623AbhDEJPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:15:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240479AbhDEJPL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:15:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C90261393;
        Mon,  5 Apr 2021 09:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614105;
        bh=OlbEFK3BpN3B46KeN0vztaAzXu3uxhzaVe32rMiOsJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nfIN1cfTVpn9k3nGrn006DhecT8tImrAwD0mcEYIoqLFlFgOrb0dxaVH3rjQDZlSt
         tRpA/gYKP9ww76GCtUmkPCUGw2PhIBIZFvt9zlybv62hPGagLBq+B4LURnjSWZw55U
         9kyyXGe1GPvLfb/1ET3zLrPlJICE0KXja9ep0YMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.11 085/152] s390/vdso: fix tod_steering_delta type
Date:   Mon,  5 Apr 2021 10:53:54 +0200
Message-Id: <20210405085037.018841144@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

commit b24bacd67ffddd9192c4745500fd6f73dbfe565e upstream.

The s390 specific vdso function __arch_get_hw_counter() is supposed to
consider tod clock steering.

If a tod clock steering event happens and the tod clock is set to a
new value __arch_get_hw_counter() will not return the real tod clock
value but slowly drift it from the old delta until the returned value
finally matches the real tod clock value again.

Unfortunately the type of tod_steering_delta unsigned while it is
supposed to be signed. It depends on if tod_steering_delta is negative
or positive in which direction the vdso code drifts the clock value.

Worst case is now that instead of drifting the clock slowly it will
jump into the opposite direction by a factor of two.

Fix this by simply making tod_steering_delta signed.

Fixes: 4bff8cb54502 ("s390: convert to GENERIC_VDSO")
Cc: <stable@vger.kernel.org> # 5.10
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/vdso/data.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/include/asm/vdso/data.h
+++ b/arch/s390/include/asm/vdso/data.h
@@ -6,7 +6,7 @@
 #include <vdso/datapage.h>
 
 struct arch_vdso_data {
-	__u64 tod_steering_delta;
+	__s64 tod_steering_delta;
 	__u64 tod_steering_end;
 };
 


