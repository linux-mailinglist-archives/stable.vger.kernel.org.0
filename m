Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2521AC932
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504778AbgDPPUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898674AbgDPNr0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:47:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 283BD21734;
        Thu, 16 Apr 2020 13:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044845;
        bh=x3Qs4aSBXK64Z+K9htOVT9QwK/aJU4j3a0hDBID9p/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRGPeHnksUYytNB2CbaDtAmiv7EQ70K5+g1O5n+Y0D1DlRUHGLPGJa9/GyA8RW9gf
         lRad31sJI0Zrai6ZtOFwAJ12blR/J7NGbfJahZkX4Ngr9LyXsiDuAyX+9GPBgVqop3
         IOZQ+dRMa5XJTJCiUkkAbksBKnCF1wekFYfhNVS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kristian Klausen <kristian@klausen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.4 124/232] platform/x86: asus-wmi: Support laptops where the first battery is named BATT
Date:   Thu, 16 Apr 2020 15:23:38 +0200
Message-Id: <20200416131330.587893981@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kristian Klausen <kristian@klausen.dk>

commit 6b3586d45bba14f6912f37488090c37a3710e7b4 upstream.

The WMI method to set the charge threshold does not provide a
way to specific a battery, so we assume it is the first/primary
battery (by checking if the name is BAT0).
On some newer ASUS laptops (Zenbook UM431DA) though, the
primary/first battery isn't named BAT0 but BATT, so we need
to support that case.

Fixes: 7973353e92ee ("platform/x86: asus-wmi: Refactor charge threshold to use the battery hooking API")
Cc: stable@vger.kernel.org
Signed-off-by: Kristian Klausen <kristian@klausen.dk>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/asus-wmi.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -418,8 +418,11 @@ static int asus_wmi_battery_add(struct p
 {
 	/* The WMI method does not provide a way to specific a battery, so we
 	 * just assume it is the first battery.
+	 * Note: On some newer ASUS laptops (Zenbook UM431DA), the primary/first
+	 * battery is named BATT.
 	 */
-	if (strcmp(battery->desc->name, "BAT0") != 0)
+	if (strcmp(battery->desc->name, "BAT0") != 0 &&
+	    strcmp(battery->desc->name, "BATT") != 0)
 		return -ENODEV;
 
 	if (device_create_file(&battery->dev,


