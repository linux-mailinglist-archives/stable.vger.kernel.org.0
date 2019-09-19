Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD92B8473
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405794AbfISWK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:10:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389407AbfISWK4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:10:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E8EA218AF;
        Thu, 19 Sep 2019 22:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931055;
        bh=kq4pdFmtcMw82+SxqAXPhY8B6WPqlfQZGcEo6PI8wQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7lcwSKLU+I/H//CGICbmYGDKt8Q3rQE6nrwL/4YDGdmhwxW39cOCY+JWK3NV8Wsh
         98ryX52vO2ZDsIfOzJRDqkpyi8/dNE69PTT4nOd1344kSqOyMSNu5vAp4GcO3Az4xs
         jbUmcMwY5tNuLM4JFbcaSZtyUyWBN/dTQwCmlwSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Russkikh <igor.russkikh@aquantia.com>,
        Michael Symolkin <Michael.Symolkin@aquantia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 104/124] net: aquantia: linkstate irq should be oneshot
Date:   Fri, 20 Sep 2019 00:03:12 +0200
Message-Id: <20190919214822.988354358@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Russkikh <Igor.Russkikh@aquantia.com>

[ Upstream commit 5c47e3ba6fe52465603cf9d816b3371e6881d649 ]

Declaring threaded irq handler should also indicate the irq is
oneshot. It is oneshot indeed, because HW implements irq automasking
on trigger.

Not declaring this causes some kernel configurations to fail
on interface up, because request_threaded_irq returned an err code.

The issue was originally hidden on normal x86_64 configuration with
latest kernel, because depending on interrupt controller, irq driver
added ONESHOT flag on its own.

Issue was observed on older kernels (4.14) where no such logic exists.

Fixes: 4c83f170b3ac ("net: aquantia: link status irq handling")
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Reported-by: Michael Symolkin <Michael.Symolkin@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 41172fbebddd3..1a2b090652930 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -390,7 +390,7 @@ int aq_nic_start(struct aq_nic_s *self)
 						   self->aq_nic_cfg.link_irq_vec);
 			err = request_threaded_irq(irqvec, NULL,
 						   aq_linkstate_threaded_isr,
-						   IRQF_SHARED,
+						   IRQF_SHARED | IRQF_ONESHOT,
 						   self->ndev->name, self);
 			if (err < 0)
 				goto err_exit;
-- 
2.20.1



