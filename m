Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F491018A3
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbfKSF1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:27:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:45130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbfKSF06 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:26:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A33521823;
        Tue, 19 Nov 2019 05:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141217;
        bh=U24cqw19Ki1GCxDzs7Eviju9mnv0Og7Nxqdr/g0uSQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k689T7NXnXEMyN34F1o2SRYhBox0sYGzg5vW5ZtAq5Ouc5/p/vApCT/kU+yxRg/t0
         bEZyQBlgbOdC1gYSeI9laVOjydhq8IYU/R23pmpHv7vK9j1HQ7Yd/6ylSaJzHWv3IC
         7e2vS/ElafnlOEMv2cRxW1rHZPzXNF4LBFG/FRbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lihong Yang <lihong.yang@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 084/422] i40evf: cancel workqueue sync for adminq when a VF is removed
Date:   Tue, 19 Nov 2019 06:14:41 +0100
Message-Id: <20191119051404.905857040@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lihong Yang <lihong.yang@intel.com>

[ Upstream commit babbcc60040abfb7a9e3caa1c58fe182ae73762a ]

If a VF is being removed, there is no need to continue with the
workqueue sync for the adminq task, thus cancel it. Without this call,
when VFs are created and removed right away, there might be a chance for
the driver to crash with events stuck in the adminq.

Signed-off-by: Lihong Yang <lihong.yang@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40evf/i40evf_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40evf/i40evf_main.c b/drivers/net/ethernet/intel/i40evf/i40evf_main.c
index 3fc46d2adc087..f50c19b833686 100644
--- a/drivers/net/ethernet/intel/i40evf/i40evf_main.c
+++ b/drivers/net/ethernet/intel/i40evf/i40evf_main.c
@@ -3884,6 +3884,8 @@ static void i40evf_remove(struct pci_dev *pdev)
 	if (adapter->watchdog_timer.function)
 		del_timer_sync(&adapter->watchdog_timer);
 
+	cancel_work_sync(&adapter->adminq_task);
+
 	i40evf_free_rss(adapter);
 
 	if (hw->aq.asq.count)
-- 
2.20.1



