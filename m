Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE3F2900D3
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404149AbgJPJJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:09:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395020AbgJPJJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:09:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E671212CC;
        Fri, 16 Oct 2020 09:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839363;
        bh=jsqWrNlb0BmE21Lo+GWPmU8KblvtiTeaAckTD9qI36c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dtvXTf0HC5dwkmgUtxfeRKuIPlczdEkZ3eNn/2w0GPYYVCQE8VEjZCz2L34RG/jBD
         Rr0byRnN1ibQev9XTANAcHkFBKqLd9G+D8F+IdPWug8l47SKvnodmoSDhOBmHWWWPt
         lTxF7IdBB3YfNVuwqVx6dZpBnUDzH+EqUnvDVER0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 4.19 07/21] Bluetooth: MGMT: Fix not checking if BT_HS is enabled
Date:   Fri, 16 Oct 2020 11:07:26 +0200
Message-Id: <20201016090437.667722917@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.301376476@linuxfoundation.org>
References: <20201016090437.301376476@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit b560a208cda0297fef6ff85bbfd58a8f0a52a543 upstream.

This checks if BT_HS is enabled relecting it on MGMT_SETTING_HS instead
of always reporting it as supported.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/mgmt.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -756,7 +756,8 @@ static u32 get_supported_settings(struct
 
 		if (lmp_ssp_capable(hdev)) {
 			settings |= MGMT_SETTING_SSP;
-			settings |= MGMT_SETTING_HS;
+			if (IS_ENABLED(CONFIG_BT_HS))
+				settings |= MGMT_SETTING_HS;
 		}
 
 		if (lmp_sc_capable(hdev))
@@ -1771,6 +1772,10 @@ static int set_hs(struct sock *sk, struc
 
 	BT_DBG("request for %s", hdev->name);
 
+	if (!IS_ENABLED(CONFIG_BT_HS))
+		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_HS,
+				       MGMT_STATUS_NOT_SUPPORTED);
+
 	status = mgmt_bredr_support(hdev);
 	if (status)
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_HS, status);


