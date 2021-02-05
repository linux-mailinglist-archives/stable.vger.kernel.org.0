Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB92311115
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbhBERmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:42:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:54084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233444AbhBEP5W (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:57:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8081665027;
        Fri,  5 Feb 2021 14:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534282;
        bh=2br25Ef6eA7dJw7oic9Ws2obV6HGNWmieqwjTzbnod4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u2l4jtzoj9MJPK5cv95lICJh2rlje2ZcJaUuFxTDEjRff3+UF6M2ElHXrIil/rTlH
         +oqEJpUKI2UDm8pOY00Pc6DgPAspqoq5dnoMrbPu4YKgTKBqJc9AoEfkxkpgMId+ST
         o6XAHL1/YFkGIv5H+UlB35V9TINwSaOmugCJ7rhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 53/57] habanalabs: disable FW events on device removal
Date:   Fri,  5 Feb 2021 15:07:19 +0100
Message-Id: <20210205140658.260965687@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oded Gabbay <ogabbay@kernel.org>

[ Upstream commit 2dc4a6d79168e7e426e8ddf8e7219c9ffd13b2b1 ]

When device is removed, we need to make sure the F/W won't send us
any more events because during the remove process we disable the
interrupts.

Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/device.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/misc/habanalabs/common/device.c b/drivers/misc/habanalabs/common/device.c
index 09c328ee65da8..71b3a4d5adc65 100644
--- a/drivers/misc/habanalabs/common/device.c
+++ b/drivers/misc/habanalabs/common/device.c
@@ -1425,6 +1425,15 @@ void hl_device_fini(struct hl_device *hdev)
 		}
 	}
 
+	/* Disable PCI access from device F/W so it won't send us additional
+	 * interrupts. We disable MSI/MSI-X at the halt_engines function and we
+	 * can't have the F/W sending us interrupts after that. We need to
+	 * disable the access here because if the device is marked disable, the
+	 * message won't be send. Also, in case of heartbeat, the device CPU is
+	 * marked as disable so this message won't be sent
+	 */
+	hl_fw_send_pci_access_msg(hdev,	CPUCP_PACKET_DISABLE_PCI_ACCESS);
+
 	/* Mark device as disabled */
 	hdev->disabled = true;
 
-- 
2.27.0



