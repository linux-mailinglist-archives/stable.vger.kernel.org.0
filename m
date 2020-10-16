Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0BB290146
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406025AbgJPJMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395039AbgJPJKk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:10:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4511020FC3;
        Fri, 16 Oct 2020 09:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839439;
        bh=eHc+/qqrYgbIXejTNoxy4U8QV9sWZPn7f0Uzldih83U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WN5i3QRJvqNbTgYb1JYp8VauS8LFxRqbXkLkx+/3K/lEi9ZQxCJuVx9B9hckHcrv/
         08wCEgiySdatICb3f+U88ABTUgJfqLLlOcny1ysBGsPgIA4CcXVGKvxamCrKtEIEM3
         Hg2kKoCRS2849Lc7IXJ+i3C+Tl8bDsqCDhFohWfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Vishnu Rangayyan <vishnu.rangayyan@apple.com>
Subject: [PATCH 5.4 05/22] ACPI: Always build evged in
Date:   Fri, 16 Oct 2020 11:07:33 +0200
Message-Id: <20201016090437.581666186@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.308349327@linuxfoundation.org>
References: <20201016090437.308349327@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

commit ac36d37e943635fc072e9d4f47e40a48fbcdb3f0 upstream.

Although the Generic Event Device is a Hardware-reduced
platfom device in principle, it should not be restricted to
ACPI_REDUCED_HARDWARE_ONLY.

Kernels supporting both fixed and hardware-reduced ACPI platforms
should be able to probe the GED when dynamically detecting that a
platform is hardware-reduced. For that, the driver must be
unconditionally built in.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Vishnu Rangayyan <vishnu.rangayyan@apple.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -48,7 +48,7 @@ acpi-y				+= acpi_pnp.o
 acpi-$(CONFIG_ARM_AMBA)	+= acpi_amba.o
 acpi-y				+= power.o
 acpi-y				+= event.o
-acpi-$(CONFIG_ACPI_REDUCED_HARDWARE_ONLY) += evged.o
+acpi-y				+= evged.o
 acpi-y				+= sysfs.o
 acpi-y				+= property.o
 acpi-$(CONFIG_X86)		+= acpi_cmos_rtc.o


