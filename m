Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6371133DE
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731071AbfLDSJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:09:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:35332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731069AbfLDSJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:09:31 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2D7420833;
        Wed,  4 Dec 2019 18:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482970;
        bh=HLzYD/HbGyf9vZgF+em7Xrr/GbFuua27gc0B8hIZUeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tAODdpRmvUj+C0q4Hgi6OdJbcSey+4Jp2Bzy9QToiyc6qduo3HKGnY4INg9B7Vyk/
         oKtZOAH7UGImJBxY/le5WoSNW4ts4ieu1r3I6FVG0vxOofhade5K/qSLIRJ6ZWs3Be
         00EQU4NyddFWeOhe14DmaIcV2KV2wZ4cQdPh0wgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.14 208/209] platform/x86: hp-wmi: Fix ACPI errors caused by passing 0 as input size
Date:   Wed,  4 Dec 2019 18:57:00 +0100
Message-Id: <20191204175337.805782234@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit f3e4f3fc8ee9729c4b1b27a478c68b713df53c0c upstream.

The AML code implementing the WMI methods creates a variable length
field to hold the input data we pass like this:

        CreateDWordField (Arg1, 0x0C, DSZI)
        Local5 = DSZI /* \HWMC.DSZI */
        CreateField (Arg1, 0x80, (Local5 * 0x08), DAIN)

If we pass 0 as bios_args.datasize argument then (Local5 * 0x08)
is 0 which results in these errors:

[   71.973305] ACPI BIOS Error (bug): Attempt to CreateField of length zero (20190816/dsopcode-133)
[   71.973332] ACPI Error: Aborting method \HWMC due to previous error (AE_AML_OPERAND_VALUE) (20190816/psparse-529)
[   71.973413] ACPI Error: Aborting method \_SB.WMID.WMAA due to previous error (AE_AML_OPERAND_VALUE) (20190816/psparse-529)

And in our HPWMI_WIRELESS2_QUERY calls always failing. for read commands
like HPWMI_WIRELESS2_QUERY the DSZI value is not used / checked, except for
read commands where extra input is needed to specify exactly what to read.

So for HPWMI_WIRELESS2_QUERY we can safely pass the size of the expected
output as insize to hp_wmi_perform_query(), as we are already doing for all
other HPWMI_READ commands we send. Doing so fixes these errors.

Cc: stable@vger.kernel.org
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=197007
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=201981
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1520703
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/hp-wmi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -393,7 +393,7 @@ static int hp_wmi_rfkill2_refresh(void)
 	int err, i;
 
 	err = hp_wmi_perform_query(HPWMI_WIRELESS2_QUERY, HPWMI_READ, &state,
-				   0, sizeof(state));
+				   sizeof(state), sizeof(state));
 	if (err)
 		return err;
 
@@ -790,7 +790,7 @@ static int __init hp_wmi_rfkill2_setup(s
 	int err, i;
 
 	err = hp_wmi_perform_query(HPWMI_WIRELESS2_QUERY, HPWMI_READ, &state,
-				   0, sizeof(state));
+				   sizeof(state), sizeof(state));
 	if (err)
 		return err < 0 ? err : -EINVAL;
 


