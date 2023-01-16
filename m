Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4773566C620
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbjAPQPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbjAPQOf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:14:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFF0241DA
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:08:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACD2261042
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26ABC433D2;
        Mon, 16 Jan 2023 16:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885317;
        bh=+ef+bKhlTRPs2GMghyM011F1uCyVlt/bPmD5u5ZBIIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ry/4DsUkcQDVcty7x96uVuj7g2zKha2EzivommuUywda20gZD3281KIFvUdW06htC
         GfoIkmVhP5JgRgkI0OzEJAXGrDds3P4fyZd3H94MDEW3bJLZL3WSf5ZAWVmf8xEZ64
         bxSKfWOoSJ+/+5iAvvSkZ8zB9Awuu3K3xZIGjC4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 53/64] Documentation: KVM: add API issues section
Date:   Mon, 16 Jan 2023 16:52:00 +0100
Message-Id: <20230116154745.401320092@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
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

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit cde363ab7ca7aea7a853851cd6a6745a9e1aaf5e ]

Add a section to document all the different ways in which the KVM API sucks.

I am sure there are way more, give people a place to vent so that userspace
authors are aware.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20220322110712.222449-4-pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/virt/kvm/api.rst | 46 ++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index cd8a58556804..d807994360d4 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6398,3 +6398,49 @@ When enabled, KVM will disable paravirtual features provided to the
 guest according to the bits in the KVM_CPUID_FEATURES CPUID leaf
 (0x40000001). Otherwise, a guest may use the paravirtual features
 regardless of what has actually been exposed through the CPUID leaf.
+
+9. Known KVM API problems
+=========================
+
+In some cases, KVM's API has some inconsistencies or common pitfalls
+that userspace need to be aware of.  This section details some of
+these issues.
+
+Most of them are architecture specific, so the section is split by
+architecture.
+
+9.1. x86
+--------
+
+``KVM_GET_SUPPORTED_CPUID`` issues
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+In general, ``KVM_GET_SUPPORTED_CPUID`` is designed so that it is possible
+to take its result and pass it directly to ``KVM_SET_CPUID2``.  This section
+documents some cases in which that requires some care.
+
+Local APIC features
+~~~~~~~~~~~~~~~~~~~
+
+CPU[EAX=1]:ECX[21] (X2APIC) is reported by ``KVM_GET_SUPPORTED_CPUID``,
+but it can only be enabled if ``KVM_CREATE_IRQCHIP`` or
+``KVM_ENABLE_CAP(KVM_CAP_IRQCHIP_SPLIT)`` are used to enable in-kernel emulation of
+the local APIC.
+
+The same is true for the ``KVM_FEATURE_PV_UNHALT`` paravirtualized feature.
+
+CPU[EAX=1]:ECX[24] (TSC_DEADLINE) is not reported by ``KVM_GET_SUPPORTED_CPUID``.
+It can be enabled if ``KVM_CAP_TSC_DEADLINE_TIMER`` is present and the kernel
+has enabled in-kernel emulation of the local APIC.
+
+Obsolete ioctls and capabilities
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+KVM_CAP_DISABLE_QUIRKS does not let userspace know which quirks are actually
+available.  Use ``KVM_CHECK_EXTENSION(KVM_CAP_DISABLE_QUIRKS2)`` instead if
+available.
+
+Ordering of KVM_GET_*/KVM_SET_* ioctls
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+TBD
-- 
2.35.1



