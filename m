Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45162ABC9E
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731605AbgKINjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:39:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:56264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730678AbgKINDk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:03:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3736E21D46;
        Mon,  9 Nov 2020 13:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927017;
        bh=5fm9iP3JJcUaxyTU0dbGWZJSO4/FH9AAl1Q3x8oSung=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HpJoh2zBeT5APoH1udoSTXqqqxp3+41NI/8Ku+dZ/JgrDVG2xlSX5j2uNi/jLl6YE
         81NfvI5WQ2kJSAIoyCNMk/uVNOglpaIbz13esBrFOzg0L1vUaYs7KudS5HZzCDxNh3
         mVSQfTqbyo4julwWU2+dZCkIaM0bTE2AeNlU86hQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Hung <alex.hung@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.9 052/117] ACPI: video: use ACPI backlight for HP 635 Notebook
Date:   Mon,  9 Nov 2020 13:54:38 +0100
Message-Id: <20201109125028.137726692@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Hung <alex.hung@canonical.com>

commit b226faab4e7890bbbccdf794e8b94276414f9058 upstream.

The default backlight interface is AMD's radeon_bl0 which does not
work on this system, so use the ACPI backlight interface on it
instead.

BugLink: https://bugs.launchpad.net/bugs/1894667
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Alex Hung <alex.hung@canonical.com>
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/video_detect.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -268,6 +268,15 @@ static const struct dmi_system_id video_
 		DMI_MATCH(DMI_PRODUCT_NAME, "530U4E/540U4E"),
 		},
 	},
+	/* https://bugs.launchpad.net/bugs/1894667 */
+	{
+	 .callback = video_detect_force_video,
+	 .ident = "HP 635 Notebook",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP 635 Notebook PC"),
+		},
+	},
 
 	/* Non win8 machines which need native backlight nevertheless */
 	{


