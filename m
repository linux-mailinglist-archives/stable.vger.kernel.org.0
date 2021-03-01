Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB0D32907D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242954AbhCAUIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:08:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237560AbhCAT5P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:57:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD79B64F1D;
        Mon,  1 Mar 2021 17:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621368;
        bh=9A0Qi0fIX1OcHKmNE6z42l2HBGzZ7ukifowMXFVLfRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cPfyh9/XgFGnvh6g5Tw6YbgyThUsYguRJqod3pyWipNXrDdeYE3vS+YEvlivRx3Al
         3X0WhZK9GmAGsVdJ+k6HTHTcdoQmbQDIEOlP2WSLAmltN+rtw/iwjkwaDYWFUZ4x9x
         G2WHBrHJOJ/9GkkEsOVGPx88e0HAFUDIMbf7GzOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 490/775] PCI: Align checking of syscall user config accessors
Date:   Mon,  1 Mar 2021 17:10:58 +0100
Message-Id: <20210301161225.733384983@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index 31e39558d49d8..8b003c890b87b 100644
--- a/drivers/pci/syscall.c
+++ b/drivers/pci/syscall.c
@@ -20,7 +20,7 @@ SYSCALL_DEFINE5(pciconfig_read, unsigned long, bus, unsigned long, dfn,
 	u16 word;
 	u32 dword;
 	long err;
-	long cfg_ret;
+	int cfg_ret;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -46,7 +46,7 @@ SYSCALL_DEFINE5(pciconfig_read, unsigned long, bus, unsigned long, dfn,
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



