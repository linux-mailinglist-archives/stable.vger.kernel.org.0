Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C985D38EF60
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbhEXP5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233578AbhEXP4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:56:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EAD261405;
        Mon, 24 May 2021 15:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870961;
        bh=UvQ6AgjPJSCs2l15bid02zYssvvGbw/RJWx9BhiEHGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ctUCtD2LCNi6sVjgY4pPValHqSBqtV4lrx7tLXs2Grz5vNEiwFYF6Ph7b5Ny6Ih6E
         WiqQmUOojS6H8SGy3fvLOvarwRLidwhKjBtVGbH5ilCisI3tr1uBgGsfeuNjt//no8
         zj/Q4XR4PLZDkH1vz/seHQYPuCXb2uCPs5o/T7LU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Stafford Horne <shorne@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 002/127] openrisc: Fix a memory leak
Date:   Mon, 24 May 2021 17:25:19 +0200
Message-Id: <20210524152334.945748623@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit c019d92457826bb7b2091c86f36adb5de08405f9 ]

'setup_find_cpu_node()' take a reference on the node it returns.
This reference must be decremented when not needed anymore, or there will
be a leak.

Add the missing 'of_node_put(cpu)'.

Note that 'setup_cpuinfo()' that also calls this function already has a
correct 'of_node_put(cpu)' at its end.

Fixes: 9d02a4283e9c ("OpenRISC: Boot code")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/kernel/setup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/openrisc/kernel/setup.c b/arch/openrisc/kernel/setup.c
index 2416a9f91533..c6f9e7b9f7cb 100644
--- a/arch/openrisc/kernel/setup.c
+++ b/arch/openrisc/kernel/setup.c
@@ -278,6 +278,8 @@ void calibrate_delay(void)
 	pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
 		loops_per_jiffy / (500000 / HZ),
 		(loops_per_jiffy / (5000 / HZ)) % 100, loops_per_jiffy);
+
+	of_node_put(cpu);
 }
 
 void __init setup_arch(char **cmdline_p)
-- 
2.30.2



