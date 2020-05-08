Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B8F1CAD48
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgEHNAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729951AbgEHMwZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:52:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48D6F218AC;
        Fri,  8 May 2020 12:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942344;
        bh=nVcYsa2JnQlt53ghbuwwTdE45CPzc9/yUgMq+3xxz3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sUWktnc/UyzDeDM3Z1lyWRQ2FRLzNzpAF1ZLKnPmvlBn9tGghvdH81Z2TmGPYWao7
         6IS/fvioFJ2lt84o2q428eZR6+Z1oZOPuw+BidEYBj/m3AiOYscwgbEsZdDYqnW1HL
         tLXZ7rTEAGfWFC4QQ1XTje1bOPzkH5640yatoHnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, AceLan Kao <acelan.kao@canonical.com>,
        Tuowen Zhao <ztuowen@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Roman Gilg <subdiff@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 25/32] mfd: intel-lpss: Use devm_ioremap_uc for MMIO
Date:   Fri,  8 May 2020 14:35:38 +0200
Message-Id: <20200508123038.544813235@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123034.886699170@linuxfoundation.org>
References: <20200508123034.886699170@linuxfoundation.org>
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
@@ -397,7 +397,7 @@ int intel_lpss_probe(struct device *dev,
 	if (!lpss)
 		return -ENOMEM;
 
-	lpss->priv = devm_ioremap(dev, info->mem->start + LPSS_PRIV_OFFSET,
+	lpss->priv = devm_ioremap_uc(dev, info->mem->start + LPSS_PRIV_OFFSET,
 				  LPSS_PRIV_SIZE);
 	if (!lpss->priv)
 		return -ENOMEM;


