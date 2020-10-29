Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F63829E7E0
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 10:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgJ2JzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 05:55:24 -0400
Received: from mga04.intel.com ([192.55.52.120]:30816 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726407AbgJ2JzY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 05:55:24 -0400
IronPort-SDR: opjK48+MHug0BVSm4KQe+3nMAQLtuyvTLdY5rtxb0kbPBYNdYkgJXepAAhbmmo/W+fWu/nVXgy
 qZwXXPWUkLSg==
X-IronPort-AV: E=McAfee;i="6000,8403,9788"; a="165821751"
X-IronPort-AV: E=Sophos;i="5.77,429,1596524400"; 
   d="scan'208";a="165821751"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 02:55:23 -0700
IronPort-SDR: bnMnt2PfQkYicfAQtV4coNgrJcVSHI/r0B+ZeI+DPx6wlVJx0zul6l63qMVY+3Wi9HcaxR18Nz
 7eaN3xCtToeA==
X-IronPort-AV: E=Sophos;i="5.77,429,1596524400"; 
   d="scan'208";a="536607337"
Received: from twinkler-lnx.jer.intel.com ([10.12.91.138])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 02:55:19 -0700
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/3] mei: protect mei_cl_mtu from null dereference
Date:   Thu, 29 Oct 2020 11:54:42 +0200
Message-Id: <20201029095444.957924-2-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201029095444.957924-1-tomas.winkler@intel.com>
References: <20201029095444.957924-1-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

A receive callback is queued while the client is still connected
but can still be called after the client was disconnected. Upon
disconnect cl->me_cl is set to NULL, hence we need to check
that ME client is not-NULL in mei_cl_mtu to avoid
null dereference.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index 64143d4ec758..9e08a9843bba 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -182,11 +182,11 @@ static inline u8 mei_cl_me_id(const struct mei_cl *cl)
  *
  * @cl: host client
  *
- * Return: mtu
+ * Return: mtu or 0 if client is not connected
  */
 static inline size_t mei_cl_mtu(const struct mei_cl *cl)
 {
-	return cl->me_cl->props.max_msg_length;
+	return cl->me_cl ? cl->me_cl->props.max_msg_length : 0;
 }
 
 /**
-- 
2.25.4

