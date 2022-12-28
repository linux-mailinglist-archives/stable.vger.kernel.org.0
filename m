Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D77657FFA
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234431AbiL1QNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234591AbiL1QMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:12:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569421A808
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:10:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0914AB81730
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5F5C433D2;
        Wed, 28 Dec 2022 16:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243806;
        bh=5sT3RXSxcNBDAmIwHRhH8sS3K/brB4GbWQim4yWKBMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2TMnDg/5VqugnQX22eR31sUrNOtqrq2sEVZit5TMqDK5Tf0fypoHoX6dcKdtnfSf8
         zNSH7tVoPOVt5AthLyRr5EG4xV+uoXf12/CMqogGAh9P9pDQ3ndMbWMsSn8GWlQtH+
         jUPn0YGFWgaF2ggB3SYVUUufyj+fukLxSViIldgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0559/1146] Bluetooth: btintel: Fix missing free skb in btintel_setup_combined()
Date:   Wed, 28 Dec 2022 15:34:58 +0100
Message-Id: <20221228144345.352750306@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

[ Upstream commit cee50ce899de415baf4da3ed38b7d4f13c3170d1 ]

skb allocated by __hci_cmd_sync would not be used whether in checking
for supported iBT hardware variants or after, we should free it in all
error branches, this patch makes the case read version failed or default
error case free skb before return.

Fixes: c86c7285bb08 ("Bluetooth: btintel: Fix the legacy bootloader returns tlv based version")
Fixes: 019a1caa7fd2 ("Bluetooth: btintel: Refactoring setup routine for bootloader devices")
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Reviewed-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index a657e9a3e96a..f6b4b7a1be4c 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2524,7 +2524,7 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 		 */
 		err = btintel_read_version(hdev, &ver);
 		if (err)
-			return err;
+			break;
 
 		/* Apply the device specific HCI quirks
 		 *
@@ -2566,7 +2566,8 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 	default:
 		bt_dev_err(hdev, "Unsupported Intel hw variant (%u)",
 			   INTEL_HW_VARIANT(ver_tlv.cnvi_bt));
-		return -EINVAL;
+		err = -EINVAL;
+		break;
 	}
 
 exit_error:
-- 
2.35.1



