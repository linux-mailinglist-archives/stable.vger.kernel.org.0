Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F3E2D5C20
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 14:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgLJNlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 08:41:39 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36555 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389334AbgLJNld (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 08:41:33 -0500
Received: by mail-lj1-f196.google.com with SMTP id a1so6722942ljq.3;
        Thu, 10 Dec 2020 05:41:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kiSP+cd25rqwud22NUwfk87T32QJ2x2ypRDZHw8Hvtk=;
        b=ZS77kjzKxxnUBPX/DKXIpygWfZAq6fFOMRRlQyeE3WZrOsYyOzHYPiIGvGNlN9Npc4
         qp/giF4W8xmM8PC9t3WWUDGOFAofScM0+zCDRuP5uxi8apjKJWkzjdqmla2TBf5a1exe
         /DymC9j+5FxjNSLGMCfOqH/DHxZLlLtgG5AqTEBj6xzTz+gpY114kC0uQcr1L+YTQifQ
         GtZZmXsjfBZUVa1KAyw5WwsEFjiGi+/kVw5tLD7Nfh/emcgrIPk79uZsu/4hPlWjeqmx
         1+K/2uES6JSEodJY5gGWfx0UzBCQYjrVyvJUahysI3nOo7wdc3JZxlTQnQmxgLo64pkC
         1m2Q==
X-Gm-Message-State: AOAM532LaGmA6NpjKATcCU99YxsX+kTGyLD9WuVi2ffDUCABala67fTG
        i1TjSJdsEW2vgREugcGAcYM=
X-Google-Smtp-Source: ABdhPJw8hWLWIA9s6ePNt8Fsujkuf2KBoX3VmmL1K+3/AIAwcRo27+g/pQ3PuDu5hqFiS9I1hPpXOQ==
X-Received: by 2002:a2e:b4d3:: with SMTP id r19mr757735ljm.419.1607607650199;
        Thu, 10 Dec 2020 05:40:50 -0800 (PST)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id q7sm603154ljp.77.2020.12.10.05.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 05:40:49 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1knMCJ-00017W-95; Thu, 10 Dec 2020 14:41:31 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jens Frederich <jfrederich@gmail.com>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH v2] x86/apic/of: Fix CPU devicetree-node lookups
Date:   Thu, 10 Dec 2020 14:39:10 +0100
Message-Id: <20201210133910.4229-1-johan@kernel.org>
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
not affect users of mainline kernels as the above mentioned drivers are
currently not used on x86 as far as I know.

Fixes: 4e07db9c8db8 ("x86/devicetree: Use CPU description from Device Tree")
Cc: stable <stable@vger.kernel.org>     # 4.17
Signed-off-by: Johan Hovold <johan@kernel.org>
---

Thomas,

Hope this looks better to you.

My use case for this is still out-of-tree, but since CPU-node lookup is
generic functionality and with observable impact also for mainline users
(sysfs) I added a stable tag.

Johan



Changes in v2
 - rewrite commit message
 - add Fixes tag
 - add stable tag for the benefit of out-of-tree users


 arch/x86/kernel/apic/apic.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b3eef1d5c903..19c0119892dd 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2311,6 +2311,11 @@ static int cpuid_to_apicid[] = {
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

