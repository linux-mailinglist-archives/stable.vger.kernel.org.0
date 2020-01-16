Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B114F13FF28
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387501AbgAPX1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:27:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:55118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391116AbgAPXZ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:25:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CB942072E;
        Thu, 16 Jan 2020 23:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217127;
        bh=ip16o6y/bxfpF03dpSq9CeN954KM9/rB1zBDlMUfgkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dIf1P/vWP65hzHLjFA+P3Y7apoMtJuEV7YNnU26HsOCypeuNVf1EjuXg9frrMIFSO
         h+6HY2RQfbVeLTSg3Sri3Pkr/l8sQZjsOjBz+jgkI3IOuTQn6KgYJBDrTn6InQcom2
         Mp8KOCfO3moACsqyHvU0QSRFg6x+LNVyaNw//648=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH 5.4 142/203] MIPS: SGI-IP27: Fix crash, when CPUs are disabled via nr_cpus parameter
Date:   Fri, 17 Jan 2020 00:17:39 +0100
Message-Id: <20200116231757.391207929@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

commit e3d765a941f6130fd94e47b2064cfee71f4cbadd upstream.

If number of CPUs are limited by the kernel commandline parameter nr_cpus
assignment of interrupts accourding to numa rules might not be possibe.
As a fallback use one of the online CPUs as interrupt destination.

Fixes: 69a07a41d908 ("MIPS: SGI-IP27: rework HUB interrupts")
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/sgi-ip27/ip27-irq.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/mips/sgi-ip27/ip27-irq.c
+++ b/arch/mips/sgi-ip27/ip27-irq.c
@@ -73,6 +73,9 @@ static void setup_hub_mask(struct hub_ir
 	int cpu;
 
 	cpu = cpumask_first_and(mask, cpu_online_mask);
+	if (cpu >= nr_cpu_ids)
+		cpu = cpumask_any(cpu_online_mask);
+
 	nasid = COMPACT_TO_NASID_NODEID(cpu_to_node(cpu));
 	hd->cpu = cpu;
 	if (!cputoslice(cpu)) {
@@ -139,6 +142,7 @@ static int hub_domain_alloc(struct irq_d
 	/* use CPU connected to nearest hub */
 	hub = hub_data(NASID_TO_COMPACT_NODEID(info->nasid));
 	setup_hub_mask(hd, &hub->h_cpus);
+	info->nasid = cpu_to_node(hd->cpu);
 
 	/* Make sure it's not already pending when we connect it. */
 	REMOTE_HUB_CLR_INTR(info->nasid, swlevel);


