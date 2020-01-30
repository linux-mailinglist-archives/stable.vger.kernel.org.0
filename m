Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B89014E2C5
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgA3Sjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:39:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727938AbgA3Sjy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:39:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08F47214DB;
        Thu, 30 Jan 2020 18:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409594;
        bh=G4eHylNNoWcu/YjzldYF8NNdD8vwCF+1PoFgw3DSM/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8RoO2CLOFlscaAaMVAzQUx7HKZCb4l0EljwdrwFDG2y1rv8oh8GU31ihT3LvInh8
         +Id68ggbwE1Hn6Vv3LI2Xth5wra03337W/7Sx0JNbp/BBnPOwK6fgRXOWnPDUEwvSz
         r6+a57zhSF0lXykSceLPMIks+bfJ+wNdl8s7KL+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 5.5 13/56] staging: wlan-ng: ensure error return is actually returned
Date:   Thu, 30 Jan 2020 19:38:30 +0100
Message-Id: <20200130183611.694057023@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.849023566@linuxfoundation.org>
References: <20200130183608.849023566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 4cc41cbce536876678b35e03c4a8a7bb72c78fa9 upstream.

Currently when the call to prism2sta_ifst fails a netdev_err error
is reported, error return variable result is set to -1 but the
function always returns 0 for success.  Fix this by returning
the error value in variable result rather than 0.

Addresses-Coverity: ("Unused value")
Fixes: 00b3ed168508 ("Staging: add wlan-ng prism2 usb driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200114181604.390235-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/wlan-ng/prism2mgmt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/wlan-ng/prism2mgmt.c
+++ b/drivers/staging/wlan-ng/prism2mgmt.c
@@ -959,7 +959,7 @@ int prism2mgmt_flashdl_state(struct wlan
 		}
 	}
 
-	return 0;
+	return result;
 }
 
 /*----------------------------------------------------------------


