Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 187A913A680
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbgANKLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:11:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:47496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731893AbgANKLu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:11:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B6D424677;
        Tue, 14 Jan 2020 10:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996709;
        bh=B1XV/o6SJfKtoC5kFqGuPPVt02MVsT1m8qEe1Lgicmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFTwCDWI3KPpnv//pnBuqnlm2Fy1niXd3QrFS5i/FR9xice3y4hiV8rMRCRdznEd0
         q/wyA6q1lV3dMACs2Z/Xqhi8VparNZQ8b/TPucRPBsVzu1xfOUqL3ibOiw7QHOv+8n
         71w20itKgvdcGSHR1z4Je8oiFlDNTbhASwxFLVBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Chris Chiu <chiu@endlessm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.9 28/31] rtl8xxxu: prevent leaking urb
Date:   Tue, 14 Jan 2020 11:02:20 +0100
Message-Id: <20200114094345.229722756@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094334.725604663@linuxfoundation.org>
References: <20200114094334.725604663@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit a2cdd07488e666aa93a49a3fc9c9b1299e27ef3c upstream.

In rtl8xxxu_submit_int_urb if usb_submit_urb fails the allocated urb
should be released.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Reviewed-by: Chris Chiu <chiu@endlessm.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5422,6 +5422,7 @@ static int rtl8xxxu_submit_int_urb(struc
 	ret = usb_submit_urb(urb, GFP_KERNEL);
 	if (ret) {
 		usb_unanchor_urb(urb);
+		usb_free_urb(urb);
 		goto error;
 	}
 


