Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342F5353EEA
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238733AbhDEJIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:08:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238658AbhDEJIj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:08:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDA5561393;
        Mon,  5 Apr 2021 09:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613713;
        bh=4eEG1cSiehEqlu1PAct8oDkEDjtzotjqI7q4UfC9n8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ctGDpQ26kqffx+vFfAsw8k2i3/L6vMRPA+dtlGDSaLj4ht5Av8/pTYV1hAqRHhHy4
         apGwJyliNQnvkGEm9WX+PKDwCAzgu/l6A1OEllse9xIYBkf1YE83AtVdDsJfVOiN4G
         sPJ86KxjakgKxnptVgdGEapTsHIGoQQfmOQ4bvVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.10 063/126] xtensa: fix uaccess-related livelock in do_page_fault
Date:   Mon,  5 Apr 2021 10:53:45 +0200
Message-Id: <20210405085033.151157085@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

commit 7b9acbb6aad4f54623dcd4bd4b1a60fe0c727b09 upstream.

If a uaccess (e.g. get_user()) triggers a fault and there's a
fault signal pending, the handler will return to the uaccess without
having performed a uaccess fault fixup, and so the CPU will immediately
execute the uaccess instruction again, whereupon it will livelock
bouncing between that instruction and the fault handler.

https://lore.kernel.org/lkml/20210121123140.GD48431@C02TD0UTHF1T.local/

Cc: stable@vger.kernel.org
Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/mm/fault.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/xtensa/mm/fault.c
+++ b/arch/xtensa/mm/fault.c
@@ -112,8 +112,11 @@ good_area:
 	 */
 	fault = handle_mm_fault(vma, address, flags, regs);
 
-	if (fault_signal_pending(fault, regs))
+	if (fault_signal_pending(fault, regs)) {
+		if (!user_mode(regs))
+			goto bad_page_fault;
 		return;
+	}
 
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)


