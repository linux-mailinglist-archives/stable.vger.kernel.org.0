Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38D91C4398
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 19:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730883AbgEDR7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 13:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730880AbgEDR7u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 13:59:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21DC620663;
        Mon,  4 May 2020 17:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615189;
        bh=yuYvm1fkv6a9DEkSstB0vxNmG3SmDZImH4l1nKgoB8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CMXfjA2J/TP8ysj23dHJbB+Dyic4+nmmDYc6HItikUZJRnL5szH4RiN9qQJsjr0rM
         KmSEN1WWHdc/4Ql77LQfRDvWdQUBoLhVnkoo/LCo7WQqa0Ub577BAkdd4dk3mzA8Qx
         xJ41s+jlX+zMmsTJkkDypLUFZyZ0Baxx0ICHupfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.9 08/18] PM: ACPI: Output correct message on target power state
Date:   Mon,  4 May 2020 19:57:18 +0200
Message-Id: <20200504165443.856844196@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165442.028485341@linuxfoundation.org>
References: <20200504165442.028485341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit a9b760b0266f563b4784f695bbd0e717610dc10a upstream.

Transitioned power state logged at the end of setting ACPI power.

However, D3cold won't be in the message because state can only be
D3hot at most.

Use target_state to corretly report when power state is D3cold.

Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/device_pm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -226,13 +226,13 @@ int acpi_device_set_power(struct acpi_de
  end:
 	if (result) {
 		dev_warn(&device->dev, "Failed to change power state to %s\n",
-			 acpi_power_state_string(state));
+			 acpi_power_state_string(target_state));
 	} else {
 		device->power.state = target_state;
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "Device [%s] transitioned to %s\n",
 				  device->pnp.bus_id,
-				  acpi_power_state_string(state)));
+				  acpi_power_state_string(target_state)));
 	}
 
 	return result;


