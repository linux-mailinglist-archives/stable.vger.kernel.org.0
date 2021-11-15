Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800E34521A6
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346391AbhKPBF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:05:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:44602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245459AbhKOTUf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DFEC63544;
        Mon, 15 Nov 2021 18:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001304;
        bh=FfBWpqs4o7ngQ7aNTC+MZUA6fIQcfDaMo2IsJOAoaxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UH6Uc9k9s+JQLQ5csByFsB6DypYTBjU9phwsddHfPMiPpJHY0U5uvnpzJ/yGCAXba
         xTuK1DawMHcmSDj94Y1oSxFWwiqAxeraBEAz08S/SOo9oYZ9RmT6pdsh8JKsGTD0KW
         n5yGwDYQCaieHDSsUHfyVDflHSip2T/MNmCSS0BM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.15 140/917] PCI: pci-bridge-emul: Fix emulation of W1C bits
Date:   Mon, 15 Nov 2021 17:53:55 +0100
Message-Id: <20211115165433.513737599@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

commit 7a41ae80bdcb17e14dd7d83239b8a0cf368f18be upstream.

The pci_bridge_emul_conf_write() function correctly clears W1C bits in
cfgspace cache, but it does not inform the underlying implementation
about the clear request: the .write_op() method is given the value with
these bits cleared.

This is wrong if the .write_op() needs to know which bits were requested
to be cleared.

Fix the value to be passed into the .write_op() method to have requested
W1C bits set, so that it can clear them.

Both pci-bridge-emul users (mvebu and aardvark) are compatible with this
change.

Link: https://lore.kernel.org/r/20211028185659.20329-2-kabel@kernel.org
Fixes: 23a5fba4d941 ("PCI: Introduce PCI bridge emulated config space common logic")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-bridge-emul.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/pci/pci-bridge-emul.c
+++ b/drivers/pci/pci-bridge-emul.c
@@ -431,8 +431,21 @@ int pci_bridge_emul_conf_write(struct pc
 	/* Clear the W1C bits */
 	new &= ~((value << shift) & (behavior[reg / 4].w1c & mask));
 
+	/* Save the new value with the cleared W1C bits into the cfgspace */
 	cfgspace[reg / 4] = cpu_to_le32(new);
 
+	/*
+	 * Clear the W1C bits not specified by the write mask, so that the
+	 * write_op() does not clear them.
+	 */
+	new &= ~(behavior[reg / 4].w1c & ~mask);
+
+	/*
+	 * Set the W1C bits specified by the write mask, so that write_op()
+	 * knows about that they are to be cleared.
+	 */
+	new |= (value << shift) & (behavior[reg / 4].w1c & mask);
+
 	if (write_op)
 		write_op(bridge, reg, old, new, mask);
 


