Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD33328720
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbhCARU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:20:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:48318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237787AbhCARNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:13:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37ADC64EED;
        Mon,  1 Mar 2021 16:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617051;
        bh=vnQTW2da1VQFV0Wigy6nCMPc9Qiz/41SoNJxkm0kHq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SHsrPsMf1cZAS+Ggoi1lI6Dt93Y+9Zs4Y6XjJBdZJSopZuPgZhakSSIMpkoBqxmlI
         cot7WYOgKqHMI0qoRmJxXD4f/awtH5/ktn9M/18VVVWsjfYFl5+X7cxH9qEfwlLstM
         8nwpHMiF2qjg4J7CR7PYhjGBpSkMXV+EZzc9FvYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 158/247] PCI: Align checking of syscall user config accessors
Date:   Mon,  1 Mar 2021 17:12:58 +0100
Message-Id: <20210301161039.406301849@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index d96626c614f56..a7bdd10fccf33 100644
--- a/drivers/pci/syscall.c
+++ b/drivers/pci/syscall.c
@@ -19,7 +19,7 @@ SYSCALL_DEFINE5(pciconfig_read, unsigned long, bus, unsigned long, dfn,
 	u16 word;
 	u32 dword;
 	long err;
-	long cfg_ret;
+	int cfg_ret;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -45,7 +45,7 @@ SYSCALL_DEFINE5(pciconfig_read, unsigned long, bus, unsigned long, dfn,
 	}
 
 	err = -EIO;
-	if (cfg_ret != PCIBIOS_SUCCESSFUL)
+	if (cfg_ret)
 		goto error;
 
 	switch (len) {
@@ -103,7 +103,7 @@ SYSCALL_DEFINE5(pciconfig_write, unsigned long, bus, unsigned long, dfn,
 		if (err)
 			break;
 		err = pci_user_write_config_byte(dev, off, byte);
-		if (err != PCIBIOS_SUCCESSFUL)
+		if (err)
 			err = -EIO;
 		break;
 
@@ -112,7 +112,7 @@ SYSCALL_DEFINE5(pciconfig_write, unsigned long, bus, unsigned long, dfn,
 		if (err)
 			break;
 		err = pci_user_write_config_word(dev, off, word);
-		if (err != PCIBIOS_SUCCESSFUL)
+		if (err)
 			err = -EIO;
 		break;
 
@@ -121,7 +121,7 @@ SYSCALL_DEFINE5(pciconfig_write, unsigned long, bus, unsigned long, dfn,
 		if (err)
 			break;
 		err = pci_user_write_config_dword(dev, off, dword);
-		if (err != PCIBIOS_SUCCESSFUL)
+		if (err)
 			err = -EIO;
 		break;
 
-- 
2.27.0



