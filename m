Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881C83A6419
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbhFNLUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:20:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232779AbhFNLSX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:18:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 640FE61463;
        Mon, 14 Jun 2021 10:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667843;
        bh=3tpArH6l/uQRXlDijWGYKHxpEVEbw5HapPsnbq+YW2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m6DalMSQOkiBE7F6F+DkBHnGmN/nCmw8C20POMihQfwu5TOwmwYTCAgbuUTAsTMyu
         zdUEe5nFk08ecN65Zm8sM5spR3NrjLTTX+1dPVtaw5T4q1QpM7l7Cx/vqP+IDRsKfY
         d+fTJQXqXvtO5nAnYOJ5VZ3ZDKI+Mrm6/YNHVTuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.12 095/173] usb: typec: wcove: Use LE to CPU conversion when accessing msg->header
Date:   Mon, 14 Jun 2021 12:27:07 +0200
Message-Id: <20210614102701.327630638@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
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
@@ -378,7 +378,7 @@ static int wcove_pd_transmit(struct tcpc
 		const u8 *data = (void *)msg;
 		int i;
 
-		for (i = 0; i < pd_header_cnt(msg->header) * 4 + 2; i++) {
+		for (i = 0; i < pd_header_cnt_le(msg->header) * 4 + 2; i++) {
 			ret = regmap_write(wcove->regmap, USBC_TX_DATA + i,
 					   data[i]);
 			if (ret)


