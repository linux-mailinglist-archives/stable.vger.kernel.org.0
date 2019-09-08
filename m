Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD236ACD18
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730161AbfIHMpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:32790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730156AbfIHMpi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:45:38 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24D91216C8;
        Sun,  8 Sep 2019 12:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946737;
        bh=/1+YFRA8MRn5iJdk3k+ittjd4Ien8qJzrzDQDKkmjQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZaWAG1vaEHqgTalMfBkcKdhSmicmLpQmHRefyLbpZLVKliLWtL41if9UiR4zuacIe
         VFpDiV0WCCwwKv0w0+oX4EiJk7EUjiEvflGAFJku0sZe0NiyOa3DqMR5usZBkFQ3tG
         xjB7NRHk2P7bV45tSQ1TbQuheP8qxItmaP9OanJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 04/40] Bluetooth: btqca: Add a short delay before downloading the NVM
Date:   Sun,  8 Sep 2019 13:41:37 +0100
Message-Id: <20190908121115.297090022@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121114.260662089@linuxfoundation.org>
References: <20190908121114.260662089@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8059ba0bd0e4694e51c2ee6438a77b325f06c0d5 ]

On WCN3990 downloading the NVM sometimes fails with a "TLV response
size mismatch" error:

[  174.949955] Bluetooth: btqca.c:qca_download_firmware() hci0: QCA Downloading qca/crnv21.bin
[  174.958718] Bluetooth: btqca.c:qca_tlv_send_segment() hci0: QCA TLV response size mismatch

It seems the controller needs a short time after downloading the
firmware before it is ready for the NVM. A delay as short as 1 ms
seems sufficient, make it 10 ms just in case. No event is received
during the delay, hence we don't just silently drop an extra event.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index 0bbdfcef2aa84..a48a61f22f823 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -363,6 +363,9 @@ int qca_uart_setup_rome(struct hci_dev *hdev, uint8_t baudrate)
 		return err;
 	}
 
+	/* Give the controller some time to get ready to receive the NVM */
+	msleep(10);
+
 	/* Download NVM configuration */
 	config.type = TLV_TYPE_NVM;
 	snprintf(config.fwname, sizeof(config.fwname), "qca/nvm_%08x.bin",
-- 
2.20.1



