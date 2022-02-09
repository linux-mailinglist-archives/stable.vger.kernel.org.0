Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6004AFD12
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 20:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiBITPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 14:15:40 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:42562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiBITPk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 14:15:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A783C1DC160;
        Wed,  9 Feb 2022 11:15:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76BF96193E;
        Wed,  9 Feb 2022 19:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54282C340E7;
        Wed,  9 Feb 2022 19:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644434103;
        bh=o6zUXEMGVaRSONjhKMI60+bcffn/pZstc2RF2pb50zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oApCKBWESrto9GTEb1LmB18BtpmUSnjeFbMoTqOU313aLM8Lzdg2+l6sl5sWUC1Sh
         JhplT6qLZtReh49wbkVe8JXJP2mfzZcQCuRadLSPg8Ie5/VzV+rn99KZTUbWRs/Olk
         siEO2DO6aSsB/r3BC/cOoqJtNjSK5Cft8Jc1AoYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, luofei <luofei@unicloud.com>
Subject: [PATCH 4.14 3/3] x86/mm, mm/hwpoison: Fix the unmap kernel 1:1 pages check condition
Date:   Wed,  9 Feb 2022 20:13:40 +0100
Message-Id: <20220209191248.771916077@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220209191248.659458918@linuxfoundation.org>
References: <20220209191248.659458918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: luofei <luofei@unicloud.com>

When fd0e786d9d09 ("x86/mm, mm/hwpoison: Don't unconditionally unmap
kernel 1:1 pages") was backported to 4.14.y, the logic was reversed when
calling memory_failure() to determine whether it needs to unmap the
kernel page. Only when memory_failure() returns successfully, the kernel
page can be unmapped.

Signed-off-by: luofei <luofei@unicloud.com>
Cc: stable@vger.kernel.org #v4.14.x
Cc: stable@vger.kernel.org #v4.15.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -589,7 +589,7 @@ static int srao_decode_notifier(struct n
 
 	if (mce_usable_address(mce) && (mce->severity == MCE_AO_SEVERITY)) {
 		pfn = mce->addr >> PAGE_SHIFT;
-		if (memory_failure(pfn, MCE_VECTOR, 0))
+		if (!memory_failure(pfn, MCE_VECTOR, 0))
 			mce_unmap_kpfn(pfn);
 	}
 


