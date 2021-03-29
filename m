Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A763534DB35
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbhC2W0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:26:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232695AbhC2WYA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:24:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EEDF61994;
        Mon, 29 Mar 2021 22:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056610;
        bh=vkE6ky8uZ48JdJ16FrsIoKGvS87thA+aDM3cl8N55Rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nbY8xBH9jLYGkPCZPq2iNT/hunpzilrfSd46PwMDEgt1srSVoQQ7dHsMRr1Id//Rd
         J/PBkioSk/72JlHo8gbKsYWO1PLBD5jeAE+TFA1BQcaoasVhzF9sflVpmfeKG8NdI5
         YjE3y0blzENKyTutxGAZsICGj58pnhjIe20cBNg8XUK1vR+X90l0JLn8JuHOWx0zqk
         ZDflTYWxaNFYHnZYNyQfxRWPcC+k4XGhqA/PXz4KaMfsdZhfQTl8jTaR228SUUeYow
         xKMmBWDEVk/2CSeXcAC3JtHi1sv/pi6cML2JiPtiBIL/7kRCVybtHonsY2Su8+15Ty
         xNpaJj2N7xvsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alban Bedel <albeu@free.fr>, Alexander Kobel <a-kobel@a-kobel.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/15] platform/x86: intel-hid: Support Lenovo ThinkPad X1 Tablet Gen 2
Date:   Mon, 29 Mar 2021 18:23:14 -0400
Message-Id: <20210329222327.2383533-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222327.2383533-1-sashal@kernel.org>
References: <20210329222327.2383533-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
2.30.1

