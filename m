Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9713D24B759
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730252AbgHTKvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:51:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731189AbgHTKOe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:14:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00A432067C;
        Thu, 20 Aug 2020 10:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918474;
        bh=6Ph9bjp28ZJvGhNXbLdFvK04Ec5xSbH1QX9g4Ch7iaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qp+UrJdr8YAeiqWyvXCxzNq8WPeaoxt1TYBArGheQZBj4t3iaVnC8ITm9BN8vgh/5
         sDDhlo874TM6OVvUQqbWvSuaurYuQgDzKURac3I5h5tGkiaS52K+qx3DkDZXPhjl8m
         UX0thiTq8ldt+pvIHaA9V5R+ByCN1KBFSWOUoqq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huacai Chen <chenhc@lemote.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 4.14 182/228] MIPS: CPU#0 is not hotpluggable
Date:   Thu, 20 Aug 2020 11:22:37 +0200
Message-Id: <20200820091616.671326927@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

commit 9cce844abf07b683cff5f0273977d5f8d0af94c7 upstream.

Now CPU#0 is not hotpluggable on MIPS, so prevent to create /sys/devices
/system/cpu/cpu0/online which confuses some user-space tools.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/topology.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/kernel/topology.c
+++ b/arch/mips/kernel/topology.c
@@ -20,7 +20,7 @@ static int __init topology_init(void)
 	for_each_present_cpu(i) {
 		struct cpu *c = &per_cpu(cpu_devices, i);
 
-		c->hotpluggable = 1;
+		c->hotpluggable = !!i;
 		ret = register_cpu(c, i);
 		if (ret)
 			printk(KERN_WARNING "topology_init: register_cpu %d "


