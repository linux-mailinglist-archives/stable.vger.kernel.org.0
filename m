Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 275F314E26D
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730729AbgA3Sn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:43:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730725AbgA3Sn5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:43:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 587E2214DB;
        Thu, 30 Jan 2020 18:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409836;
        bh=UGgShfD6ZVGUoofdDk7TTAKKPgJ/LDgem8dtriwzlOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQ5ZqOysIjMzUx8BTDlMsMvv14JEKPASl39kSUMQ1s/XDTeq2uUqxPAmACvzl+UXO
         PHG5LQ5SMe1aGOaKxqRm6aPvRBJ5mxRxcMFNmpd6OAJidLidiDQor8mRo7r2j4nWtR
         Eqilz4KEaXAaKwH65vC+Pxw/4scSZOkE4zwRN0Zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Hebb <tommyhebb@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.4 011/110] usb: typec: fusb302: fix "op-sink-microwatt" default that was in mW
Date:   Thu, 30 Jan 2020 19:37:47 +0100
Message-Id: <20200130183615.626808068@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hebb <tommyhebb@gmail.com>

commit eb7a3bb8c955b3694e0e0998413ce1563c02f90c upstream.

commit 8f6244055bd3 ("usb: typec: fusb302: Always provide fwnode for the
port") didn't convert this value from mW to uW when migrating to a new
specification format like it should have.

Fixes: 8f6244055bd3 ("usb: typec: fusb302: Always provide fwnode for the port")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/0da564559af75ec829c6c7e3aa4024f857c91bee.1579529334.git.tommyhebb@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/tcpm/fusb302.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/fusb302.c
+++ b/drivers/usb/typec/tcpm/fusb302.c
@@ -1666,7 +1666,7 @@ static const struct property_entry port_
 	PROPERTY_ENTRY_STRING("try-power-role", "sink"),
 	PROPERTY_ENTRY_U32_ARRAY("source-pdos", src_pdo),
 	PROPERTY_ENTRY_U32_ARRAY("sink-pdos", snk_pdo),
-	PROPERTY_ENTRY_U32("op-sink-microwatt", 2500),
+	PROPERTY_ENTRY_U32("op-sink-microwatt", 2500000),
 	{ }
 };
 


