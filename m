Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89ACF1215EB
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732070AbfLPSZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:25:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:43144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731756AbfLPSSJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:18:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 186B0206E0;
        Mon, 16 Dec 2019 18:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520288;
        bh=pm2cQGMCeE/U1M1ZNd+RFAp2veHPU25WymHFRQgKUQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fjwoEDP+TujWZVTBJ3SVvyROBjcV7iBlKs+dmDRCaYQrwAb1yA7uvJoiiI8ltjD+e
         pHD+GH5E6oO2VHNG98k6LmV5bAsobIO6soF2RLQ1bRiuN6gx3tUDTGLPXv+sCH7MRl
         EHyA3JkHptU25L95Mkx78nJzTqA2JaQLlE6Km6pY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Denis Efremov <efremov@linux.com>
Subject: [PATCH 5.4 094/177] wil6210: check len before memcpy() calls
Date:   Mon, 16 Dec 2019 18:49:10 +0100
Message-Id: <20191216174839.462805451@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

commit 2c840676be8ffc624bf9bb4490d944fd13c02d71 upstream.

memcpy() in wmi_set_ie() and wmi_update_ft_ies() is called with
src == NULL and len == 0. This is an undefined behavior. Fix it
by checking "ie_len > 0" before the memcpy() calls.

As suggested by GCC documentation:
"The pointers passed to memmove (and similar functions in <string.h>)
must be non-null even when nbytes==0, so GCC can use that information
to remove the check after the memmove call." [1]

[1] https://gcc.gnu.org/gcc-4.9/porting_to.html

Cc: Maya Erez <merez@codeaurora.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/wil6210/wmi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -2505,7 +2505,8 @@ int wmi_set_ie(struct wil6210_vif *vif,
 	cmd->mgmt_frm_type = type;
 	/* BUG: FW API define ieLen as u8. Will fix FW */
 	cmd->ie_len = cpu_to_le16(ie_len);
-	memcpy(cmd->ie_info, ie, ie_len);
+	if (ie_len)
+		memcpy(cmd->ie_info, ie, ie_len);
 	rc = wmi_send(wil, WMI_SET_APPIE_CMDID, vif->mid, cmd, len);
 	kfree(cmd);
 out:
@@ -2541,7 +2542,8 @@ int wmi_update_ft_ies(struct wil6210_vif
 	}
 
 	cmd->ie_len = cpu_to_le16(ie_len);
-	memcpy(cmd->ie_info, ie, ie_len);
+	if (ie_len)
+		memcpy(cmd->ie_info, ie, ie_len);
 	rc = wmi_send(wil, WMI_UPDATE_FT_IES_CMDID, vif->mid, cmd, len);
 	kfree(cmd);
 


