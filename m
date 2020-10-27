Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602D029AE3D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 14:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1753062AbgJ0N6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 09:58:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438765AbgJ0N6U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:58:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B2872068D;
        Tue, 27 Oct 2020 13:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807100;
        bh=FAYDlh4UDchwxRBEbR/qrKS9Q//KaZBdDRB8ibREuWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W5l4O71YVTSoIWr0JDukbIPHGiz0c7gP2DXrO1YniFHbKvmxD1fZCph7Y7KYSi0+Q
         U6Fkll/ZsqIvhRzNMwSL+xr6TQnzYaF0ixVeR2YRF7+1LBNkDRZTr9SufKu/6SnhMx
         Dc0RfW6s8HdvmRLJvT03bsxGSzVpn4flPu+ZdGwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 043/112] ath6kl: wmi: prevent a shift wrapping bug in ath6kl_wmi_delete_pstream_cmd()
Date:   Tue, 27 Oct 2020 14:49:13 +0100
Message-Id: <20201027134902.597238550@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 6a950755cec1a90ddaaff3e4acb5333617441c32 ]

The "tsid" is a user controlled u8 which comes from debugfs.  Values
more than 15 are invalid because "active_tsids" is a 16 bit variable.
If the value of "tsid" is more than 31 then that leads to a shift
wrapping bug.

Fixes: 8fffd9e5ec9e ("ath6kl: Implement support for QOS-enable and QOS-disable from userspace")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200918142732.GA909725@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/wmi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index b2ec254f154e0..7e1010475cfb2 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2644,6 +2644,11 @@ int ath6kl_wmi_delete_pstream_cmd(struct wmi *wmi, u8 if_idx, u8 traffic_class,
 		return -EINVAL;
 	}
 
+	if (tsid >= 16) {
+		ath6kl_err("invalid tsid: %d\n", tsid);
+		return -EINVAL;
+	}
+
 	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
-- 
2.25.1



