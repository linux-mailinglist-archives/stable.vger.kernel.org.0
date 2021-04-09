Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA068359B1A
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbhDIKHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234188AbhDIKFH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:05:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4F376120B;
        Fri,  9 Apr 2021 10:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962488;
        bh=OIzT/O8MLBrnJkhda5eiEdrMEMmC+bI4k2Ki2lmj7dI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YEvu0z+YzVRBIohtLCXKcSS8h+ZuFjw24lVg1HiuflECZ0poF7nTblPsFn6iZqTU7
         innqO6GxbAMjzQyfLXSDi1fRuZloPsgPqpWUz6OnBnlsoMGTLo0C/C86DzuNJhSOsI
         0K0SbHlB9fCbxX032Lv/R07uyzm8RrO62nD76zp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alban Bedel <albeu@free.fr>,
        Alexander Kobel <a-kobel@a-kobel.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 04/45] platform/x86: intel-hid: Support Lenovo ThinkPad X1 Tablet Gen 2
Date:   Fri,  9 Apr 2021 11:53:30 +0200
Message-Id: <20210409095305.538247034@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
References: <20210409095305.397149021@linuxfoundation.org>
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
index 2f5b8d09143e..57cc92891a57 100644
--- a/drivers/platform/x86/intel-hid.c
+++ b/drivers/platform/x86/intel-hid.c
@@ -90,6 +90,13 @@ static const struct dmi_system_id button_array_table[] = {
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



