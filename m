Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E1E81A45
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbfHENEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:04:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729053AbfHENEc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:04:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0921214C6;
        Mon,  5 Aug 2019 13:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010271;
        bh=kGX1jxzuDNRJqOod9t7QrMG4O+Bd/lEDlWmeu/BAsbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7MmsMMQe14UJLfBK5IeGJNA/cqBr2X7wNHpLLOjsAu8qor6vbTjQvrqY87Six/IK
         dzhStr47peCyEQIXPn+NUZSVXcW3JIrYJf3Oe6yRvgYnxxntkq74O0moPNMA9khjDZ
         7k3NOpdJNM26W+ehsIVRhiHra8j0+FlHAafmtiPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Cvek <petrcvekcz@gmail.com>,
        Paul Burton <paul.burton@mips.com>, hauke@hauke-m.de,
        john@phrozen.org, linux-mips@vger.kernel.org,
        openwrt-devel@lists.openwrt.org, pakahmar@hotmail.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 04/22] MIPS: lantiq: Fix bitfield masking
Date:   Mon,  5 Aug 2019 15:02:41 +0200
Message-Id: <20190805124919.695465347@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124918.070468681@linuxfoundation.org>
References: <20190805124918.070468681@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ba1bc0fcdeaf3bf583c1517bd2e3e29cf223c969 ]

The modification of EXIN register doesn't clean the bitfield before
the writing of a new value. After a few modifications the bitfield would
accumulate only '1's.

Signed-off-by: Petr Cvek <petrcvekcz@gmail.com>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: hauke@hauke-m.de
Cc: john@phrozen.org
Cc: linux-mips@vger.kernel.org
Cc: openwrt-devel@lists.openwrt.org
Cc: pakahmar@hotmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/irq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/mips/lantiq/irq.c b/arch/mips/lantiq/irq.c
index 2e7f60c9fc5df..a7057a06c0961 100644
--- a/arch/mips/lantiq/irq.c
+++ b/arch/mips/lantiq/irq.c
@@ -160,8 +160,9 @@ static int ltq_eiu_settype(struct irq_data *d, unsigned int type)
 			if (edge)
 				irq_set_handler(d->hwirq, handle_edge_irq);
 
-			ltq_eiu_w32(ltq_eiu_r32(LTQ_EIU_EXIN_C) |
-				(val << (i * 4)), LTQ_EIU_EXIN_C);
+			ltq_eiu_w32((ltq_eiu_r32(LTQ_EIU_EXIN_C) &
+				    (~(7 << (i * 4)))) | (val << (i * 4)),
+				    LTQ_EIU_EXIN_C);
 		}
 	}
 
-- 
2.20.1



