Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26701CAD38
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbgEHM7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:59:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729914AbgEHMxc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:53:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F3EA24963;
        Fri,  8 May 2020 12:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942411;
        bh=tYCmFYG1c80BdMRSWHjwTjudD6VVh+EKEYME+PVr0eU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m14aK9JD+w6cN8dInbuJGDX/bfAIRjCT0yMUUBvQAQ5xk4wnaMaI2wJgbgi+Z0A50
         rt9p4GSulmIJfMtGZxzJbdQOf9WYVW7CxZqBcJw+658jUdii4LxMpTBndzAA3IGe0p
         Z8wVzPglusCAUJA35xq56CS3PKxJ6IQ0dhgrd6c4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, AceLan Kao <acelan.kao@canonical.com>,
        Tuowen Zhao <ztuowen@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Roman Gilg <subdiff@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5.4 35/50] mfd: intel-lpss: Use devm_ioremap_uc for MMIO
Date:   Fri,  8 May 2020 14:35:41 +0200
Message-Id: <20200508123048.223733664@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123043.085296641@linuxfoundation.org>
References: <20200508123043.085296641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuowen Zhao <ztuowen@gmail.com>

commit a8ff78f7f773142eb8a8befe5a95dd6858ebd635 upstream.

Some BIOS erroneously specifies write-combining BAR for intel-lpss-pci
in MTRR. This will cause the system to hang during boot. If possible,
this bug could be corrected with a firmware update.

This patch use devm_ioremap_uc to overwrite/ignore the MTRR settings
by forcing the use of strongly uncachable pages for intel-lpss.

The BIOS bug is present on Dell XPS 13 7390 2-in-1:

[    0.001734]   5 base 4000000000 mask 6000000000 write-combining

4000000000-7fffffffff : PCI Bus 0000:00
  4000000000-400fffffff : 0000:00:02.0 (i915)
  4010000000-4010000fff : 0000:00:15.0 (intel-lpss-pci)

Link: https://bugzilla.kernel.org/show_bug.cgi?id=203485
Cc: <stable@vger.kernel.org> # v4.19+
Tested-by: AceLan Kao <acelan.kao@canonical.com>
Signed-off-by: Tuowen Zhao <ztuowen@gmail.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Roman Gilg <subdiff@gmail.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/intel-lpss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/intel-lpss.c
+++ b/drivers/mfd/intel-lpss.c
@@ -384,7 +384,7 @@ int intel_lpss_probe(struct device *dev,
 	if (!lpss)
 		return -ENOMEM;
 
-	lpss->priv = devm_ioremap(dev, info->mem->start + LPSS_PRIV_OFFSET,
+	lpss->priv = devm_ioremap_uc(dev, info->mem->start + LPSS_PRIV_OFFSET,
 				  LPSS_PRIV_SIZE);
 	if (!lpss->priv)
 		return -ENOMEM;


