Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEFF3920F9
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 21:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbhEZTfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 15:35:13 -0400
Received: from mga12.intel.com ([192.55.52.136]:16401 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234364AbhEZTfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 May 2021 15:35:13 -0400
IronPort-SDR: sKYd8VH6a2JwUgTek6tdGAnlZSCiSFSQDrvqdPge4UTh95rLgibPOizVWBVikKrfT4ahsb62G9
 H1hH/76PoObg==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="182204270"
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="182204270"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 12:33:39 -0700
IronPort-SDR: LrhzqGbq2nq3gVOtPv0x8/dReGTO0C6emf5sMlz9DlTTdvOOyi59ODY2dfCNJyICK2AHPQm8Ht
 ksny0iUcXDdg==
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="464936512"
Received: from twinkler-lnx.jer.intel.com ([10.12.91.138])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 12:33:37 -0700
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: request autosuspend after sending rx flow control
Date:   Wed, 26 May 2021 22:33:34 +0300
Message-Id: <20210526193334.445759-1-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

A rx flow control waiting in the control queue may block autosuspend.
Re-request autosuspend after flow control been sent to unblock
the transition to the low power state.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interrupt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index a98f6b895af7..aab3ebfa9fc4 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -277,6 +277,9 @@ static int mei_cl_irq_read(struct mei_cl *cl, struct mei_cl_cb *cb,
 		return ret;
 	}
 
+	pm_runtime_mark_last_busy(dev->dev);
+	pm_request_autosuspend(dev->dev);
+
 	list_move_tail(&cb->list, &cl->rd_pending);
 
 	return 0;
-- 
2.31.1

