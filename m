Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF9A428775
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 09:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234104AbhJKHMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 03:12:41 -0400
Received: from smtpout4.mo529.mail-out.ovh.net ([217.182.185.173]:51783 "EHLO
        smtpout4.mo529.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234100AbhJKHMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 03:12:40 -0400
X-Greylist: delayed 508 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Oct 2021 03:12:39 EDT
Received: from mxplan5.mail.ovh.net (unknown [10.109.156.216])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 0EC30C3BBB9B;
        Mon, 11 Oct 2021 09:02:09 +0200 (CEST)
Received: from kaod.org (37.59.142.95) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Mon, 11 Oct
 2021 09:02:09 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-95G0010762b5aa-8db3-4685-afb6-69febc946e19,
                    044DEDDE8B0E05FD49EE52B84AFD98BA54CEE260) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
From:   =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
To:     <linuxppc-dev@lists.ozlabs.org>
CC:     Michael Ellerman <mpe@ellerman.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        <stable@vger.kernel.org>
Subject: [PATCH] powerpc/xive: Discard disabled interrupts in get_irqchip_state()
Date:   Mon, 11 Oct 2021 09:02:03 +0200
Message-ID: <20211011070203.99726-1-clg@kaod.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.95]
X-ClientProxiedBy: DAG3EX1.mxp5.local (172.16.2.21) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: 1fcd0286-05cf-4e09-8d7f-6cb5e00e2edd
X-Ovh-Tracer-Id: 16244765333835647968
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvtddrvddthedgudduvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecunecujfgurhephffvufffkffogggtgfhisehtkeertdertdejnecuhfhrohhmpeevrogurhhitgcunfgvucfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepfedvuedtvdeikeekuefhkedujeejgffggffhtefglefgveevfeeghfdvgedtleevnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrdelheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhrtghpthhtoheptghlgheskhgrohgurdhorhhg
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When an interrupt is passed through, the KVM XIVE device calls the
set_vcpu_affinity() handler which raises the P bit to mask the
interrupt and to catch any in-flight interrupts while routing the
interrupt to the guest.

On the guest side, drivers (like some Intels) can request at probe
time some MSIs and call synchronize_irq() to check that there are no
in flight interrupts. This will call the XIVE get_irqchip_state()
handler which will always return true as the interrupt P bit has been
set on the host side and lock the CPU in an infinite loop.

Fix that by discarding disabled interrupts in get_irqchip_state().

Fixes: da15c03b047d ("powerpc/xive: Implement get_irqchip_state method for XIVE to fix shutdown race")
Cc: stable@vger.kernel.org#v5.4+
Signed-off-by: Cédric Le Goater <clg@kaod.org>
---
 arch/powerpc/sysdev/xive/common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index c732ce5a3e1a..c5d75c02ad8b 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -945,7 +945,8 @@ static int xive_get_irqchip_state(struct irq_data *data,
 		 * interrupt to be inactive in that case.
 		 */
 		*state = (pq != XIVE_ESB_INVALID) && !xd->stale_p &&
-			(xd->saved_p || !!(pq & XIVE_ESB_VAL_P));
+			(xd->saved_p || (!!(pq & XIVE_ESB_VAL_P) &&
+			 !irqd_irq_disabled(data)));
 		return 0;
 	default:
 		return -EINVAL;
-- 
2.31.1

