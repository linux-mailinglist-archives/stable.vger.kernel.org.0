Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1475C4A304D
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 16:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243768AbiA2P34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 10:29:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:22055 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239029AbiA2P34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 10:29:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643470195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gtiQ1iYbrD0kjar4CMaAYoU0g3JCjSb3wjR+nPDXnHY=;
        b=F7DKxRzO/C+M0yIRUkX/aJe3W2nnOy/v4wrVEoCMSRGsBTg7cSyBPgn7nH69qJBsXA0isn
        rM1N5tf4KBeqW46+3EN8tLExnMLoKrIaJjkNxJuIBnuTP7xTq31VVMmfdImitefwy9n+mg
        C1uP5qehvWqYKP6X5PBIkq7DvER9PwQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-5mKLSmzSNoSmVgeb4J9TLA-1; Sat, 29 Jan 2022 10:29:51 -0500
X-MC-Unique: 5mKLSmzSNoSmVgeb4J9TLA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3B551006AA8;
        Sat, 29 Jan 2022 15:29:50 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6501F519A5;
        Sat, 29 Jan 2022 15:29:49 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        gregkh@linuxfoundation.org
Subject: [PATCH stable 5.16 v1 0/3] KVM: nVMX: Fix Windows 11 + WSL2 + Enlightened VMCS
Date:   Sat, 29 Jan 2022 16:29:44 +0100
Message-Id: <20220129152947.3136637-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series is the essential subset of "[PATCH v3 0/5] KVM: nVMX: Fix
Windows 11 + WSL2 + Enlightened VMCS" which got merged upstream recently.
It fixes Windows 11 guests with enabled Hyper-V role on KVM when eVMCS is
in use.

Vitaly Kuznetsov (3):
  KVM: nVMX: Rename vmcs_to_field_offset{,_table}
  KVM: nVMX: Implement evmcs_field_offset() suitable for handle_vmread()
  KVM: nVMX: Allow VMREAD when Enlightened VMCS is in use

 arch/x86/kvm/vmx/evmcs.c  |  3 +-
 arch/x86/kvm/vmx/evmcs.h  | 44 +++++++++++++++++++++++------
 arch/x86/kvm/vmx/nested.c | 59 +++++++++++++++++++++++++++------------
 arch/x86/kvm/vmx/vmcs12.c |  4 +--
 arch/x86/kvm/vmx/vmcs12.h |  6 ++--
 5 files changed, 83 insertions(+), 33 deletions(-)

-- 
2.34.1

