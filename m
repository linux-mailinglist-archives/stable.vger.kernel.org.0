Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9F040DAE9
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 15:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239976AbhIPNTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 09:19:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239938AbhIPNTU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 09:19:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B26BB6120C;
        Thu, 16 Sep 2021 13:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631798280;
        bh=a6MhXl5zhS34pRFEuXvcPF9MxQ2ksB0jFmzclEHjvYk=;
        h=From:To:Cc:Subject:Date:From;
        b=ftRnJWYChLfI/jkFRsCqcZ9FWxFw8mYdSudFKn4lJLGH98MbyWvd7HKUCt1UdlMlb
         OL/d83COlrdqoU0h0b89bqjZWJlUtGPvRbpjZDlUW0Iy2v+2O16wyaGMqRQdGaqCQ1
         sZJ588fjmUxiR12a4aFkhs5NCqxLVswIDXNDCMjrJJIjmNukxEC030Txu931TWB4pd
         zgy+Oq2vcRhyZnvI4xbQG9yO73wIyslXODtQU6DqZHAjLOJbysjMdxPyDjzW3GUnMC
         b8A4S5S+r+w5Jtdwe3HLduTqLubT/4crSItWxd4plFOU2RqIXJ/veEZ1Vi6M9rBZzE
         YRo/CVj2ypVxA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     x86@kernel.org
Cc:     jose.souza@intel.com, hpa@zytor.com, bp@alien8.de,
        mingo@redhat.com, tglx@linutronix.de, kai.heng.feng@canonical.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org, rudolph@fb.com,
        xapienz@fb.com, bmilton@fb.com, Jakub Kicinski <kuba@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] x86/intel: Disable HPET on another Intel Coffee Lake platform
Date:   Thu, 16 Sep 2021 06:17:39 -0700
Message-Id: <20210916131739.1260552-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

My Lenovo T490s with i7-8665U had been marking TSC as unstable
since v5.13, resulting in very sluggish desktop experience...

I have a 8086:3e34 bridge, also known as "Host bridge: Intel
Corporation Coffee Lake HOST and DRAM Controller (rev 0c)".
Add it to the list.

We should perhaps consider applying this quirk more widely.
The Intel documentation does not list my device [1], but
linuxhw [2] does, and it seems to list a few more bridges
we do not currently cover (3e31, 3ecc, 3e35, 3e0f).

[1] https://www.intel.com/content/dam/www/public/us/en/documents/datasheets/8th-gen-core-family-datasheet-vol-2.pdf
[2] https://github.com/linuxhw/DevicePopulation/blob/master/README.md

Cc: stable@vger.kernel.org # v5.13+
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
---
 arch/x86/kernel/early-quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 38837dad46e6..7d2de04f8750 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -716,6 +716,8 @@ static struct chipset early_qrk[] __initdata = {
 		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
 	{ PCI_VENDOR_ID_INTEL, 0x3e20,
 		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
+	{ PCI_VENDOR_ID_INTEL, 0x3e34,
+		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
 	{ PCI_VENDOR_ID_INTEL, 0x3ec4,
 		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
 	{ PCI_VENDOR_ID_INTEL, 0x8a12,
-- 
2.31.1

