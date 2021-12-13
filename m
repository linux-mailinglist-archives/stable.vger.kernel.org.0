Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1ACA472976
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242710AbhLMKVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244979AbhLMKTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:19:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF18BC061372;
        Mon, 13 Dec 2021 01:57:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 655F1B80D1F;
        Mon, 13 Dec 2021 09:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBC1C34600;
        Mon, 13 Dec 2021 09:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389425;
        bh=CgMYysd0TA8DhbrcV7B1wea/kp965wimdaqwVSQWBT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqNjO9s2KRZgFEDrwZnwoUKVPSO9dvvM17W24jdhjKJ+zpxxj1NiuEw6dZ1qkCaEO
         dxv3c2+QLIztqPEH8rlKhJnIKQDxy39dGUxA1n4IuS9ky6elrqDnFTYzaaJDxVE/SN
         Ca6f9YcEv0KDvZcPudGyP0ezurrIXtlG8gu9MCLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 091/171] thermal: int340x: Fix VCoRefLow MMIO bit offset for TGL
Date:   Mon, 13 Dec 2021 10:30:06 +0100
Message-Id: <20211213092948.110779522@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>

commit f872f73601b92c86f3da8bdf3e19abd0f1780eb9 upstream.

The VCoRefLow CPU FIVR register definition for Tiger Lake is incorrect.

Current implementation reads it from MMIO offset 0x5A18 and bit
offset [12:14], but the actual correct register definition is from
bit offset [11:13].

Update to fix the bit offset.

Fixes: 473be51142ad ("thermal: int340x: processor_thermal: Add RFIM driver")
Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
Cc: 5.14+ <stable@vger.kernel.org> # 5.14+
[ rjw: New subject, changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
@@ -29,7 +29,7 @@ static const char * const fivr_strings[]
 };
 
 static const struct mmio_reg tgl_fivr_mmio_regs[] = {
-	{ 0, 0x5A18, 3, 0x7, 12}, /* vco_ref_code_lo */
+	{ 0, 0x5A18, 3, 0x7, 11}, /* vco_ref_code_lo */
 	{ 0, 0x5A18, 8, 0xFF, 16}, /* vco_ref_code_hi */
 	{ 0, 0x5A08, 8, 0xFF, 0}, /* spread_spectrum_pct */
 	{ 0, 0x5A08, 1, 0x1, 8}, /* spread_spectrum_clk_enable */


