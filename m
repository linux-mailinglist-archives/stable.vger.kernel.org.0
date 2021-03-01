Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3BB32848C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbhCAQhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:37:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:36258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231164AbhCAQ3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:29:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A24D64EFD;
        Mon,  1 Mar 2021 16:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615837;
        bh=CrohloePVzJ2iFCVBHa/2ijzqhLEtztBrpGtLXjOnzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vzMH26tZvkd1YONQF+Kwo7zyKQ3UIV3Dtp4kRTN4xTDE/BMXEK0tFHyYQUPcUTeES
         vilSjYqslsycBVYD/oNiT9CgPmSfJJuc3PAYxKeqhDsAGDfQ3qcDNC7942SzznnpY2
         8T+xco9xf9Bm+et3bdvmvTK3KufJx2zqeuywyM20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 078/134] PCI: Align checking of syscall user config accessors
Date:   Mon,  1 Mar 2021 17:12:59 +0100
Message-Id: <20210301161017.408686744@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit ef9e4005cbaf022c6251263aa27836acccaef65d ]

After 34e3207205ef ("PCI: handle positive error codes"),
pci_user_read_config_*() and pci_user_write_config_*() return 0 or negative
errno values, not PCIBIOS_* values like PCIBIOS_SUCCESSFUL or
PCIBIOS_BAD_REGISTER_NUMBER.

Remove comparisons with PCIBIOS_SUCCESSFUL and check only for non-zero.  It
happens that PCIBIOS_SUCCESSFUL is zero, so this is not a functional
change, but it aligns this code with the user accessors.

[bhelgaas: commit log]
Fixes: 34e3207205ef ("PCI: handle positive error codes")
Link: https://lore.kernel.org/r/f1220314-e518-1e18-bf94-8e6f8c703758@gmail.com
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/syscall.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/syscall.c b/drivers/pci/syscall.c
index b91c4da683657..7958250856d36 100644
--- a/drivers/pci/syscall.c
+++ b/drivers/pci/syscall.c
@@ -21,7 +21,7 @@ SYSCALL_DEFINE5(pciconfig_read, unsigned long, bus, unsigned long, dfn,
 	u16 word;
 	u32 dword;
 	long err;
-	long cfg_ret;
+	int cfg_ret;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -47,7 +47,7 @@ SYSCALL_DEFINE5(pciconfig_read, unsigned long, bus, unsigned long, dfn,
 	}
 
 	err = -EIO;
-	if (cfg_ret != PCIBIOS_SUCCESSFUL)
+	if (cfg_ret)
 		goto error;
 
 	switch (len) {
@@ -105,7 +105,7 @@ SYSCALL_DEFINE5(pciconfig_write, unsigned long, bus, unsigned long, dfn,
 		if (err)
 			break;
 		err = pci_user_write_config_byte(dev, off, byte);
-		if (err != PCIBIOS_SUCCESSFUL)
+		if (err)
 			err = -EIO;
 		break;
 
@@ -114,7 +114,7 @@ SYSCALL_DEFINE5(pciconfig_write, unsigned long, bus, unsigned long, dfn,
 		if (err)
 			break;
 		err = pci_user_write_config_word(dev, off, word);
-		if (err != PCIBIOS_SUCCESSFUL)
+		if (err)
 			err = -EIO;
 		break;
 
@@ -123,7 +123,7 @@ SYSCALL_DEFINE5(pciconfig_write, unsigned long, bus, unsigned long, dfn,
 		if (err)
 			break;
 		err = pci_user_write_config_dword(dev, off, dword);
-		if (err != PCIBIOS_SUCCESSFUL)
+		if (err)
 			err = -EIO;
 		break;
 
-- 
2.27.0



