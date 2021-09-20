Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7CB411DAD
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349281AbhITRWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:22:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346955AbhITRUf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:20:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A51F61A65;
        Mon, 20 Sep 2021 17:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157237;
        bh=GXHmBsdc6S65PqFtoCkcvHIqyFyqePfjlNVLQAIJQk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T/auiVBMfcKk683cSSVyAEgH7eToD8aKc7r7cDLoh36hQ8fu4+g9EWLB7qQ3IqFhk
         MBuEct7BfhTHHfa3LPdPAsNrLM028eow9PHMH2wVOkxzwS3RUJ8bVdu3D98YaPiPdo
         wIyAv91oVCNQWj+A559PYAlloYJKQ8xDWqd8hpqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 4.14 117/217] PCI: Return ~0 data on pciconfig_read() CAP_SYS_ADMIN failure
Date:   Mon, 20 Sep 2021 18:42:18 +0200
Message-Id: <20210920163928.628708420@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
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
@@ -24,8 +24,10 @@ SYSCALL_DEFINE5(pciconfig_read, unsigned
 	long err;
 	int cfg_ret;
 
+	err = -EPERM;
+	dev = NULL;
 	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
+		goto error;
 
 	err = -ENODEV;
 	dev = pci_get_bus_and_slot(bus, dfn);


