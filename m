Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE45A1EAE26
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbgFASva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:51:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729620AbgFASE5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:04:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB1FA206E2;
        Mon,  1 Jun 2020 18:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034696;
        bh=bZkjbWgUmSFP5X92+1FaRvbwsvKGCYrXN+2UYnKxVJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aYJozcXshGa+QgEk5DQEugxhGQGcAaSVtlWs94oocpQ9ppf6el1X8EygJ2IXLN9z5
         Fe3PmLMK8Kla4JrqrNbUTzgZZHSl/Lg11AoQj2kIcbSmBRCRnXMJ4ieCjMfAqT/IN0
         n7wPj9E9T986+kU4WzMedkTn/D520XTxZGm4rf1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 67/95] include/asm-generic/topology.h: guard cpumask_of_node() macro argument
Date:   Mon,  1 Jun 2020 19:54:07 +0200
Message-Id: <20200601174031.518629450@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174020.759151073@linuxfoundation.org>
References: <20200601174020.759151073@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 4377748c7b5187c3342a60fa2ceb60c8a57a8488 ]

drivers/hwmon/amd_energy.c:195:15: error: invalid operands to binary expression ('void' and 'int')
                                        (channel - data->nr_cpus));
                                        ~~~~~~~~~^~~~~~~~~~~~~~~~~
include/asm-generic/topology.h:51:42: note: expanded from macro 'cpumask_of_node'
    #define cpumask_of_node(node)       ((void)node, cpu_online_mask)
                                               ^~~~
include/linux/cpumask.h:618:72: note: expanded from macro 'cpumask_first_and'
 #define cpumask_first_and(src1p, src2p) cpumask_next_and(-1, (src1p), (src2p))
                                                                       ^~~~~

Fixes: f0b848ce6fe9 ("cpumask: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask")
Fixes: 8abee9566b7e ("hwmon: Add amd_energy driver to report energy counters")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Link: http://lkml.kernel.org/r/20200527134623.930247-1-arnd@arndb.de
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/topology.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/topology.h b/include/asm-generic/topology.h
index 238873739550..5aa8705df87e 100644
--- a/include/asm-generic/topology.h
+++ b/include/asm-generic/topology.h
@@ -48,7 +48,7 @@
   #ifdef CONFIG_NEED_MULTIPLE_NODES
     #define cpumask_of_node(node)	((node) == 0 ? cpu_online_mask : cpu_none_mask)
   #else
-    #define cpumask_of_node(node)	((void)node, cpu_online_mask)
+    #define cpumask_of_node(node)	((void)(node), cpu_online_mask)
   #endif
 #endif
 #ifndef pcibus_to_node
-- 
2.25.1



