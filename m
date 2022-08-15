Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B918E594719
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354153AbiHOXoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354557AbiHOXm0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:42:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBD248EBE;
        Mon, 15 Aug 2022 13:13:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B385B80EAB;
        Mon, 15 Aug 2022 20:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8543C433C1;
        Mon, 15 Aug 2022 20:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594419;
        bh=6aBMzaqoaG5/pDLHyavSbk3RURz9kTZQdE3pp1Q3vSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9tvYZ+B3Fzt3+SLHyGIX+is8o7NtN7Qc9DMujxwgS9VFmEDDx3S9/LMAy3OGIGuI
         yx8IBIg9PIstsg5g4YhK6X+Ts7B0Jqp3EtHONG944SubmVej3BNtzqF4fttLc7rc3u
         gAMOZLYNXS/+AsMGX0qcIwA45dW9gcADZefVl+lE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 5.18 1085/1095] Revert "s390/smp: enforce lowcore protection on CPU restart"
Date:   Mon, 15 Aug 2022 20:08:04 +0200
Message-Id: <20220815180513.931633763@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
@@ -508,8 +508,8 @@ static void __init setup_lowcore_dat_on(
 	S390_lowcore.svc_new_psw.mask |= PSW_MASK_DAT;
 	S390_lowcore.program_new_psw.mask |= PSW_MASK_DAT;
 	S390_lowcore.io_new_psw.mask |= PSW_MASK_DAT;
-	__ctl_set_bit(0, 28);
 	__ctl_store(S390_lowcore.cregs_save_area, 0, 15);
+	__ctl_set_bit(0, 28);
 	put_abs_lowcore(restart_flags, RESTART_FLAG_CTLREGS);
 	put_abs_lowcore(program_new_psw, lc->program_new_psw);
 	for (cr = 0; cr < ARRAY_SIZE(lc->cregs_save_area); cr++)


