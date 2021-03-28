Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694F834BA88
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 05:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhC1DTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Mar 2021 23:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbhC1DTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Mar 2021 23:19:08 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C465CC0613B1;
        Sat, 27 Mar 2021 20:19:07 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id i6so38664pgs.1;
        Sat, 27 Mar 2021 20:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RDTKvBCVKjC/zYD9EfD0mis7wtW44rX7PdGU3QAJOQI=;
        b=KUxwJzYMAjcWXqiyybqPQmni8ZusZ2fRqGbTKJ5dmZnkXw6k6rVxLcrAjQFNE3GKf1
         VS4oU9F3yN0124Zo84apcURnk2Mh8JV/SBn5q4pqz1EdBMP5o5Tdz5o+Y/va+PVNOyFN
         KDYTU2ujAVt9IX+dhAT9DuGL3aNyEgvNLE3mh4r+OD7MuFuvyb5pfa8dmgh3zE5WEiOC
         +75C1ogiizG0L6a8cjW2o6I80mNAXzBFJi2HltlUt4+VCin5ohSDge7q2KLGqIib5uDS
         2bXPFadLb0Nit2KTyKSDhOoOLzURyA9N4wZGdDlagSWiy4OMfkMxzBW649y0bBKZHWDm
         RqPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RDTKvBCVKjC/zYD9EfD0mis7wtW44rX7PdGU3QAJOQI=;
        b=JbXSL3TAxHS67ebc1HC63MFJ5ScQ0qg01iTeo7SnGX6pfR2ZXK2bsR36bwCezhgrfZ
         ouA3fiQ7FvKEQvuLw0KF78NfuE+jidRVYBV/XPA4agr4a03uDBEC7N7BQ53MTczwBvyQ
         uBNu6HcUCF/PbAPvzpuNf5Gtd5osLzQgS6XdEPZ9tnlm/iUtmpUJxN8G/OhNyrjo7LAx
         yZqUVXTa1UE5ouUZr9R4E2lIlU2KwNIbnSO9GAFvAMTaBO7bD8qvvS3Ign5sC7q47Ir5
         zsHLSKbMVCcbGpMWlEabSfOfaVrhdhwkKNTiwcnTr/X6hD7bcCyOBcmK408W7hF1+S2d
         3x4g==
X-Gm-Message-State: AOAM531um+aOVT5B7kZYkCEIssTjmzZGf5aQjQHVrIurDFYTf9eUyr2C
        jwgwo1rX2Y6AbLGEHZCn7d/lnoRCj04=
X-Google-Smtp-Source: ABdhPJzPYD1/1R/laSJC/8BtJU58yNv0hciWN9qdxavWp/hYaPcA4DtCPROgjC3u6WmvbIv7+sSDeQ==
X-Received: by 2002:a65:41c7:: with SMTP id b7mr12091838pgq.237.1616901547050;
        Sat, 27 Mar 2021 20:19:07 -0700 (PDT)
Received: from octofox.hsd1.ca.comcast.net ([2601:641:400:9e10:2d94:bd34:41ff:d945])
        by smtp.gmail.com with ESMTPSA id w1sm12523998pgs.15.2021.03.27.20.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Mar 2021 20:19:06 -0700 (PDT)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>, stable@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH] xtensa: fix uaccess-related livelock in do_page_fault
Date:   Sat, 27 Mar 2021 20:18:48 -0700
Message-Id: <20210328031848.8755-1-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If a uaccess (e.g. get_user()) triggers a fault and there's a
fault signal pending, the handler will return to the uaccess without
having performed a uaccess fault fixup, and so the CPU will immediately
execute the uaccess instruction again, whereupon it will livelock
bouncing between that instruction and the fault handler.

https://lore.kernel.org/lkml/20210121123140.GD48431@C02TD0UTHF1T.local/

Cc: stable@vger.kernel.org
Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/mm/fault.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/xtensa/mm/fault.c b/arch/xtensa/mm/fault.c
index 7666408ce12a..95a74890c7e9 100644
--- a/arch/xtensa/mm/fault.c
+++ b/arch/xtensa/mm/fault.c
@@ -112,8 +112,11 @@ void do_page_fault(struct pt_regs *regs)
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
-- 
2.20.1

