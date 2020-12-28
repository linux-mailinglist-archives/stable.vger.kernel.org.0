Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC422E67F4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730479AbgL1NEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:04:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:60762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730474AbgL1NEg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:04:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AAB521D94;
        Mon, 28 Dec 2020 13:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160636;
        bh=aHniJjZWYDqJ8uI0brVmuB9pz9xGHCTqUR9DUqDyVkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p6cqLgMDIwaAKsc2+FjvcsZouv1Vub5JMC7TwzSxEGqePlrOzofj0rvKLEDGe3ggW
         m9XXvDMyxKPQS5myvcnEmDqGDQ9yBwHJ7wI7fRqeKil8eNIpsEykXGrdN/Nv9NdFJS
         /7AY0S6FYz7S0H0AXP0rR/m3hD1NDQzQ1jbjS51U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 117/175] nfc: s3fwrn5: Release the nfc firmware
Date:   Mon, 28 Dec 2020 13:49:30 +0100
Message-Id: <20201228124858.924140659@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

[ Upstream commit a4485baefa1efa596702ebffd5a9c760d42b14b5 ]

add the code to release the nfc firmware when the firmware image size is
wrong.

Fixes: c04c674fadeb ("nfc: s3fwrn5: Add driver for Samsung S3FWRN5 NFC Chip")
Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201213095850.28169-1-bongsu.jeon@samsung.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/s3fwrn5/firmware.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/s3fwrn5/firmware.c b/drivers/nfc/s3fwrn5/firmware.c
index 5f97da1947e39..e6ca1f9a7f63e 100644
--- a/drivers/nfc/s3fwrn5/firmware.c
+++ b/drivers/nfc/s3fwrn5/firmware.c
@@ -304,8 +304,10 @@ static int s3fwrn5_fw_request_firmware(struct s3fwrn5_fw_info *fw_info)
 	if (ret < 0)
 		return ret;
 
-	if (fw->fw->size < S3FWRN5_FW_IMAGE_HEADER_SIZE)
+	if (fw->fw->size < S3FWRN5_FW_IMAGE_HEADER_SIZE) {
+		release_firmware(fw->fw);
 		return -EINVAL;
+	}
 
 	memcpy(fw->date, fw->fw->data + 0x00, 12);
 	fw->date[12] = '\0';
-- 
2.27.0



