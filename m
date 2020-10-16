Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7851329008E
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404762AbgJPJHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:07:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405356AbgJPJHC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:07:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAE5420723;
        Fri, 16 Oct 2020 09:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839222;
        bh=D56CHBhqkDkqdmq2YkfONlSrBMiXW1cfzPua78+u7pQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mBuupXq6fcJqi9DsKXqx+R+PlhOGKYe71V3ac3ZN0rqLFcV94/6xz8Ty8cqpDkWVa
         giy16nR7V6Q1hK6gtJ2L9m8WabIVn3qpuph/KMaGIb4DqcBWJM/tDWYO1a88TlUzLy
         KcoFNSUq4CFZDFtMNwkMvUJsDRjPNQ+Y357xLEXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 4.4 02/16] Bluetooth: MGMT: Fix not checking if BT_HS is enabled
Date:   Fri, 16 Oct 2020 11:06:55 +0200
Message-Id: <20201016090435.548052326@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090435.423923738@linuxfoundation.org>
References: <20201016090435.423923738@linuxfoundation.org>
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
@@ -628,7 +628,8 @@ static u32 get_supported_settings(struct
 
 		if (lmp_ssp_capable(hdev)) {
 			settings |= MGMT_SETTING_SSP;
-			settings |= MGMT_SETTING_HS;
+			if (IS_ENABLED(CONFIG_BT_HS))
+				settings |= MGMT_SETTING_HS;
 		}
 
 		if (lmp_sc_capable(hdev))
@@ -2281,6 +2282,10 @@ static int set_link_security(struct sock
 
 	BT_DBG("request for %s", hdev->name);
 
+	if (!IS_ENABLED(CONFIG_BT_HS))
+		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_HS,
+				       MGMT_STATUS_NOT_SUPPORTED);
+
 	status = mgmt_bredr_support(hdev);
 	if (status)
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_LINK_SECURITY,


