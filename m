Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6506D44283
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391201AbfFMQXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:23:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731032AbfFMIhx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:37:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59C1B2064A;
        Thu, 13 Jun 2019 08:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415072;
        bh=+w6dRpNnrCmmmlRULKh/z17yNWgC4fRdHy6w/+up7o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gwf/e5rDoRmikZ8fUI44X8fMKI2A98AHC5Y61tnEdjoC0u9/P6oFqTYK3CL/tliPF
         q6QVGHGRqq66wrKvK4Pc1gL/q4YXKUN6DUmKqn72Ro8nWjkWIjwx7dhSxI57QCNQ9L
         L4chAsJN1NnHRDoJGAf18/1cCD3bZtsbmQ/N/5Dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 76/81] usb: typec: fusb302: Check vconn is off when we start toggling
Date:   Thu, 13 Jun 2019 10:33:59 +0200
Message-Id: <20190613075654.574970904@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
References: <20190613075649.074682929@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 32a155b1a83d6659e2272e8e1eec199667b1897e ]

The datasheet says the vconn MUST be off when we start toggling. The
tcpm.c state-machine is responsible to make sure vconn is off, but lets
add a WARN to catch any cases where vconn is not off for some reason.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/typec/fusb302/fusb302.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/typec/fusb302/fusb302.c b/drivers/staging/typec/fusb302/fusb302.c
index 7d9f25db1add..794dbc34973f 100644
--- a/drivers/staging/typec/fusb302/fusb302.c
+++ b/drivers/staging/typec/fusb302/fusb302.c
@@ -671,6 +671,8 @@ static int fusb302_set_toggling(struct fusb302_chip *chip,
 			return ret;
 		chip->intr_togdone = false;
 	} else {
+		/* Datasheet says vconn MUST be off when toggling */
+		WARN(chip->vconn_on, "Vconn is on during toggle start");
 		/* unmask TOGDONE interrupt */
 		ret = fusb302_i2c_clear_bits(chip, FUSB_REG_MASKA,
 					     FUSB_REG_MASKA_TOGDONE);
-- 
2.20.1



