Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222494BE827
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347036AbiBUJDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:03:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348285AbiBUJCh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:02:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC2A2BB2A;
        Mon, 21 Feb 2022 00:57:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 325F761222;
        Mon, 21 Feb 2022 08:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15890C340E9;
        Mon, 21 Feb 2022 08:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433870;
        bh=ASK1MwfeL/CNuiui8+LcMzQGd1hoU+FW4p1Qlh7aswc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=khI57OgDHUSYCpZK8cXxjvGmWjeDmdWfU5S0KlFfuEkUQv8eZQ7A5wwVyqIlmVenH
         lBqZaVFa9QowWrh5LeX6X8ueq9aUOADPBJzqAjjdY+t3AMKf/uI9pQgpFzUXFyPEgd
         nzDpyQEWqMtQuchqsr01NPfU8Hc/mAHfVcyVWO5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 03/80] Revert "svm: Add warning message for AVIC IPI invalid target"
Date:   Mon, 21 Feb 2022 09:48:43 +0100
Message-Id: <20220221084915.677311913@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084915.554151737@linuxfoundation.org>
References: <20220221084915.554151737@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit dd4589eee99db8f61f7b8f7df1531cad3f74a64d upstream.

Remove a WARN on an "AVIC IPI invalid target" exit, the WARN is trivial
to trigger from guest as it will fail on any destination APIC ID that
doesn't exist from the guest's perspective.

Don't bother recording anything in the kernel log, the common tracepoint
for kvm_avic_incomplete_ipi() is sufficient for debugging.

This reverts commit 37ef0c4414c9743ba7f1af4392f0a27a99649f2a.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220204214205.3306634-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4585,8 +4585,6 @@ static int avic_incomplete_ipi_intercept
 		break;
 	}
 	case AVIC_IPI_FAILURE_INVALID_TARGET:
-		WARN_ONCE(1, "Invalid IPI target: index=%u, vcpu=%d, icr=%#0x:%#0x\n",
-			  index, svm->vcpu.vcpu_id, icrh, icrl);
 		break;
 	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
 		WARN_ONCE(1, "Invalid backing page\n");


