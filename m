Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9AE95138DA
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 17:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349502AbiD1Pqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 11:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349527AbiD1PqZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 11:46:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027B7B3DEE;
        Thu, 28 Apr 2022 08:43:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D537B82DE9;
        Thu, 28 Apr 2022 15:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE14C385A0;
        Thu, 28 Apr 2022 15:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651160587;
        bh=oOTTQiTXbJJNutl+GtVstgkF+NXnhIxj+Hxg+8AQ8Dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OB2EQAs7PyVqpxi2Lfaj07HXTncbkkVCdkHQG/FCb6oyCw3J+usQafXGEpe/99sjo
         MAmMZSIGmZHNWnris5ZiucTCq0I9vyevcAcc2wAfuXoSR0mlJKQelJwcSG5dXX8vxv
         P5xcrr6X1UhcXclL0imLtWu3a4M8OfrnNXGitVxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Youquan Song <youquan.song@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH AUTOSEL 09/14] mm/hwpoison: fix error page recovered but reported "not recovered"
Date:   Thu, 28 Apr 2022 17:42:17 +0200
Message-Id: <20220428154222.1230793-9-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
References: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2501; i=gregkh@linuxfoundation.org; h=from:subject; bh=fS6eim227H0Y5MlY1k72kHj4DPyJTiatgbOo3atAeao=; b=owGbwMvMwCRo6H6F97bub03G02pJDElZW+8Wz+d9/WHfovv3719Yo7xhQeOqzbzx5xPCv+2+NWnd QbHUWR2xLAyCTAyyYoosX7bxHN1fcUjRy9D2NMwcViaQIQxcnAIwkSlNDPMsNZcaznmwME66YNryrJ xJy7J4dRUY5ln/sgpvOsDQVqO6o7P2c76epnZ9OAA=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naoya Horiguchi <naoya.horiguchi@nec.com>

commit 046545a661af2beec21de7b90ca0e35f05088a81 upstream.

When an uncorrected memory error is consumed there is a race between the
CMCI from the memory controller reporting an uncorrected error with a
UCNA signature, and the core reporting and SRAR signature machine check
when the data is about to be consumed.

If the CMCI wins that race, the page is marked poisoned when
uc_decode_notifier() calls memory_failure() and the machine check
processing code finds the page already poisoned.  It calls
kill_accessing_process() to make sure a SIGBUS is sent.  But returns the
wrong error code.

Console log looks like this:

  mce: Uncorrected hardware memory error in user-access at 3710b3400
  Memory failure: 0x3710b3: recovery action for dirty LRU page: Recovered
  Memory failure: 0x3710b3: already hardware poisoned
  Memory failure: 0x3710b3: Sending SIGBUS to einj_mem_uc:361438 due to hardware memory corruption
  mce: Memory error not recovered

kill_accessing_process() is supposed to return -EHWPOISON to notify that
SIGBUS is already set to the process and kill_me_maybe() doesn't have to
send it again.  But current code simply fails to do this, so fix it to
make sure to work as intended.  This change avoids the noise message
"Memory error not recovered" and skips duplicate SIGBUSs.

[tony.luck@intel.com: reword some parts of commit message]

Link: https://lkml.kernel.org/r/20220113231117.1021405-1-naoya.horiguchi@linux.dev
Fixes: a3f5d80ea401 ("mm,hwpoison: send SIGBUS with error virutal address")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: Youquan Song <youquan.song@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 15dcedbc1730..682eedb5ea75 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -707,8 +707,10 @@ static int kill_accessing_process(struct task_struct *p, unsigned long pfn,
 			      (void *)&priv);
 	if (ret == 1 && priv.tk.addr)
 		kill_proc(&priv.tk, pfn, flags);
+	else
+		ret = 0;
 	mmap_read_unlock(p->mm);
-	return ret ? -EFAULT : -EHWPOISON;
+	return ret > 0 ? -EHWPOISON : -EFAULT;
 }
 
 static const char *action_name[] = {
-- 
2.36.0

