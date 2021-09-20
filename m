Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAA3411A7D
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244198AbhITQuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:50:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240786AbhITQtd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:49:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84DC461264;
        Mon, 20 Sep 2021 16:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156487;
        bh=2xMlWFHiXOi120R/jSPT9RMjHQNRuLCblCgFLo8tWIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gVB5u0YzSXSwnLqBXSShk+qCP2qsqhF2dlphEKKvIuRQdAg8oZM68X41B2tL+SVUV
         Y4CZ+N2GRLIukJxFeP6cLpJWjwuCduTWarK8akZvJJoVufdKal7bBKNOve9GZT6uOR
         ahVtwi6eOjx01HUyP9avuu3blvVAKLu2SdqhEU8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?R=C3=B6tti?= 
        <espressobinboardarmbiantempmailaddress@posteo.de>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 4.4 081/133] PCI: Restrict ASMedia ASM1062 SATA Max Payload Size Supported
Date:   Mon, 20 Sep 2021 18:42:39 +0200
Message-Id: <20210920163915.292942521@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

commit b12d93e9958e028856cbcb061b6e64728ca07755 upstream.

The ASMedia ASM1062 SATA controller advertises Max_Payload_Size_Supported
of 512, but in fact it cannot handle incoming TLPs with payload size of
512.

We discovered this issue on PCIe controllers capable of MPS = 512 (Aardvark
and DesignWare), where the issue presents itself as an External Abort.
Bjorn Helgaas says:

  Probably ASM1062 reports a Malformed TLP error when it receives a data
  payload of 512 bytes, and Aardvark, DesignWare, etc convert this to an
  arm64 External Abort. [1]

To avoid this problem, limit the ASM1062 Max Payload Size Supported to 256
bytes, so we set the Max Payload Size of devices that may send TLPs to the
ASM1062 to 256 or less.

[1] https://lore.kernel.org/linux-pci/20210601170907.GA1949035@bjorn-Precision-5520/
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=212695
Link: https://lore.kernel.org/r/20210624171418.27194-2-kabel@kernel.org
Reported-by: Rötti <espressobinboardarmbiantempmailaddress@posteo.de>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Krzysztof Wilczyński <kw@linux.com>
Reviewed-by: Pali Rohár <pali@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2921,6 +2921,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SO
 			PCI_DEVICE_ID_SOLARFLARE_SFC4000A_1, fixup_mpss_256);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLARFLARE,
 			PCI_DEVICE_ID_SOLARFLARE_SFC4000B, fixup_mpss_256);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ASMEDIA, 0x0612, fixup_mpss_256);
 
 /* Intel 5000 and 5100 Memory controllers have an errata with read completion
  * coalescing (which is enabled by default on some BIOSes) and MPS of 256B.


