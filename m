Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D2A34CA24
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234320AbhC2IfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:35:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233354AbhC2IeD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:34:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3AF561883;
        Mon, 29 Mar 2021 08:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006843;
        bh=fAfv0dCzxjcggOMs3qlBfIdzQSmtCL0l8bMzWH+lJUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SUGABZfTREdqI3Llm5fDGZ3NzkeWiQ5xbuDUJ0KbNtaLVupKYcPyQ/t/oFM6Wzf4b
         wkmlG59A/93dcMU49y3qozQFvKdXM+NSgtucUGsYHzGAu/sNUsS/FBNHTJ9IFX6wqI
         4ColOngKxz9nl4k3wpb+2Z36AEsZaMK2ozu5nBCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Chiu <chris.chiu@canonical.com>,
        Pavel Machek <pavel@ucw.cz>,
        "Pavel Machek (CIP)" <pavel@denx.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.11 085/254] ACPI: video: Add missing callback back for Sony VPCEH3U1E
Date:   Mon, 29 Mar 2021 09:56:41 +0200
Message-Id: <20210329075635.962409037@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Chiu <chris.chiu@canonical.com>

commit c1d1e25a8c542816ae8dee41b81a18d30c7519a0 upstream.

The .callback of the quirk for Sony VPCEH3U1E was unintetionally
removed by the commit 25417185e9b5 ("ACPI: video: Add DMI quirk
for GIGABYTE GB-BXBT-2807"). Add it back to make sure the quirk
for Sony VPCEH3U1E works as expected.

Fixes: 25417185e9b5 ("ACPI: video: Add DMI quirk for GIGABYTE GB-BXBT-2807")
Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
Reported-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Pavel Machek (CIP) <pavel@denx.de>
Cc: 5.11+ <stable@vger.kernel.org> # 5.11+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/video_detect.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -147,6 +147,7 @@ static const struct dmi_system_id video_
 		},
 	},
 	{
+	.callback = video_detect_force_vendor,
 	.ident = "Sony VPCEH3U1E",
 	.matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),


