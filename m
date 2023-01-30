Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048A2681094
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237017AbjA3OE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237056AbjA3OEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:04:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE56B9EF5
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:04:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D20EB80E60
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:04:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897C6C433D2;
        Mon, 30 Jan 2023 14:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087485;
        bh=yxvuMw+Y3rC3HmQKX+vBVgZ1S12V/ZvQTIVKE0QH/DI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZxA2hcCPO7uW5ewUEl+3KQvKQKmISnOCNpMpvdYsRX75W2qL3Z8Ep49uyUDpx3i/B
         tbVZkwMqGzQx0vxeeVibMQarDFZiRxc8TjdX05GR290uSkhh1FJ+O56HnNX8FA6OxJ
         DxJNgzSi/sqIMCVQBxVCgh1l9BelHCFNLY50Vg6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Graf <graf@amazon.de>,
        Hendrik Borghorst <hborghor@amazon.de>,
        Jim Mattson <jmattson@google.com>,
        Alexander Graf <graf@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 223/313] KVM: x86/vmx: Do not skip segment attributes if unusable bit is set
Date:   Mon, 30 Jan 2023 14:50:58 +0100
Message-Id: <20230130134347.097361298@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hendrik Borghorst <hborghor@amazon.de>

commit a44b331614e6f7e63902ed7dff7adc8c85edd8bc upstream.

When serializing and deserializing kvm_sregs, attributes of the segment
descriptors are stored by user space. For unusable segments,
vmx_segment_access_rights skips all attributes and sets them to 0.

This means we zero out the DPL (Descriptor Privilege Level) for unusable
entries.

Unusable segments are - contrary to their name - usable in 64bit mode and
are used by guests to for example create a linear map through the
NULL selector.

VMENTER checks if SS.DPL is correct depending on the CS segment type.
For types 9 (Execute Only) and 11 (Execute Read), CS.DPL must be equal to
SS.DPL [1].

We have seen real world guests setting CS to a usable segment with DPL=3
and SS to an unusable segment with DPL=3. Once we go through an sregs
get/set cycle, SS.DPL turns to 0. This causes the virtual machine to crash
reproducibly.

This commit changes the attribute logic to always preserve attributes for
unusable segments. According to [2] SS.DPL is always saved on VM exits,
regardless of the unusable bit so user space applications should have saved
the information on serialization correctly.

[3] specifies that besides SS.DPL the rest of the attributes of the
descriptors are undefined after VM entry if unusable bit is set. So, there
should be no harm in setting them all to the previous state.

[1] Intel SDM Vol 3C 26.3.1.2 Checks on Guest Segment Registers
[2] Intel SDM Vol 3C 27.3.2 Saving Segment Registers and Descriptor-Table
Registers
[3] Intel SDM Vol 3C 26.3.2.2 Loading Guest Segment Registers and
Descriptor-Table Registers

Cc: Alexander Graf <graf@amazon.de>
Cc: stable@vger.kernel.org
Signed-off-by: Hendrik Borghorst <hborghor@amazon.de>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
Message-Id: <20221114164823.69555-1-hborghor@amazon.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3412,18 +3412,15 @@ static u32 vmx_segment_access_rights(str
 {
 	u32 ar;
 
-	if (var->unusable || !var->present)
-		ar = 1 << 16;
-	else {
-		ar = var->type & 15;
-		ar |= (var->s & 1) << 4;
-		ar |= (var->dpl & 3) << 5;
-		ar |= (var->present & 1) << 7;
-		ar |= (var->avl & 1) << 12;
-		ar |= (var->l & 1) << 13;
-		ar |= (var->db & 1) << 14;
-		ar |= (var->g & 1) << 15;
-	}
+	ar = var->type & 15;
+	ar |= (var->s & 1) << 4;
+	ar |= (var->dpl & 3) << 5;
+	ar |= (var->present & 1) << 7;
+	ar |= (var->avl & 1) << 12;
+	ar |= (var->l & 1) << 13;
+	ar |= (var->db & 1) << 14;
+	ar |= (var->g & 1) << 15;
+	ar |= (var->unusable || !var->present) << 16;
 
 	return ar;
 }


