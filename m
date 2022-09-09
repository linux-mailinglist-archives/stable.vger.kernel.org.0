Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1CBF5B3EAD
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 20:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiIISOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 14:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231907AbiIISOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 14:14:20 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96FBE5833
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 11:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662747259; x=1694283259;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VYPA6cGsb4+XWUm/MN8zZd1AoiZRsGSYoBSNYXma07g=;
  b=MtFOdYTOEkv8L3ih8Y9+cgXmlnJ5bXMhiK703IA45aVpcf++hE15Wm6t
   A0pg2qYqwFojPqMsn7b6ofWcLHJvJJHxdgPTMkpJSOnHpZuM9zb8B4C2J
   H5es8ewfiLLVo8K3o6VrL4DYh1Y3ijrBuG2zgOcLq5iP80Vp4oT/d3lOx
   k=;
X-IronPort-AV: E=Sophos;i="5.93,303,1654560000"; 
   d="scan'208";a="257975211"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-1box-2b-3386f33d.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 18:14:19 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-1box-2b-3386f33d.us-west-2.amazon.com (Postfix) with ESMTPS id 230B1A2827;
        Fri,  9 Sep 2022 18:14:17 +0000 (UTC)
Received: from EX19D012UWC001.ant.amazon.com (10.13.138.177) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 9 Sep 2022 18:14:17 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX19D012UWC001.ant.amazon.com (10.13.138.177) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.12; Fri, 9 Sep 2022 18:14:17 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1497.38 via Frontend Transport; Fri, 9 Sep 2022 18:14:16 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 0D95958DA; Fri,  9 Sep 2022 18:14:15 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <surajjs@amazon.com>,
        <mbacco@amazon.com>, Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 0/9] KVM backports to 5.10
Date:   Fri, 9 Sep 2022 18:13:42 +0000
Message-ID: <20220909181351.23983-1-risbhat@amazon.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-14.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
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

