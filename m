Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F913A620C
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbhFNKz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234428AbhFNKwr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:52:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57F9561004;
        Mon, 14 Jun 2021 10:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667169;
        bh=HschcZvN4hezXY4DSCghgaTzlnM+FqVxKmRTWtTIU9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rz2BRchpePftd0aTJoAxCvqz/BG3K2b5KRztXhwVUlgcN8xmcpLwZwJk6ijP1OVuF
         1aXRS6LoUsASjlF4CY16tJk6qzmAn9yuRjVLflvAGoKFOO3OEbZejDan/59/akHnNl
         L/5hqG8+Z92Hyejs4ksuUZoX80kDpl0D4Mu96SF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.4 52/84] usb: typec: wcove: Use LE to CPU conversion when accessing msg->header
Date:   Mon, 14 Jun 2021 12:27:30 +0200
Message-Id: <20210614102648.135395887@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit d5ab95da2a41567440097c277c5771ad13928dad upstream.

As LKP noticed the Sparse is not happy about strict type handling:
   .../typec/tcpm/wcove.c:380:50: sparse:     expected unsigned short [usertype] header
   .../typec/tcpm/wcove.c:380:50: sparse:     got restricted __le16 const [usertype] header

Fix this by switching to use pd_header_cnt_le() instead of pd_header_cnt()
in the affected code.

Fixes: ae8a2ca8a221 ("usb: typec: Group all TCPCI/TCPM code together")
Fixes: 3c4fb9f16921 ("usb: typec: wcove: start using tcpm for USB PD support")
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210609172202.83377-1-andriy.shevchenko@linux.intel.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/wcove.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/wcove.c
+++ b/drivers/usb/typec/tcpm/wcove.c
@@ -377,7 +377,7 @@ static int wcove_pd_transmit(struct tcpc
 		const u8 *data = (void *)msg;
 		int i;
 
-		for (i = 0; i < pd_header_cnt(msg->header) * 4 + 2; i++) {
+		for (i = 0; i < pd_header_cnt_le(msg->header) * 4 + 2; i++) {
 			ret = regmap_write(wcove->regmap, USBC_TX_DATA + i,
 					   data[i]);
 			if (ret)


