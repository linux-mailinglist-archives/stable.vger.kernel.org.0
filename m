Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0093524B2EC
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgHTJi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:38:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728913AbgHTJiy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:38:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13D972075E;
        Thu, 20 Aug 2020 09:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916334;
        bh=6Ph9bjp28ZJvGhNXbLdFvK04Ec5xSbH1QX9g4Ch7iaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPlznQtnNFFtiEqS2/a+fUJFKZKx8LwiYfGukv/gzB2sCWOg9enggXHlGip3VXm0t
         GrLEGjAH5YW3LeklCCqeumW3r5Hq9ac83cAqdthLTT3AWWYLNqJMBEo6rLwo7gYdXO
         bdMRr4yd+ZhxDwjj/4AS3g2I5ggiEMFtkOD4bFDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huacai Chen <chenhc@lemote.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.7 063/204] MIPS: CPU#0 is not hotpluggable
Date:   Thu, 20 Aug 2020 11:19:20 +0200
Message-Id: <20200820091609.411657951@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
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


