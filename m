Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 190CDBA45D
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391531AbfIVSsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:48:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391513AbfIVSsR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:48:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16DA1214D9;
        Sun, 22 Sep 2019 18:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178097;
        bh=ZaoPHwtLHsvaA+ZAcx1/9Bq15BWjd0+3loZmP5V6Kmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UJDEh8YUep+macwhKWOs3hlEqxI8JMN6mpkKlP1FL0pEuTn7DsHbjyhB2HLsbXUwy
         s+Nd6nzykiIcJTAq43sV7VouN0Nm0QE8e+yYVCV1YcZEJcdinWK5nnaZv83lwQP8vd
         xAvDmGlMOgs6qrLa4z5eUVl6Ac9zddi/F1PvKvb4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcel Bocu <marcel.p.bocu@gmail.com>, Vicki Pfau <vi@endrift.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Woods, Brian" <Brian.Woods@amd.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-hwmon@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 160/203] hwmon: (k10temp) Add support for AMD family 17h, model 70h CPUs
Date:   Sun, 22 Sep 2019 14:43:06 -0400
Message-Id: <20190922184350.30563-160-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Bocu <marcel.p.bocu@gmail.com>

[ Upstream commit 12163cfbfc0f804cc7d27bc20e8d266ce7459260 ]

It would seem like model 70h is behaving in the same way as model 30h,
so let's just add the new F3 PCI ID to the list of compatible devices.

Unlike previous Ryzen/Threadripper, Ryzen gen 3 processors do not need
temperature offsets anymore. This has been reported in the press and
verified on my Ryzen 3700X by checking that the idle temperature
reported by k10temp is matching the temperature reported by the
firmware.

Vicki Pfau sent an identical patch after I checked that no-one had
written this patch. I would have been happy about dropping my patch but
unlike for his patch series, I had already Cc:ed the x86 people and
they already reviewed the changes. Since Vicki has not answered to
any email after his initial series, let's assume she is on vacation
and let's avoid duplication of reviews from the maintainers and merge
my series. To acknowledge Vicki's anteriority, I added her S-o-b to
the patch.

v2, suggested by Guenter Roeck and Brian Woods:
  - rename from 71h to 70h

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Marcel Bocu <marcel.p.bocu@gmail.com>
Tested-by: Marcel Bocu <marcel.p.bocu@gmail.com>

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: "Woods, Brian" <Brian.Woods@amd.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: linux-hwmon@vger.kernel.org
Link: https://lore.kernel.org/r/20190722174653.2391-1-marcel.p.bocu@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/k10temp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
index c77e89239dcd9..5c1dddde193c3 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -349,6 +349,7 @@ static const struct pci_device_id k10temp_id_table[] = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_17H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_17H_M10H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_17H_M30H_DF_F3) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_17H_M70H_DF_F3) },
 	{ PCI_VDEVICE(HYGON, PCI_DEVICE_ID_AMD_17H_DF_F3) },
 	{}
 };
-- 
2.20.1

