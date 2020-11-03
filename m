Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3992A57FC
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731928AbgKCUvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:51:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731921AbgKCUvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:51:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D993622404;
        Tue,  3 Nov 2020 20:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436669;
        bh=sXan1nAS0f593JpMG0xDuKoxr2+n90gQdTJYmpCswxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AjbMDmvQ1hdsMdOZ/FLU2VGTWIJ5TiP1WcbLv7Q7sFmb+iAFwQ6f4PBoEtNR8MVgL
         0fkhgMpTLDn26neOnRG5wL4q8/l92CnAOV7fP+mB+5ljwFesLuD8spLRH6Qo26mok7
         chO+4wui4stW/uShpFA4UbvBL+EcIB86hfTH8Ysk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.9 352/391] mmc: sdhci: Use Auto CMD Auto Select only when v4_mode is true
Date:   Tue,  3 Nov 2020 21:36:43 +0100
Message-Id: <20201103203410.889558968@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

commit b3e1ea16fb39fb6e1a1cf1dbdd6738531de3dc7d upstream.

sdhci-of-dwcmshc meets an eMMC read performance regression with below
command after commit 427b6514d095 ("mmc: sdhci: Add Auto CMD Auto
Select support"):

dd if=/dev/mmcblk0 of=/dev/null bs=8192 count=100000

Before the commit, the above command gives 120MB/s
After the commit, the above command gives 51.3 MB/s

So it looks like sdhci-of-dwcmshc expects Version 4 Mode for Auto
CMD Auto Select. Fix the performance degradation by ensuring v4_mode
is true to use Auto CMD Auto Select.

Fixes: 427b6514d095 ("mmc: sdhci: Add Auto CMD Auto Select support")
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201015174115.4cf2c19a@xhacker.debian
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1384,9 +1384,11 @@ static inline void sdhci_auto_cmd_select
 	/*
 	 * In case of Version 4.10 or later, use of 'Auto CMD Auto
 	 * Select' is recommended rather than use of 'Auto CMD12
-	 * Enable' or 'Auto CMD23 Enable'.
+	 * Enable' or 'Auto CMD23 Enable'. We require Version 4 Mode
+	 * here because some controllers (e.g sdhci-of-dwmshc) expect it.
 	 */
-	if (host->version >= SDHCI_SPEC_410 && (use_cmd12 || use_cmd23)) {
+	if (host->version >= SDHCI_SPEC_410 && host->v4_mode &&
+	    (use_cmd12 || use_cmd23)) {
 		*mode |= SDHCI_TRNS_AUTO_SEL;
 
 		ctrl2 = sdhci_readw(host, SDHCI_HOST_CONTROL2);


