Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D68338878
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 10:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbhCLJVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 04:21:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232552AbhCLJVI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 04:21:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2130464FE0;
        Fri, 12 Mar 2021 09:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615540868;
        bh=HKyzLPWLU/FWL7rz8JEjHBFhc9WIdajW+NR/EByr3kc=;
        h=From:To:Cc:Subject:Date:From;
        b=iuZ39FOeACJa0lsjB/CIP8vCYlh5EXP/6LFVPl//kTg/tFdLV+EL82Lv5jZ/QNb1r
         8xUO4hcT03dZWaHUTo6XkwJgkObfnIpaU3ijuQwzXW8seMp8aiNY+Kg7CN5zWxJsA7
         +YlFhRUahfO2vrpmCUNk5AJ+XKzR64MBx+VrIn+ZYiCe6x82gsPTcvpfZRzElNAJ0k
         2f3TUzQ3ptT5pYWNG+nOmBkgkwttpTWsQboaN+W8xbTDQ/fz2IV4OFHJGj25VKGOTS
         MyEpP/alSPOKFmC7xVJrIC8ZrZz2I8Ww6dH8L+PBWKOHA/JEU11JWgNlDJ4cqYPURx
         CB+ewXtt+Utzw==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lKdyx-0006rQ-CS; Fri, 12 Mar 2021 10:21:20 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Rob Herring <robh@kernel.org>,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jens Frederich <jfrederich@gmail.com>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 RESEND] x86/apic/of: Fix CPU devicetree-node lookups
Date:   Fri, 12 Mar 2021 10:20:33 +0100
Message-Id: <20210312092033.26317-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Architectures that describe the CPU topology in devicetree and that do
not have an identity mapping between physical and logical CPU ids need
to override the default implementation of arch_match_cpu_phys_id().

Failing to do so breaks CPU devicetree-node lookups using
of_get_cpu_node() and of_cpu_device_node_get() which several drivers
rely on. It also causes the CPU struct devices exported through sysfs to
point to the wrong devicetree nodes.

On x86, CPUs are described in devicetree using their APIC ids and those
do not generally coincide with the logical ids, even if CPU0 typically
uses APIC id 0. Add the missing implementation of
arch_match_cpu_phys_id() so that CPU-node lookups work also with SMP.

Apart from fixing the broken sysfs devicetree-node links this likely do
not affect current users of mainline kernels on x86.

Fixes: 4e07db9c8db8 ("x86/devicetree: Use CPU description from Device Tree")
Cc: stable@vger.kernel.org	# 4.17
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 arch/x86/kernel/apic/apic.c | 5 +++++
 1 file changed, 5 insertions(+)


It's been over three months so resending.

Can someone please pick this up for 5.12 or -next?

Again, my use case for this is still out-of-tree, but since CPU-node
lookup is generic functionality and with observable impact also for
mainline users (sysfs) I added a stable tag in v2. Just drop the tag
if you think it's unwarranted.

Johan


 Changes in v2
 - rewrite commit message
 - add Fixes tag
 - add stable tag for the benefit of out-of-tree users


diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 6bd20c0de8bc..7cb93a4f4524 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2330,6 +2330,11 @@ static int cpuid_to_apicid[] = {
 	[0 ... NR_CPUS - 1] = -1,
 };
 
+bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
+{
+	return phys_id == cpuid_to_apicid[cpu];
+}
+
 #ifdef CONFIG_SMP
 /**
  * apic_id_is_primary_thread - Check whether APIC ID belongs to a primary thread
-- 
2.26.2

