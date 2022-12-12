Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11B364A232
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbiLLNvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233171AbiLLNuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:50:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CFF1583E
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:50:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D44B610A3
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05057C433EF;
        Mon, 12 Dec 2022 13:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670853001;
        bh=ZGp5/e8Ohphb28winLlqyxkptSStA1iqI9P+Eb47xQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wZ+QnNJk1n5Jg+piQuazwCy7n7odoCznze2DMNVOwRw2mRdGnHkR6Icx0PJuccKjH
         Ljh5hGdgF2EA9yRvPqsGyrmW+VRhQu8qqKgRWzY+bLa95txXwt6IogzZ6lapqj+2Cp
         UVjUpu9tk587Oq0Kr5Fv4lHcBUyvFPlQCQow/oTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH 4.19 19/49] KVM: s390: vsie: Fix the initialization of the epoch extension (epdx) field
Date:   Mon, 12 Dec 2022 14:18:57 +0100
Message-Id: <20221212130914.651576365@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>
References: <20221212130913.666185567@linuxfoundation.org>
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
@@ -376,8 +376,10 @@ static int shadow_scb(struct kvm_vcpu *v
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


