Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7BB1C4378
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 19:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbgEDR6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 13:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730445AbgEDR6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 13:58:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0C9920707;
        Mon,  4 May 2020 17:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615121;
        bh=Ch+9jydRbx+Y2XO2w7/HHuybV5IpP4ly0FO6bfnAURw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mtfCD39gS5XQJYaagu+FU9XH9cMzgUvSvkBbv88BLmuOpFHSrm0BdyEKaumVlFAVH
         TRmcjC7Mrp9jIjs/IDgWn9YplIzi4cwK0RY1OIvKMAOv7/poVz4BJedoSBBu0zTj7C
         hFSECPq7aNCQkxJkDt6sby/8Qy0Eus8PF1VBiFE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.4 04/18] PM: ACPI: Output correct message on target power state
Date:   Mon,  4 May 2020 19:57:02 +0200
Message-Id: <20200504165442.587185825@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165441.533160703@linuxfoundation.org>
References: <20200504165441.533160703@linuxfoundation.org>
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
@@ -225,13 +225,13 @@ int acpi_device_set_power(struct acpi_de
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


