Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035E75B3F1E
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 20:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiIIS4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 14:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiIIS4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 14:56:30 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 703E2E5802
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 11:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662749789; x=1694285789;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VYPA6cGsb4+XWUm/MN8zZd1AoiZRsGSYoBSNYXma07g=;
  b=bgVl3s7SuhOkzc76AuOZWnb3Czs44Dmi08e/SZLOpZ6DNHQEVNgfSaNn
   4X9MilcI1F8AtKT2srUvKUsa3rMvopP5YW6Y6issWJgH7gMaq9ooN2Z9b
   EaZIIILFshwAxTqQfEi+Y3ZJtx1RP24Go9f3ubUQtCpr5bTrT7Ypyn0+A
   M=;
X-IronPort-AV: E=Sophos;i="5.93,303,1654560000"; 
   d="scan'208";a="239563926"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-4ba5c7da.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 18:56:28 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-4ba5c7da.us-east-1.amazon.com (Postfix) with ESMTPS id 4A6AB98289;
        Fri,  9 Sep 2022 18:56:26 +0000 (UTC)
Received: from EX19D012UWC003.ant.amazon.com (10.13.138.175) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 9 Sep 2022 18:56:21 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX19D012UWC003.ant.amazon.com (10.13.138.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.12; Fri, 9 Sep 2022 18:56:21 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP
 Server id 15.0.1497.38 via Frontend Transport; Fri, 9 Sep 2022 18:56:20 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 88B8058D2; Fri,  9 Sep 2022 18:56:19 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <surajjs@amazon.com>,
        <mbacco@amazon.com>, <bp@alien8.de>, <mingo@redhat.com>,
        <tglx@linutronix.de>, <pbonzini@redhat.com>, <seanjc@google.com>,
        <vkuznets@redhat.com>, <wanpengli@tencent.com>,
        <jmattson@google.com>, <joro@8bytes.org>,
        "Rishabh Bhatnagar" <risbhat@amazon.com>
Subject: [PATCH 0/9] KVM backports to 5.10
Date:   Fri, 9 Sep 2022 18:55:48 +0000
Message-ID: <20220909185557.21255-1-risbhat@amazon.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch series backports a few VM preemption_status, steal_time and
PV TLB flushing fixes to 5.10 stable kernel.

Most of the changes backport cleanly except i had to work around a few
becauseof missing support/APIs in 5.10 kernel. I have captured those in
the changelog as well in the individual patches.

Changelog
- Use mark_page_dirty_in_slot api without kvm argument (KVM: x86: Fix
  recording of guest steal time / preempted status)
- Avoid checking for xen_msr and SEV-ES conditions (KVM: x86:
  do not set st->preempted when going back to user space)
- Use VCPU_STAT macro to expose preemption_reported and
  preemption_other fields (KVM: x86: do not report a vCPU as preempted
  outside instruction boundaries)

David Woodhouse (2):
  KVM: x86: Fix recording of guest steal time / preempted status
  KVM: Fix steal time asm constraints

Lai Jiangshan (1):
  KVM: x86: Ensure PV TLB flush tracepoint reflects KVM behavior

Paolo Bonzini (5):
  KVM: x86: do not set st->preempted when going back to user space
  KVM: x86: do not report a vCPU as preempted outside instruction
    boundaries
  KVM: x86: revalidate steal time cache if MSR value changes
  KVM: x86: do not report preemption if the steal time cache is stale
  KVM: x86: move guest_pv_has out of user_access section

Sean Christopherson (1):
  KVM: x86: Remove obsolete disabling of page faults in
    kvm_arch_vcpu_put()

 arch/x86/include/asm/kvm_host.h |   5 +-
 arch/x86/kvm/svm/svm.c          |   2 +
 arch/x86/kvm/vmx/vmx.c          |   1 +
 arch/x86/kvm/x86.c              | 164 ++++++++++++++++++++++----------
 4 files changed, 122 insertions(+), 50 deletions(-)

-- 
2.37.1

