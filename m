Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF0B1B6866
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgDWXGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:06:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49568 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728383AbgDWXGq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:46 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvU-0004hJ-4m; Fri, 24 Apr 2020 00:06:36 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvR-00E6q7-Qa; Fri, 24 Apr 2020 00:06:33 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Hans de Goede" <hdegoede@redhat.com>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>
Date:   Fri, 24 Apr 2020 00:06:05 +0100
Message-ID: <lsq.1587683028.664970629@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 138/245] platform/x86: hp-wmi: Make buffer for
 HPWMI_FEATURE2_QUERY 128 bytes
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 133b2acee3871ae6bf123b8fe34be14464aa3d2c upstream.

At least on the HP Envy x360 15-cp0xxx model the WMI interface
for HPWMI_FEATURE2_QUERY requires an outsize of at least 128 bytes,
otherwise it fails with an error code 5 (HPWMI_RET_INVALID_PARAMETERS):

Dec 06 00:59:38 kernel: hp_wmi: query 0xd returned error 0x5

We do not care about the contents of the buffer, we just want to know
if the HPWMI_FEATURE2_QUERY command is supported.

This commits bumps the buffer size, fixing the error.

Fixes: 8a1513b4932 ("hp-wmi: limit hotkey enable")
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1520703
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/platform/x86/hp-wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -309,7 +309,7 @@ static int __init hp_wmi_bios_2008_later
 
 static int __init hp_wmi_bios_2009_later(void)
 {
-	int state = 0;
+	u8 state[128];
 	int ret = hp_wmi_perform_query(HPWMI_FEATURE2_QUERY, 0, &state,
 				       sizeof(state), sizeof(state));
 	if (!ret)

