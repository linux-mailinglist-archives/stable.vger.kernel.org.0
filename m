Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE72362390
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732480AbfGHPcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:32:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390180AbfGHPcl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:32:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECCB6216F4;
        Mon,  8 Jul 2019 15:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599960;
        bh=sRzUo8N2c4jO93+r4ZILDbdApJGAD7zCtHKnqBowNh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m56xAybMYGowi3C3GgsIcC3FjDGXr4vziJJvsFkaCGKsjAXcEYezeeqhQzO+PspVb
         F78FcdAKJSSaxTU6Kr3gXbRxP9G7fPekUbzrzC1v9QNyN+z93O+miH/VDPMBudc8bh
         OCEcTngsIj71aO5OwUBtA3U0ohXSu4UEQZQXEPsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 08/96] HID: i2c-hid: add iBall Aer3 to descriptor override
Date:   Mon,  8 Jul 2019 17:12:40 +0200
Message-Id: <20190708150526.772295121@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit eb6964fa6509b4f1152313f1e0bb67f0c54a6046 ]

This device uses the SIPODEV SP1064 touchpad, which does not
supply descriptors, so it has to be added to the override
list.

BugLink: https://bugs.launchpad.net/bugs/1825718
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
index fd1b6eea6d2f..75078c83be1a 100644
--- a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
+++ b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
@@ -354,6 +354,14 @@ static const struct dmi_system_id i2c_hid_dmi_desc_override_table[] = {
 		},
 		.driver_data = (void *)&sipodev_desc
 	},
+	{
+		.ident = "iBall Aer3",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "iBall"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Aer3"),
+		},
+		.driver_data = (void *)&sipodev_desc
+	},
 	{ }	/* Terminate list */
 };
 
-- 
2.20.1



