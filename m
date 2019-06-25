Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30FB455517
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 18:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfFYQtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 12:49:24 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40550 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfFYQtY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 12:49:24 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so3662572wmj.5
        for <stable@vger.kernel.org>; Tue, 25 Jun 2019 09:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MFyZxw/PmmATYVOt4ZawM+qBj1/OEyzSJ/6Kyab2jWE=;
        b=N1Z3E600oJOwtEVH3C1Eo5uAwAxEnzzAlWIlPjtyUPZP6XvGIql/osbEXGEgp1Nx4k
         5sx/CxtAV7ql0CA8vLWy1cCSBLB0GDejFOFTdwI6VHwsJ+ebvt/OChHqNr2vng16MV8+
         P1XT7VOaDKQGk8PWEYAm9PcxBv7ZLAYS8LOTLPNkARiMaS6BYl5+32TquD7KccbgzNoh
         6Xv/7LN91jpzEiUMDcjdRlBZk/4p2NS4520oZDiZUshAYBXorKE3nHq2KrFM18Blv4fK
         jWdW2JO/QmrB81rMoagEqGrcJy1a9lJM/6JTAfsj2CG9JaaQ0lvl1uym9UNBF9zWzJn6
         nIIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MFyZxw/PmmATYVOt4ZawM+qBj1/OEyzSJ/6Kyab2jWE=;
        b=nZW4eIKBc0MBM76RjhcupBlGR3Q4zdKxH/H6uonQQLborz3+Y1xdM2VUqGT5Rttxnb
         rPjOhyCFnWCXrkCYlbUGxpqVaf5HQMRYwO6FsM529iAKe5PnYIRtpDLjL2tYoYOo+qys
         0bllBpWgHMgl5bHULRO/qIZhkKN9ww5rj4ri8TV155xSJQK5AuZMk9t1xXcKC+dnid61
         /+iwIanzLA4crNkpPdR+OoESoaWtOBwf56IYr/PbHnuohkzu/4yLTmowXng/3l+KoKTP
         J7hjKmfvbKWGSXjlrkRFRu9UYMjQlt+vr4ei0wKb8rTNW8L+j0VwkkDOOixnM0Hq1ltS
         wC1g==
X-Gm-Message-State: APjAAAWShb7hmnebuFaDgUvgk+M6dmS8j0cfY+yqQ5jYfG63iNeZsElq
        FfgE0beVzBVJjZJUzLuLQtw8yQ==
X-Google-Smtp-Source: APXvYqysaCd7pSOBC7N6A5J56tC0N0gGA43Mb7o4V/1MzqrHjgghtqMRBQ2q8szPaZ6cVG0tv4Dq8A==
X-Received: by 2002:a7b:c7d7:: with SMTP id z23mr21157208wmk.46.1561481362319;
        Tue, 25 Jun 2019 09:49:22 -0700 (PDT)
Received: from debian-brgl.home ([2a01:cb1d:af:5b00:6d6c:8493:1ab5:dad7])
        by smtp.gmail.com with ESMTPSA id h14sm3078652wro.30.2019.06.25.09.49.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 09:49:21 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] ARM: davinci: da830-evm: add missing regulator constraints for OHCI
Date:   Tue, 25 Jun 2019 18:49:14 +0200
Message-Id: <20190625164915.30242-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

We need to enable status changes for the fixed power supply for the USB
controller.

Fixes: 274e4c336192 ("ARM: davinci: da830-evm: add a fixed regulator for ohci-da8xx")
Cc: stable@vger.kernel.org
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 arch/arm/mach-davinci/board-da830-evm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
index aba10a2bc6b9..a273ab25c668 100644
--- a/arch/arm/mach-davinci/board-da830-evm.c
+++ b/arch/arm/mach-davinci/board-da830-evm.c
@@ -61,6 +61,9 @@ static struct regulator_consumer_supply da830_evm_usb_supplies[] = {
 static struct regulator_init_data da830_evm_usb_vbus_data = {
 	.consumer_supplies	= da830_evm_usb_supplies,
 	.num_consumer_supplies	= ARRAY_SIZE(da830_evm_usb_supplies),
+	.constraints    = {
+		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	},
 };
 
 static struct fixed_voltage_config da830_evm_usb_vbus = {
-- 
2.21.0

