Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA666D9FCE
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395516AbfJPV6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438181AbfJPV6d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:33 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91220218DE;
        Wed, 16 Oct 2019 21:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263112;
        bh=2CA/TObIF7zAD7BxDZiWwblm2wS1nJf0LjpiGQ58re0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x4geOQKIjOkUrMVs1ODHk49+jEO0O6TSJXtnQCmb9/AgWBfZsfnyVU9RPjeVe3HrV
         XdvMSSHZX8yPdyacYW0TJITt38/FX21l+XBNPtBIV7qsrAoFVEtdd4ePy0/PjBHOFD
         EyUea9edPw/kJcaSE6y2UVwaDvzC5y8m6kNMTdQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.3 036/112] usb: typec: tcpm: usb: typec: tcpm: Fix a signedness bug in tcpm_fw_get_caps()
Date:   Wed, 16 Oct 2019 14:50:28 -0700
Message-Id: <20191016214853.834876978@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 7101949f36fc77b530b73e4c6bd0066a2740d75b upstream.

The "port->typec_caps.data" and "port->typec_caps.type" variables are
enums and in this context GCC will treat them as an unsigned int so they
can never be less than zero.

Fixes: ae8a2ca8a221 ("usb: typec: Group all TCPCI/TCPM code together")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20191001120117.GA23528@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/tcpm/tcpm.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4416,18 +4416,20 @@ static int tcpm_fw_get_caps(struct tcpm_
 	/* USB data support is optional */
 	ret = fwnode_property_read_string(fwnode, "data-role", &cap_str);
 	if (ret == 0) {
-		port->typec_caps.data = typec_find_port_data_role(cap_str);
-		if (port->typec_caps.data < 0)
-			return -EINVAL;
+		ret = typec_find_port_data_role(cap_str);
+		if (ret < 0)
+			return ret;
+		port->typec_caps.data = ret;
 	}
 
 	ret = fwnode_property_read_string(fwnode, "power-role", &cap_str);
 	if (ret < 0)
 		return ret;
 
-	port->typec_caps.type = typec_find_port_power_role(cap_str);
-	if (port->typec_caps.type < 0)
-		return -EINVAL;
+	ret = typec_find_port_power_role(cap_str);
+	if (ret < 0)
+		return ret;
+	port->typec_caps.type = ret;
 	port->port_type = port->typec_caps.type;
 
 	if (port->port_type == TYPEC_PORT_SNK)


