Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3F728B94C
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389450AbgJLN7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:59:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388781AbgJLNkM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:40:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80062221FE;
        Mon, 12 Oct 2020 13:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510011;
        bh=AG1TfoMTwzFHLKKQyRE0DQy1LySPs80CkCMyJyxDNtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o9YvTClPl5Zh+RrAAMLRLxGvZVUTUyEh8eNml8jE3a6o05IdX0zfLj5QVcDtg/1pN
         GIwqLBuTc3M7lUKWs9LVpY9cyZyfHiBYV5of04d/CfoMek5TYUnvA4uGTYkY+KCJ/+
         V9nKNjYCLnMWgLv0K+aXWPSkV150D0uizNQMIGKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 35/49] platform/x86: fix kconfig dependency warning for FUJITSU_LAPTOP
Date:   Mon, 12 Oct 2020 15:27:21 +0200
Message-Id: <20201012132631.074994688@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.469542486@linuxfoundation.org>
References: <20201012132629.469542486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Necip Fazil Yildiran <fazilyildiran@gmail.com>

[ Upstream commit afdd1ebb72051e8b6b83c4d7dc542a9be0e1352d ]

When FUJITSU_LAPTOP is enabled and NEW_LEDS is disabled, it results in the
following Kbuild warning:

WARNING: unmet direct dependencies detected for LEDS_CLASS
  Depends on [n]: NEW_LEDS [=n]
  Selected by [y]:
  - FUJITSU_LAPTOP [=y] && X86 [=y] && X86_PLATFORM_DEVICES [=y] && ACPI [=y] && INPUT [=y] && BACKLIGHT_CLASS_DEVICE [=y] && (ACPI_VIDEO [=n] || ACPI_VIDEO [=n]=n)

The reason is that FUJITSU_LAPTOP selects LEDS_CLASS without depending on
or selecting NEW_LEDS while LEDS_CLASS is subordinate to NEW_LEDS.

Honor the kconfig menu hierarchy to remove kconfig dependency warnings.

Reported-by: Hans de Goede <hdegoede@redhat.com>
Fixes: d89bcc83e709 ("platform/x86: fujitsu-laptop: select LEDS_CLASS")
Signed-off-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 1e2524de6a63c..a13bb4ddd0cf1 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -235,6 +235,7 @@ config FUJITSU_LAPTOP
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on ACPI_VIDEO || ACPI_VIDEO = n
 	select INPUT_SPARSEKMAP
+	select NEW_LEDS
 	select LEDS_CLASS
 	---help---
 	  This is a driver for laptops built by Fujitsu:
-- 
2.25.1



