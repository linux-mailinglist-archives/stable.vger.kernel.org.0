Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A8A2ABD5C
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbgKIM6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 07:58:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:52632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730122AbgKIM6S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:58:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58C2020867;
        Mon,  9 Nov 2020 12:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926697;
        bh=F7KYVWoKM0cX149P9ugGcvogZeUIF0DKMOHHXkXB/Cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xoyl57S66J3pePKNnY5X/uaVwXXzekUZoI55xti/tzN71hvDhcERvVnPhJQNxbfD2
         Rqkha5Q1NAz+yg7gPjBJ8LN10rkA6q/6tEQzvnzWTl7CoKX4PYoVZGclHUkXk3gQW1
         meJuQNdMDNnWNRYRJcMyOQNhkllH+Oee2ZpcUV4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 4.4 60/86] ARM: s3c24xx: fix missing system reset
Date:   Mon,  9 Nov 2020 13:55:07 +0100
Message-Id: <20201109125023.661445658@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

commit f6d7cde84f6c5551586c8b9b68d70f8e6dc9a000 upstream.

Commit f6361c6b3880 ("ARM: S3C24XX: remove separate restart code")
removed usage of the watchdog reset platform code in favor of the
Samsung SoC watchdog driver.  However the latter was not selected thus
S3C24xx platforms lost reset abilities.

Cc: <stable@vger.kernel.org>
Fixes: f6361c6b3880 ("ARM: S3C24XX: remove separate restart code")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -676,7 +676,9 @@ config ARCH_S3C24XX
 	select HAVE_S3C_RTC if RTC_CLASS
 	select MULTI_IRQ_HANDLER
 	select NEED_MACH_IO_H
+	select S3C2410_WATCHDOG
 	select SAMSUNG_ATAGS
+	select WATCHDOG
 	help
 	  Samsung S3C2410, S3C2412, S3C2413, S3C2416, S3C2440, S3C2442, S3C2443
 	  and S3C2450 SoCs based systems, such as the Simtec Electronics BAST


