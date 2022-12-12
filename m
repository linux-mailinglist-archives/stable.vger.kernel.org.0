Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F68864A0A5
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbiLLN2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbiLLN17 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:27:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E68F13DFA
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:27:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D65B61053
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29E7C433D2;
        Mon, 12 Dec 2022 13:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851676;
        bh=45i9J2FluU+irWJIHe0iIjsIUkaH+iYRyFTTpBT8kRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IRmMerINSiVdocTV/O15fycAE+w4oU9xxS9dm+CZ4xXKPRndWgbGQV993jMFmFsbY
         d8GTB2IOVs8JwoLCtGTM7a+RJE8sSj0QAIzO/yd0dLsa/0dYDMYlOVq5727Qp3JJGL
         MoCoUaOlXkTWAO2+W+X3D9eRRsJdTOUTRsMOVDu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH 5.15 048/123] KVM: s390: vsie: Fix the initialization of the epoch extension (epdx) field
Date:   Mon, 12 Dec 2022 14:16:54 +0100
Message-Id: <20221212130928.939961257@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

commit 0dd4cdccdab3d74bd86b868768a7dca216bcce7e upstream.

We recently experienced some weird huge time jumps in nested guests when
rebooting them in certain cases. After adding some debug code to the epoch
handling in vsie.c (thanks to David Hildenbrand for the idea!), it was
obvious that the "epdx" field (the multi-epoch extension) did not get set
to 0xff in case the "epoch" field was negative.
Seems like the code misses to copy the value from the epdx field from
the guest to the shadow control block. By doing so, the weird time
jumps are gone in our scenarios.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2140899
Fixes: 8fa1696ea781 ("KVM: s390: Multiple Epoch Facility support")
Signed-off-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Cc: stable@vger.kernel.org # 4.19+
Link: https://lore.kernel.org/r/20221123090833.292938-1-thuth@redhat.com
Message-Id: <20221123090833.292938-1-thuth@redhat.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/vsie.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -538,8 +538,10 @@ static int shadow_scb(struct kvm_vcpu *v
 	if (test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_CEI))
 		scb_s->eca |= scb_o->eca & ECA_CEI;
 	/* Epoch Extension */
-	if (test_kvm_facility(vcpu->kvm, 139))
+	if (test_kvm_facility(vcpu->kvm, 139)) {
 		scb_s->ecd |= scb_o->ecd & ECD_MEF;
+		scb_s->epdx = scb_o->epdx;
+	}
 
 	/* etoken */
 	if (test_kvm_facility(vcpu->kvm, 156))


