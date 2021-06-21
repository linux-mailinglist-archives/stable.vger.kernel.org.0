Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91A33AEEE9
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhFUQdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:33:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232342AbhFUQbN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:31:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8539E613FA;
        Mon, 21 Jun 2021 16:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292730;
        bh=QbSCfuq9kOyKYJnxD56Mv3iLkzPvRWSKIGDJfEiNGI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSE4zBjDphwQuZKVl3HrJLtAigFS17Fe7pJyTZELIiazZfFDYrMVP3MpbUoasWWfA
         cVI4EJUjsR3AuhFHvSr4P05hkFb/Sc0v4O6/SGV8TWSr/0f8uR8s3A1Y2Sf6o1iufv
         73sU+IqBxQMlSCTaRfFn15kf92MArYLLNlrQoC+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shanker Donthineni <sdonthineni@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sinan Kaya <okaya@kernel.org>
Subject: [PATCH 5.10 108/146] PCI: Mark some NVIDIA GPUs to avoid bus reset
Date:   Mon, 21 Jun 2021 18:15:38 +0200
Message-Id: <20210621154918.167526518@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shanker Donthineni <sdonthineni@nvidia.com>

commit 4c207e7121fa92b66bf1896bf8ccb9edfb0f9731 upstream.

Some NVIDIA GPU devices do not work with SBR.  Triggering SBR leaves the
device inoperable for the current system boot. It requires a system
hard-reboot to get the GPU device back to normal operating condition
post-SBR. For the affected devices, enable NO_BUS_RESET quirk to avoid the
issue.

This issue will be fixed in the next generation of hardware.

Link: https://lore.kernel.org/r/20210608054857.18963-8-ameynarkhede03@gmail.com
Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Sinan Kaya <okaya@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3558,6 +3558,18 @@ static void quirk_no_bus_reset(struct pc
 }
 
 /*
+ * Some NVIDIA GPU devices do not work with bus reset, SBR needs to be
+ * prevented for those affected devices.
+ */
+static void quirk_nvidia_no_bus_reset(struct pci_dev *dev)
+{
+	if ((dev->device & 0xffc0) == 0x2340)
+		quirk_no_bus_reset(dev);
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
+			 quirk_nvidia_no_bus_reset);
+
+/*
  * Some Atheros AR9xxx and QCA988x chips do not behave after a bus reset.
  * The device will throw a Link Down error on AER-capable systems and
  * regardless of AER, config space of the device is never accessible again


