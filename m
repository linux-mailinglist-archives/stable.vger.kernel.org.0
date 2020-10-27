Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC4929B7EE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798569AbgJ0P2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:28:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796199AbgJ0PUA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:20:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE41B20657;
        Tue, 27 Oct 2020 15:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812000;
        bh=E7m0Uwqn2wsCRyU5E2dK2g70oH0PO7eCsfMJ+ITaGdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mu+Wor7fWJ/XdItguLgP5ZnOavXYcoYX9hRDL7jKb/8AZL14Z+V/NgwQWglt6Fcuy
         VqJlRWWKXHjlJ0VdL6/lC2jjDT3v7TjUMyLJmIjGi+MJbXqjdWH9k+A/ZA9B9I5OIp
         K8XBwOoULDzoqis0xnAEZjx2LQVc0KVV7zTnlJkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edward Cree <ecree@solarflare.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 058/757] sfc: move initialisation of efx->filter_sem to efx_init_struct()
Date:   Tue, 27 Oct 2020 14:45:08 +0100
Message-Id: <20201027135453.278320090@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>

[ Upstream commit 05f90bf3d5df40e1a705527520e5fd56b2b6f09e ]

efx_probe_filters() has not been called yet when EF100 calls into
 efx_mcdi_filter_table_probe(), for which it wants to take the
 filter_sem.

Fixes: a9dc3d5612ce ("sfc_ef100: RX filter table management and related gubbins")
Signed-off-by: Edward Cree <ecree@solarflare.com>
Link: https://lore.kernel.org/r/24fad43e-887d-051e-25e3-506f23f63abf@solarflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/efx_common.c |    1 +
 drivers/net/ethernet/sfc/rx_common.c  |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -1030,6 +1030,7 @@ int efx_init_struct(struct efx_nic *efx,
 	efx->num_mac_stats = MC_CMD_MAC_NSTATS;
 	BUILD_BUG_ON(MC_CMD_MAC_NSTATS - 1 != MC_CMD_MAC_GENERATION_END);
 	mutex_init(&efx->mac_lock);
+	init_rwsem(&efx->filter_sem);
 #ifdef CONFIG_RFS_ACCEL
 	mutex_init(&efx->rps_mutex);
 	spin_lock_init(&efx->rps_hash_lock);
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -797,7 +797,6 @@ int efx_probe_filters(struct efx_nic *ef
 {
 	int rc;
 
-	init_rwsem(&efx->filter_sem);
 	mutex_lock(&efx->mac_lock);
 	down_write(&efx->filter_sem);
 	rc = efx->type->filter_table_probe(efx);


