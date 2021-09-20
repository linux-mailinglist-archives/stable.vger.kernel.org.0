Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A11B41213D
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357173AbhITSDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:03:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356703AbhITSBG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:01:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 838CE63229;
        Mon, 20 Sep 2021 17:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158163;
        bh=llqVRZepbp//01/uit09MPR+SKYoDSxTzpVAjo+o9ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=obVHflFmBd+/CbpUZ0OhUAao5Hg1vzL9a+ULx+FtnAm2TCy0EByrWYlisaLAYB0w+
         8igR7wwWSbg4punjRQRFOwf/8EsEi1pxjqAHSRePNIeF4ROXGLcurB3gGrKR0I4BhW
         v8p/UALpS+p2q4Xe4Al/RcGhaWp8+EAd1BAg5zEQ=
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
Subject: [PATCH 5.4 030/260] PCI: Restrict ASMedia ASM1062 SATA Max Payload Size Supported
Date:   Mon, 20 Sep 2021 18:40:48 +0200
Message-Id: <20210920163932.145817688@linuxfoundation.org>
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
@@ -3252,6 +3252,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SO
 			PCI_DEVICE_ID_SOLARFLARE_SFC4000A_1, fixup_mpss_256);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLARFLARE,
 			PCI_DEVICE_ID_SOLARFLARE_SFC4000B, fixup_mpss_256);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ASMEDIA, 0x0612, fixup_mpss_256);
 
 /*
  * Intel 5000 and 5100 Memory controllers have an erratum with read completion


