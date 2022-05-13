Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9605264A5
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381058AbiEMOds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381055AbiEMOda (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:33:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C1760B88;
        Fri, 13 May 2022 07:29:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB00D621C6;
        Fri, 13 May 2022 14:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F92C34100;
        Fri, 13 May 2022 14:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452179;
        bh=8X+WJYGX4evt7FwMn+Tpb8JS2iA8r3USKECBfnlZTls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zxBJD5RAxT/5t346gFWOXRx9UoLu5eBO89B7LKtourwxKuo3aKy/xKTqIPowM7IDX
         I6t6/GPGtE28NPA2w1V0fAjla02AIZFfLNMaciYh2zd3QcLuLWT8xatOGZuW4NwFXb
         ehhkpDnq1IbZHY82hAzM/qay/7KtbhV0u3QfTWYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Youquan Song <youquan.song@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.17 09/12] mm/hwpoison: fix error page recovered but reported "not recovered"
Date:   Fri, 13 May 2022 16:24:09 +0200
Message-Id: <20220513142228.928817865@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142228.651822943@linuxfoundation.org>
References: <20220513142228.651822943@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 mm/memory-failure.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -707,8 +707,10 @@ static int kill_accessing_process(struct
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


