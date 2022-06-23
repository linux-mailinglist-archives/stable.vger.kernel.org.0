Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D2F558705
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236931AbiFWSTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237331AbiFWSSN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:18:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93546B628E;
        Thu, 23 Jun 2022 10:24:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 166D2B82497;
        Thu, 23 Jun 2022 17:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FE4C341C4;
        Thu, 23 Jun 2022 17:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656005075;
        bh=GJjPzaE1Xp4leBAxjdOS0+AqdSMbVLMu+pd/8Sgp3ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tu+8pbMaDgg++sYzcFDKGXk2ltF/7lgXlG+aqgGX24VIFDaHhUWm6kDDhvAkiBl7n
         JbtCZ1b9hTfaQTiPv5LPmYO+uC9hAJMkXwnMvyUov12na4q62QqHDqtT+AVg8lad3X
         ivD9VEpvAm1IiMzcWFNSPWemLY1sUa5DRNtB76M0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.4 01/11] s390/mm: use non-quiescing sske for KVM switch to keyed guest
Date:   Thu, 23 Jun 2022 18:45:05 +0200
Message-Id: <20220623164321.239935415@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164321.195163701@linuxfoundation.org>
References: <20220623164321.195163701@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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

From: Christian Borntraeger <borntraeger@linux.ibm.com>

commit 3ae11dbcfac906a8c3a480e98660a823130dc16a upstream.

The switch to a keyed guest does not require a classic sske as the other
guest CPUs are not accessing the key before the switch is complete.
By using the NQ SSKE things are faster especially with multiple guests.

Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Suggested-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20220530092706.11637-3-borntraeger@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/pgtable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -716,7 +716,7 @@ void ptep_zap_key(struct mm_struct *mm,
 	pgste_val(pgste) |= PGSTE_GR_BIT | PGSTE_GC_BIT;
 	ptev = pte_val(*ptep);
 	if (!(ptev & _PAGE_INVALID) && (ptev & _PAGE_WRITE))
-		page_set_storage_key(ptev & PAGE_MASK, PAGE_DEFAULT_KEY, 1);
+		page_set_storage_key(ptev & PAGE_MASK, PAGE_DEFAULT_KEY, 0);
 	pgste_set_unlock(ptep, pgste);
 	preempt_enable();
 }


