Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B27F412146
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357256AbhITSDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:03:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350878AbhITSBn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:01:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6B90619EC;
        Mon, 20 Sep 2021 17:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158167;
        bh=tMRUhg+5IP7iS3QDrQIfnJwdTixPGUXbFkAY1SQ5LYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UvBmvQ8yMpOkYevnZGycvJQfeu1re7Mcwv1fRbdPlbWUgwtZ0MhBOwmpNI+w2Kh9c
         RJ830CyjtoxPaFogwexRShlql5BqytJ/B86mEswABJZCSBIjhe56iZUacdb5LuujUr
         C1NTy1kPFvA0vZsCZol5rGe+XrLeUbWMmNuY72qY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.4 031/260] PCI: Return ~0 data on pciconfig_read() CAP_SYS_ADMIN failure
Date:   Mon, 20 Sep 2021 18:40:49 +0200
Message-Id: <20210920163932.178528111@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Wilczyński <kw@linux.com>

commit a8bd29bd49c4156ea0ec5a97812333e2aeef44e7 upstream.

The pciconfig_read() syscall reads PCI configuration space using
hardware-dependent config accessors.

If the read fails on PCI, most accessors don't return an error; they
pretend the read was successful and got ~0 data from the device, so the
syscall returns success with ~0 data in the buffer.

When the accessor does return an error, pciconfig_read() normally fills the
user's buffer with ~0 and returns an error in errno.  But after
e4585da22ad0 ("pci syscall.c: Switch to refcounting API"), we don't fill
the buffer with ~0 for the EPERM "user lacks CAP_SYS_ADMIN" error.

Userspace may rely on the ~0 data to detect errors, but after e4585da22ad0,
that would not detect CAP_SYS_ADMIN errors.

Restore the original behaviour of filling the buffer with ~0 when the
CAP_SYS_ADMIN check fails.

[bhelgaas: commit log, fold in Nathan's fix
https://lore.kernel.org/r/20210803200836.500658-1-nathan@kernel.org]
Fixes: e4585da22ad0 ("pci syscall.c: Switch to refcounting API")
Link: https://lore.kernel.org/r/20210729233755.1509616-1-kw@linux.com
Signed-off-by: Krzysztof Wilczyński <kw@linux.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/syscall.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pci/syscall.c
+++ b/drivers/pci/syscall.c
@@ -22,8 +22,10 @@ SYSCALL_DEFINE5(pciconfig_read, unsigned
 	long err;
 	int cfg_ret;
 
+	err = -EPERM;
+	dev = NULL;
 	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
+		goto error;
 
 	err = -ENODEV;
 	dev = pci_get_domain_bus_and_slot(0, bus, dfn);


