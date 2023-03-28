Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5F06CC40C
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbjC1O7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233717AbjC1O7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:59:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7CA9E392
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:59:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A015FB81D77
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A77C433D2;
        Tue, 28 Mar 2023 14:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015555;
        bh=i2GGW3Zzb33Agi4Dth8sraYtXMV8E2zOCVJOmTcxFCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LmG73NFOABcp9HCjnE2M5tidmH/VATm2DBT49K8o5ritllQAUWV5OsPBBvC2HcFDi
         ZJvV2y1cAw2iowWXh/rjlIXzo/Tv1LQ1NOZI4qXavKCHU6rCrzcnFVPz4BIWimw1Nr
         9qzD2J83/JV3dHqPbwV+pSGE7TDVsEYaYhAnANiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Stephan Gerhold <stephan.gerhold@kernkonzept.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/224] Bluetooth: btqcomsmd: Fix command timeout after setting BD address
Date:   Tue, 28 Mar 2023 16:41:28 +0200
Message-Id: <20230328142621.090083957@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan.gerhold@kernkonzept.com>

[ Upstream commit 5d44ab9e204200a78ad55cdf185aa2bb109b5950 ]

On most devices using the btqcomsmd driver (e.g. the DragonBoard 410c
and other devices based on the Qualcomm MSM8916/MSM8909/... SoCs)
the Bluetooth firmware seems to become unresponsive for a while after
setting the BD address. On recent kernel versions (at least 5.17+)
this often causes timeouts for subsequent commands, e.g. the HCI reset
sent by the Bluetooth core during initialization:

    Bluetooth: hci0: Opcode 0x c03 failed: -110

Unfortunately this behavior does not seem to be documented anywhere.
Experimentation suggests that the minimum necessary delay to avoid
the problem is ~150us. However, to be sure add a sleep for > 1ms
in case it is a bit longer on other firmware versions.

Older kernel versions are likely also affected, although perhaps with
slightly different errors or less probability. Side effects can easily
hide the issue in most cases, e.g. unrelated incoming interrupts that
cause the necessary delay.

Fixes: 1511cc750c3d ("Bluetooth: Introduce Qualcomm WCNSS SMD based HCI driver")
Signed-off-by: Stephan Gerhold <stephan.gerhold@kernkonzept.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqcomsmd.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btqcomsmd.c b/drivers/bluetooth/btqcomsmd.c
index 2acb719e596f5..11c7e04bf3947 100644
--- a/drivers/bluetooth/btqcomsmd.c
+++ b/drivers/bluetooth/btqcomsmd.c
@@ -122,6 +122,21 @@ static int btqcomsmd_setup(struct hci_dev *hdev)
 	return 0;
 }
 
+static int btqcomsmd_set_bdaddr(struct hci_dev *hdev, const bdaddr_t *bdaddr)
+{
+	int ret;
+
+	ret = qca_set_bdaddr_rome(hdev, bdaddr);
+	if (ret)
+		return ret;
+
+	/* The firmware stops responding for a while after setting the bdaddr,
+	 * causing timeouts for subsequent commands. Sleep a bit to avoid this.
+	 */
+	usleep_range(1000, 10000);
+	return 0;
+}
+
 static int btqcomsmd_probe(struct platform_device *pdev)
 {
 	struct btqcomsmd *btq;
@@ -162,7 +177,7 @@ static int btqcomsmd_probe(struct platform_device *pdev)
 	hdev->close = btqcomsmd_close;
 	hdev->send = btqcomsmd_send;
 	hdev->setup = btqcomsmd_setup;
-	hdev->set_bdaddr = qca_set_bdaddr_rome;
+	hdev->set_bdaddr = btqcomsmd_set_bdaddr;
 
 	ret = hci_register_dev(hdev);
 	if (ret < 0)
-- 
2.39.2



