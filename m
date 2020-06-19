Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446432013C4
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392924AbgFSQDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:03:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403826AbgFSPL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:11:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1591720776;
        Fri, 19 Jun 2020 15:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579486;
        bh=56jubeqSvCe5abxjdH8iGRYSrHs+X6XVvwqLUlx67Zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NkxCDdfAHs1XAu+5yW84g3L0k7MljfwEKkjztRhtal3Vx3H+vvekViF8YWGc12OWo
         Z0vw9M5Gby9w+ZNXGM5QnTpV67jQW9GI0v6os/9OicuiKwWv7GuBrpzAI9/gV8pZFM
         8Yasf+4v6V2GOOVLt1IX5PXE2JVMpgup4sdf9kYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Chiu <chiu@endlessm.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 152/261] platform/x86: asus_wmi: Reserve more space for struct bias_args
Date:   Fri, 19 Jun 2020 16:32:43 +0200
Message-Id: <20200619141657.166997708@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Chiu <chiu@endlessm.com>

[ Upstream commit 7b91f1565fbfbe5a162d91f8a1f6c5580c2fc1d0 ]

On the ASUS laptop UX325JA/UX425JA, most of the media keys are not
working due to the ASUS WMI driver fails to be loaded. The ACPI error
as follows leads to the failure of asus_wmi_evaluate_method.
  ACPI BIOS Error (bug): AE_AML_BUFFER_LIMIT, Field [IIA3] at bit offset/length 96/32 exceeds size of target Buffer (96 bits) (20200326/dsopcode-203)
  No Local Variables are initialized for Method [WMNB]
  ACPI Error: Aborting method \_SB.ATKD.WMNB due to previous error (AE_AML_BUFFER_LIMIT) (20200326/psparse-531)

The DSDT for the WMNB part shows that 5 DWORD required for local
variables and the 3rd variable IIA3 hit the buffer limit.

Method (WMNB, 3, Serialized)
{ ..
    CreateDWordField (Arg2, Zero, IIA0)
    CreateDWordField (Arg2, 0x04, IIA1)
    CreateDWordField (Arg2, 0x08, IIA2)
    CreateDWordField (Arg2, 0x0C, IIA3)
    CreateDWordField (Arg2, 0x10, IIA4)
    Local0 = (Arg1 & 0xFFFFFFFF)
    If ((Local0 == 0x54494E49))
  ..
}

The limitation is determined by the input acpi_buffer size passed
to the wmi_evaluate_method. Since the struct bios_args is the data
structure used as input buffer by default for all ASUS WMI calls,
the size needs to be expanded to fix the problem.

Signed-off-by: Chris Chiu <chiu@endlessm.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 41e28552b2ce..b1f4a31ba1ee 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -111,6 +111,8 @@ struct bios_args {
 	u32 arg0;
 	u32 arg1;
 	u32 arg2; /* At least TUF Gaming series uses 3 dword input buffer. */
+	u32 arg4;
+	u32 arg5;
 } __packed;
 
 /*
-- 
2.25.1



