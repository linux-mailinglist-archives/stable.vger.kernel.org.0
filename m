Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3CE593B98
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345812AbiHOUD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346264AbiHOUB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:01:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631037D1FE;
        Mon, 15 Aug 2022 11:54:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F904B810A4;
        Mon, 15 Aug 2022 18:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A99C433C1;
        Mon, 15 Aug 2022 18:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589642;
        bh=ADDZENk4U535ezQ9Bwf0xtyUCnQSO4AeE9KEO3JLlTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YX7EdM/54O/E7e8AeQWfyNCnpXNBFN9ITo6NhKYpy9vdWpuyGnL/bPDKJTnEc55SY
         GouvJuFIA50KuP5gvx7dVxEimtmYnCh0P7UjQ7+dtJSo6+Q8Xm3aj3+kCvrP71XK3p
         Yj2bSHTU0XGMTj2nht4j+vQB2QYkWpodQyL/tDcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 5.15 766/779] Revert "s390/smp: enforce lowcore protection on CPU restart"
Date:   Mon, 15 Aug 2022 20:06:50 +0200
Message-Id: <20220815180410.150840368@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alexander Gordeev <agordeev@linux.ibm.com>

commit 953503751a426413ea8aee2299ae3ee971b70d9b upstream.

This reverts commit 6f5c672d17f583b081e283927f5040f726c54598.

This breaks normal crash dump when CPU0 is offline.

Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -507,8 +507,8 @@ static void __init setup_lowcore_dat_on(
 	S390_lowcore.svc_new_psw.mask |= PSW_MASK_DAT;
 	S390_lowcore.program_new_psw.mask |= PSW_MASK_DAT;
 	S390_lowcore.io_new_psw.mask |= PSW_MASK_DAT;
-	__ctl_set_bit(0, 28);
 	__ctl_store(S390_lowcore.cregs_save_area, 0, 15);
+	__ctl_set_bit(0, 28);
 	put_abs_lowcore(restart_flags, RESTART_FLAG_CTLREGS);
 	put_abs_lowcore(program_new_psw, lc->program_new_psw);
 	for (cr = 0; cr < ARRAY_SIZE(lc->cregs_save_area); cr++)


