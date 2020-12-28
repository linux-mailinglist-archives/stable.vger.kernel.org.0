Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAD12E3DF9
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392064AbgL1OUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:20:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:55760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437791AbgL1OU3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:20:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2352207B2;
        Mon, 28 Dec 2020 14:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165183;
        bh=wftp2cSyFblKaOqhH7s9VkrcaGRhdM/JI5UaMkd+yTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A61hhtJatjUozv+sa7t77m4l9QV5TVy7drTRdmzQUS31oBrNmBGGavynF5dhA/CEQ
         zW9xOyaDDkd4R4Vj2I2gupfqYo4gAuy/ot/yVJxHB5Z5EeHk4cLUk9llu5qYg5aozC
         bxMeYIZETrqTT/rwqtwbD1Dl2g8jAFssZQnUOwfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 440/717] nfc: s3fwrn5: Release the nfc firmware
Date:   Mon, 28 Dec 2020 13:47:18 +0100
Message-Id: <20201228125042.049326129@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index ec930ee2c847e..64df50827642b 100644
--- a/drivers/nfc/s3fwrn5/firmware.c
+++ b/drivers/nfc/s3fwrn5/firmware.c
@@ -293,8 +293,10 @@ static int s3fwrn5_fw_request_firmware(struct s3fwrn5_fw_info *fw_info)
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



