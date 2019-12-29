Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 884BB12C562
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729925AbfL2Rfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:35:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729942AbfL2Rfr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:35:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FBBE206CB;
        Sun, 29 Dec 2019 17:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640946;
        bh=11Rva7XpeI0MI+F1ZAnP6sBwik+mBxQW6wPYyPlKJGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eLcxjRcGDuQv7nfUJaVxwydarG+mRNOfQsCiO9ncjU116PsZ/CaSJTbWU5TA5d7s+
         3E/IDUzaLk5sVPn3fg3FMY1HH5F7c3DE/CFzz4+JFooEmw7zgVulT/RT3BN1XG2E8w
         m9VN47+DF33oTHD0Mkh0zQvPioNAoUugw97kj8Bs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.19 203/219] platform/x86: hp-wmi: Make buffer for HPWMI_FEATURE2_QUERY 128 bytes
Date:   Sun, 29 Dec 2019 18:20:05 +0100
Message-Id: <20191229162540.402985150@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 133b2acee3871ae6bf123b8fe34be14464aa3d2c upstream.

At least on the HP Envy x360 15-cp0xxx model the WMI interface
for HPWMI_FEATURE2_QUERY requires an outsize of at least 128 bytes,
otherwise it fails with an error code 5 (HPWMI_RET_INVALID_PARAMETERS):

Dec 06 00:59:38 kernel: hp_wmi: query 0xd returned error 0x5

We do not care about the contents of the buffer, we just want to know
if the HPWMI_FEATURE2_QUERY command is supported.

This commits bumps the buffer size, fixing the error.

Fixes: 8a1513b4932 ("hp-wmi: limit hotkey enable")
Cc: stable@vger.kernel.org
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1520703
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/hp-wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -313,7 +313,7 @@ static int __init hp_wmi_bios_2008_later
 
 static int __init hp_wmi_bios_2009_later(void)
 {
-	int state = 0;
+	u8 state[128];
 	int ret = hp_wmi_perform_query(HPWMI_FEATURE2_QUERY, HPWMI_READ, &state,
 				       sizeof(state), sizeof(state));
 	if (!ret)


