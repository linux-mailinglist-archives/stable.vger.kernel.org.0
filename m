Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014494416D4
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbhKAJaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:30:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232910AbhKAJ2M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:28:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D01A611ED;
        Mon,  1 Nov 2021 09:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758564;
        bh=lpeYeTsGZkT8KmzE3cRaqNKlJKN242ItCaEOKSNdFFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0O9zOViM3p6Xd2EjgKMbV00mODfCSVTnkIVwz32KfP9+1dbibLc0/1ezhIJRBn8sh
         0U24aFvIZGW6WnIrqw/VBv9paH+sJiTQz83+mGRZRh0k2oiwYwXw4KkpMu6dKUqaIK
         wQKk8RvcbeVX8c7rTpfZAlatEXC27tK3DLzrak90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenbin Mei <wenbin.mei@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 16/51] mmc: cqhci: clear HALT state after CQE enable
Date:   Mon,  1 Nov 2021 10:17:20 +0100
Message-Id: <20211101082504.347052203@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082500.203657870@linuxfoundation.org>
References: <20211101082500.203657870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenbin Mei <wenbin.mei@mediatek.com>

commit 92b18252b91de567cd875f2e84722b10ab34ee28 upstream.

While mmc0 enter suspend state, we need halt CQE to send legacy cmd(flush
cache) and disable cqe, for resume back, we enable CQE and not clear HALT
state.
In this case MediaTek mmc host controller will keep the value for HALT
state after CQE disable/enable flow, so the next CQE transfer after resume
will be timeout due to CQE is in HALT state, the log as below:
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: timeout for tag 2
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: ============ CQHCI REGISTER DUMP ===========
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: Caps:      0x100020b6 | Version:  0x00000510
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: Config:    0x00001103 | Control:  0x00000001
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: Int stat:  0x00000000 | Int enab: 0x00000006
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: Int sig:   0x00000006 | Int Coal: 0x00000000
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: TDL base:  0xfd05f000 | TDL up32: 0x00000000
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: Doorbell:  0x8000203c | TCN:      0x00000000
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: Dev queue: 0x00000000 | Dev Pend: 0x00000000
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: Task clr:  0x00000000 | SSC1:     0x00001000
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: SSC2:      0x00000001 | DCMD rsp: 0x00000000
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: RED mask:  0xfdf9a080 | TERRI:    0x00000000
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: Resp idx:  0x00000000 | Resp arg: 0x00000000
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: CRNQP:     0x00000000 | CRNQDUN:  0x00000000
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: CRNQIS:    0x00000000 | CRNQIE:   0x00000000

This change check HALT state after CQE enable, if CQE is in HALT state, we
will clear it.

Signed-off-by: Wenbin Mei <wenbin.mei@mediatek.com>
Cc: stable@vger.kernel.org
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: a4080225f51d ("mmc: cqhci: support for command queue enabled host")
Link: https://lore.kernel.org/r/20211026070812.9359-1-wenbin.mei@mediatek.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/cqhci.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mmc/host/cqhci.c
+++ b/drivers/mmc/host/cqhci.c
@@ -273,6 +273,9 @@ static void __cqhci_enable(struct cqhci_
 
 	cqhci_writel(cq_host, cqcfg, CQHCI_CFG);
 
+	if (cqhci_readl(cq_host, CQHCI_CTL) & CQHCI_HALT)
+		cqhci_writel(cq_host, 0, CQHCI_CTL);
+
 	mmc->cqe_on = true;
 
 	if (cq_host->ops->enable)


