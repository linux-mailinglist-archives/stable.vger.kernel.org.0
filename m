Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA55498067
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241581AbiAXNFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:05:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39575 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239721AbiAXNFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:05:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643029541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QtPG/0QhUh4TunRnFMTLzHv7oMpLwt9vAu3rFbkzIUM=;
        b=Sahe1tZ2DBRrobfvQ7F1FQFTJP7nFw7IzbJDJCXJabxeeIQVwsVUOHUMsxk/w+z266CkV7
        giRDPH8iVLqv+RB3YN2WppxATexzuKUdNctQFi8/ZDT6UxE5YLYYk6c/ZfgxTOhomOPR4G
        BFC9PzNpm8ooAD/fnD32QbIrxxVmBOM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412--dde8EmKM5iPwtHPsjHKrA-1; Mon, 24 Jan 2022 08:05:37 -0500
X-MC-Unique: -dde8EmKM5iPwtHPsjHKrA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F26A1006AA6;
        Mon, 24 Jan 2022 13:05:37 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7AD827D4A4;
        Mon, 24 Jan 2022 13:05:35 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>, gregkh@linuxfoundation.org
Subject: [PATCH stable 5.16 v1 0/4] KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN for CPU hotplug
Date:   Mon, 24 Jan 2022 14:05:30 +0100
Message-Id: <20220124130534.2645955-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a backport of the recently merged "[PATCH v3 0/4] KVM: x86:
Partially allow KVM_SET_CPUID{,2} after KVM_RUN for CPU hotplug" 
(https://lore.kernel.org/kvm/20220118141801.2219924-1-vkuznets@redhat.com/)

Original description:

Recently, KVM made it illegal to change CPUID after KVM_RUN but
unfortunately this change is not fully compatible with existing VMMs.
In particular, QEMU reuses vCPU fds for CPU hotplug after unplug and it
calls KVM_SET_CPUID2. Relax the requirement by implementing an allowing
KVM_SET_CPUID{,2} with the exact same data.

Vitaly Kuznetsov (4):
  KVM: x86: Do runtime CPUID update before updating
    vcpu->arch.cpuid_entries
  KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN
  KVM: selftests: Rename 'get_cpuid_test' to 'cpuid_test'
  KVM: selftests: Test KVM_SET_CPUID2 after KVM_RUN

 arch/x86/kvm/cpuid.c                          | 90 ++++++++++++++-----
 arch/x86/kvm/x86.c                            | 19 ----
 tools/testing/selftests/kvm/.gitignore        |  2 +-
 tools/testing/selftests/kvm/Makefile          |  4 +-
 .../selftests/kvm/include/x86_64/processor.h  |  7 ++
 .../selftests/kvm/lib/x86_64/processor.c      | 33 ++++++-
 .../x86_64/{get_cpuid_test.c => cpuid_test.c} | 30 +++++++
 7 files changed, 139 insertions(+), 46 deletions(-)
 rename tools/testing/selftests/kvm/x86_64/{get_cpuid_test.c => cpuid_test.c} (83%)

-- 
2.34.1

