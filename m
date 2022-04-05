Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3104F39BE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378647AbiDELh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353920AbiDEKJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:09:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03E0C4E02;
        Tue,  5 Apr 2022 02:55:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36CACB818F6;
        Tue,  5 Apr 2022 09:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C05C385A1;
        Tue,  5 Apr 2022 09:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152545;
        bh=mwszu1yW50OKQAP+R4EblUFAQnJ3LE7PFR9IM2ad8oQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZuh7ZQQXJwWUjBilUG228s5fuzVdBzyw3hD25LgepS0N5DfoPMR3BJRe8W4n4sia
         vmUdkD6rHrra6Jf29xXnQHPjKRMFAVnQlv1iFH1qtS59F6Cgds5ZHYwj9rJc1VPore
         CLTvKxlbG5/nKXEa61WaklmJT/Up/01m0RrFfglY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li RongQing <lirongqing@baidu.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 814/913] KVM: x86: fix sending PV IPI
Date:   Tue,  5 Apr 2022 09:31:16 +0200
Message-Id: <20220405070404.230885490@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

commit c15e0ae42c8e5a61e9aca8aac920517cf7b3e94e upstream.

If apic_id is less than min, and (max - apic_id) is greater than
KVM_IPI_CLUSTER_SIZE, then the third check condition is satisfied but
the new apic_id does not fit the bitmask.  In this case __send_ipi_mask
should send the IPI.

This is mostly theoretical, but it can happen if the apic_ids on three
iterations of the loop are for example 1, KVM_IPI_CLUSTER_SIZE, 0.

Fixes: aaffcfd1e82 ("KVM: X86: Implement PV IPIs in linux guest")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Message-Id: <1646814944-51801-1-git-send-email-lirongqing@baidu.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/kvm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -510,7 +510,7 @@ static void __send_ipi_mask(const struct
 		} else if (apic_id < min && max - apic_id < KVM_IPI_CLUSTER_SIZE) {
 			ipi_bitmap <<= min - apic_id;
 			min = apic_id;
-		} else if (apic_id < min + KVM_IPI_CLUSTER_SIZE) {
+		} else if (apic_id > min && apic_id < min + KVM_IPI_CLUSTER_SIZE) {
 			max = apic_id < max ? max : apic_id;
 		} else {
 			ret = kvm_hypercall4(KVM_HC_SEND_IPI, (unsigned long)ipi_bitmap,


