Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75947324D71
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 11:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234444AbhBYKA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 05:00:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:34804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233502AbhBYJ6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 04:58:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7594064F14;
        Thu, 25 Feb 2021 09:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246880;
        bh=JgJTsMKTkN9T9S2tFVLy/QvE+tfyY7nMcom9gBDkhGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1ALLHwYaCThM6MdxiFgx22b7FbdNJBsrLlcCVg08wVdcV9zYd50GgnZJafoEauwz
         9c9RHWsbyDp3CyL25b3zcYxjulkpL0+biI12uThShYrwMefH3aaXkpMyQBVSgeH+ae
         bUfxhx8XBVHQ0zNKiR5YKY/I5B8BzV/iO8Np7WZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Hepple <bob.hepple@gmail.com>,
        Thomas Hebb <tommyhebb@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 11/23] hwmon: (dell-smm) Add XPS 15 L502X to fan control blacklist
Date:   Thu, 25 Feb 2021 10:53:42 +0100
Message-Id: <20210225092517.071550881@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210225092516.531932232@linuxfoundation.org>
References: <20210225092516.531932232@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hebb <tommyhebb@gmail.com>

commit 4008bc7d39537bb3be166d8a3129c4980e1dd7dc upstream.

It has been reported[0] that the Dell XPS 15 L502X exhibits similar
freezing behavior to the other systems[1] on this blacklist. The issue
was exposed by a prior change of mine to automatically load
dell_smm_hwmon on a wider set of XPS models. To fix the regression, add
this model to the blacklist.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=211081
[1] https://bugzilla.kernel.org/show_bug.cgi?id=195751

Fixes: b8a13e5e8f37 ("hwmon: (dell-smm) Use one DMI match for all XPS models")
Cc: stable@vger.kernel.org
Reported-by: Bob Hepple <bob.hepple@gmail.com>
Tested-by: Bob Hepple <bob.hepple@gmail.com>
Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
Reviewed-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/a09eea7616881d40d2db2fb5fa2770dc6166bdae.1611456351.git.tommyhebb@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/dell-smm-hwmon.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -1159,6 +1159,13 @@ static struct dmi_system_id i8k_blacklis
 			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "XPS13 9333"),
 		},
 	},
+	{
+		.ident = "Dell XPS 15 L502X",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Dell System XPS L502X"),
+		},
+	},
 	{ }
 };
 


