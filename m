Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EADD66E5A
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbfGLM3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:29:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728389AbfGLM3K (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:29:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35DCD208E4;
        Fri, 12 Jul 2019 12:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934549;
        bh=MQW6gcqWb9Ou1jl2cgKzV6NWp7OyOLckPyJ0EKuQCLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISva7/9JSrYKq+/prpgavgUYB5GeE/cT+ZFmMdYi/iKx1CJ0iJ+kC0DFYJuQux1cW
         0ZacZfrlpvrQfHEVGsc3ddaH4K/rmZpw4JwNV4sJq03qyTYep1ShwfrHNF1ayeuF7I
         gthRCrraMYQDYTnwtDOtFyJsN0AsV9Cp4T/2mr0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 075/138] IB/hfi1: Handle wakeup of orphaned QPs for pio
Date:   Fri, 12 Jul 2019 14:18:59 +0200
Message-Id: <20190712121631.570931948@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 099a884ba4c00145cef283d36e050726311c2e95 ]

Once a send context is taken down due to a link failure, any QPs waiting
for pio credits will stay on the waitlist indefinitely.

Fix by wakeing up all QPs linked to piowait list.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/pio.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index a1de566fe95e..1ee47838d4de 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -952,6 +952,22 @@ void sc_disable(struct send_context *sc)
 		}
 	}
 	spin_unlock(&sc->release_lock);
+
+	write_seqlock(&sc->waitlock);
+	while (!list_empty(&sc->piowait)) {
+		struct iowait *wait;
+		struct rvt_qp *qp;
+		struct hfi1_qp_priv *priv;
+
+		wait = list_first_entry(&sc->piowait, struct iowait, list);
+		qp = iowait_to_qp(wait);
+		priv = qp->priv;
+		list_del_init(&priv->s_iowait.list);
+		priv->s_iowait.lock = NULL;
+		hfi1_qp_wakeup(qp, RVT_S_WAIT_PIO | HFI1_S_WAIT_PIO_DRAIN);
+	}
+	write_sequnlock(&sc->waitlock);
+
 	spin_unlock_irq(&sc->alloc_lock);
 }
 
-- 
2.20.1



