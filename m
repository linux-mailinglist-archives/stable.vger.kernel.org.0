Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF06359A5E
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbhDIJ6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:58:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233533AbhDIJ5R (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:57:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 184F4611C2;
        Fri,  9 Apr 2021 09:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962224;
        bh=qycwxaWt4Ghm0SGjjl6Eb0J2087GMQuYj0+JzQ+GhRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QLSppnT1HXqiZC8faGgc9eyXLw6kMMzKNUl5ZnjYqI97p9nQhOLb+L2PXuu3X2D7I
         U0yyenwCrO7VelmmWz+y0B0XpyxiYFiJWn9XX1KxwKV5KX+289MloV9MeDYBJRNSDa
         GCpmFdlnOCdwjQZE8rDrx0FqAxa83oPm6aHNQRCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alban Bedel <albeu@free.fr>,
        Alexander Kobel <a-kobel@a-kobel.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/18] platform/x86: intel-hid: Support Lenovo ThinkPad X1 Tablet Gen 2
Date:   Fri,  9 Apr 2021 11:53:31 +0200
Message-Id: <20210409095301.641317014@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095301.525783608@linuxfoundation.org>
References: <20210409095301.525783608@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alban Bedel <albeu@free.fr>

[ Upstream commit 56678a5f44ef5f0ad9a67194bbee2280c6286534 ]

Like a few other system the Lenovo ThinkPad X1 Tablet Gen 2 miss the
HEBC method, which prevent the power button from working. Add a quirk
to enable the button array on this system family and fix the power
button.

Signed-off-by: Alban Bedel <albeu@free.fr>
Tested-by: Alexander Kobel <a-kobel@a-kobel.de>
Link: https://lore.kernel.org/r/20210222141559.3775-1-albeu@free.fr
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel-hid.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/intel-hid.c b/drivers/platform/x86/intel-hid.c
index d7d69eadb9bb..fa3cda69cec9 100644
--- a/drivers/platform/x86/intel-hid.c
+++ b/drivers/platform/x86/intel-hid.c
@@ -94,6 +94,13 @@ static const struct dmi_system_id button_array_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Spectre x2 Detachable"),
 		},
 	},
+	{
+		.ident = "Lenovo ThinkPad X1 Tablet Gen 2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_FAMILY, "ThinkPad X1 Tablet Gen 2"),
+		},
+	},
 	{ }
 };
 
-- 
2.30.2



