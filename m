Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91774797BB
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbfG2TsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:48:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729777AbfG2TsU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:48:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B342C21655;
        Mon, 29 Jul 2019 19:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429699;
        bh=RaUJzPXr4KOk5NwG8VVoKTKUM7U3QKGQwjujiaZ0Zrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KfnwXupL5Xt36Ye56VHeJ60MfiL3M3aTimOaf2VNWNxjpW95JKGlC8iVfQhFxJA/6
         unhccS0SFgRegzmJmdqCJ7Da4BYl8pAH2aoqJdjQEdE2nK/BkrCK3Eq6ty5l/vHPzj
         0+kt+/E+4/8MlRdW7RYuwrfKGbd+toap09iPBsEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yurii Pavlovskyi <yurii.pavlovskyi@gmail.com>,
        Daniel Drake <drake@endlessm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 065/215] platform/x86: asus-wmi: Increase input buffer size of WMI methods
Date:   Mon, 29 Jul 2019 21:21:01 +0200
Message-Id: <20190729190751.690267243@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 98e865a522983f2afde075648ec9d15ea4bb9194 ]

The asus-nb-wmi driver is matched by WMI alias but fails to load on TUF
Gaming series laptops producing multiple ACPI errors in the kernel log.

The input buffer for WMI method invocation size is 2 dwords, whereas
3 are expected by this model.

FX505GM:
..
Method (WMNB, 3, Serialized)
{
    P8XH (Zero, 0x11)
    CreateDWordField (Arg2, Zero, IIA0)
    CreateDWordField (Arg2, 0x04, IIA1)
    CreateDWordField (Arg2, 0x08, IIA2)
    Local0 = (Arg1 & 0xFFFFFFFF)
    ...

Compare with older K54C:
...
Method (WMNB, 3, NotSerialized)
{
    CreateDWordField (Arg2, 0x00, IIA0)
    CreateDWordField (Arg2, 0x04, IIA1)
    Local0 = (Arg1 & 0xFFFFFFFF)
    ...

Increase buffer size to 3 dwords. No negative consequences of this change
are expected, as the input buffer size is not verified. The original
function is replaced by a wrapper for a new method passing value 0 for the
last parameter. The new function will be used to control RGB keyboard
backlight.

Signed-off-by: Yurii Pavlovskyi <yurii.pavlovskyi@gmail.com>
Reviewed-by: Daniel Drake <drake@endlessm.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 9b18a184e0aa..abfa99d18fea 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -85,6 +85,7 @@ static bool ashs_present(void)
 struct bios_args {
 	u32 arg0;
 	u32 arg1;
+	u32 arg2; /* At least TUF Gaming series uses 3 dword input buffer. */
 } __packed;
 
 /*
@@ -211,11 +212,13 @@ static void asus_wmi_input_exit(struct asus_wmi *asus)
 	asus->inputdev = NULL;
 }
 
-int asus_wmi_evaluate_method(u32 method_id, u32 arg0, u32 arg1, u32 *retval)
+static int asus_wmi_evaluate_method3(u32 method_id,
+		u32 arg0, u32 arg1, u32 arg2, u32 *retval)
 {
 	struct bios_args args = {
 		.arg0 = arg0,
 		.arg1 = arg1,
+		.arg2 = arg2,
 	};
 	struct acpi_buffer input = { (acpi_size) sizeof(args), &args };
 	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
@@ -247,6 +250,11 @@ int asus_wmi_evaluate_method(u32 method_id, u32 arg0, u32 arg1, u32 *retval)
 
 	return 0;
 }
+
+int asus_wmi_evaluate_method(u32 method_id, u32 arg0, u32 arg1, u32 *retval)
+{
+	return asus_wmi_evaluate_method3(method_id, arg0, arg1, 0, retval);
+}
 EXPORT_SYMBOL_GPL(asus_wmi_evaluate_method);
 
 static int asus_wmi_evaluate_method_agfn(const struct acpi_buffer args)
-- 
2.20.1



