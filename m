Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0760A43F64
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389150AbfFMP4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731513AbfFMIu6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:50:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AE83206BA;
        Thu, 13 Jun 2019 08:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415857;
        bh=jLVWDgVeETsgKejl+TYNmBkhZacQwqmmS8UtuiNJ1KU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gkto+JTn5sYZGifIy2tv8LXguYjbSEc3rfeXbmQr3D40in7qsWC/BbsMxDUWGO9o7
         Ud/b7nj6CniC8Oq5whNvYSu9r/yAy54lu8xvEB8ojIUtwTAFO2gWePhazwRpCiSEof
         R8V5Zp6ETPQYCyfK9ajsNSaleT/QztQzMQAUCLZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 147/155] usb: typec: fusb302: Check vconn is off when we start toggling
Date:   Thu, 13 Jun 2019 10:34:19 +0200
Message-Id: <20190613075701.147411322@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
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
 drivers/usb/typec/tcpm/fusb302.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/typec/tcpm/fusb302.c b/drivers/usb/typec/tcpm/fusb302.c
index e9344997329c..d8b128ed08af 100644
--- a/drivers/usb/typec/tcpm/fusb302.c
+++ b/drivers/usb/typec/tcpm/fusb302.c
@@ -634,6 +634,8 @@ static int fusb302_set_toggling(struct fusb302_chip *chip,
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



