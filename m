Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33663835D3
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241411AbhEQPZc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:25:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244870AbhEQPWU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:22:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E4BC61C84;
        Mon, 17 May 2021 14:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262096;
        bh=XJKbguoopuPLDIt7225+WeiVj+1f/Rx9vv+vr4EtPhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zk/FG8xJPMLRwCk+Uzn80Lt4ZoaQdnFJblnMIOHMAKOicTmevF9ByIwdZ2dltcbXd
         lzfVlTwFzj9O46Jzik3YZhbgfXbNoPe2z0A799wxaGF5tVnShPhv6vsfUJBGMhgAmw
         BQ4g+YUgwP3ESZdSX01TXRe5PaHGtddHOy2B/RzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 5.4 136/141] usb: typec: tcpm: Fix error while calculating PPS out values
Date:   Mon, 17 May 2021 16:03:08 +0200
Message-Id: <20210517140247.406555170@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Badhri Jagan Sridharan <badhri@google.com>

commit 374157ff88ae1a7f7927331cbc72c1ec11994e8a upstream.

"usb: typec: tcpm: Address incorrect values of tcpm psy for pps supply"
introduced a regression for req_out_volt and req_op_curr calculation.

req_out_volt should consider the newly calculated max voltage instead
of previously accepted max voltage by the port partner. Likewise,
req_op_curr should consider the newly calculated max current instead
of previously accepted max current by the port partner.

Fixes: e3a072022487 ("usb: typec: tcpm: Address incorrect values of tcpm psy for pps supply")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://lore.kernel.org/r/20210415050121.1928298-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2339,10 +2339,10 @@ static unsigned int tcpm_pd_select_pps_a
 		port->pps_data.req_max_volt = min(pdo_pps_apdo_max_voltage(src),
 						  pdo_pps_apdo_max_voltage(snk));
 		port->pps_data.req_max_curr = min_pps_apdo_current(src, snk);
-		port->pps_data.req_out_volt = min(port->pps_data.max_volt,
-						  max(port->pps_data.min_volt,
+		port->pps_data.req_out_volt = min(port->pps_data.req_max_volt,
+						  max(port->pps_data.req_min_volt,
 						      port->pps_data.req_out_volt));
-		port->pps_data.req_op_curr = min(port->pps_data.max_curr,
+		port->pps_data.req_op_curr = min(port->pps_data.req_max_curr,
 						 port->pps_data.req_op_curr);
 	}
 


