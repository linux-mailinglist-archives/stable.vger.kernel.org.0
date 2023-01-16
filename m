Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D6466CC98
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbjAPR1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234764AbjAPR1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:27:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E505A372
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:04:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEE97B8108E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D7EC433EF;
        Mon, 16 Jan 2023 17:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888663;
        bh=RQTmtVkq5b0kOBtIq/gl6b/hsWurBm4xlmt+CU9sQ+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YbgkUHVhlgUZoX5Qy8wnPlxNhK4u+aaftJtNjmAq9Sd3Ios4YaQvpIs8y2otBTKrI
         WrYNkc4gTXsdiqPxvjZ/mMo7deqaDf7T8klvJzOesS4eAe4MH+Ro414A4M+DaBT4V5
         tCpaHJSvf2P6tfDKuUYRYsrmrX+EkmrGiDuMst0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liu Shixin <liushixin2@huawei.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 092/338] ALSA: asihpi: fix missing pci_disable_device()
Date:   Mon, 16 Jan 2023 16:49:25 +0100
Message-Id: <20230116154824.891921928@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

From: Liu Shixin <liushixin2@huawei.com>

[ Upstream commit 9d86515c3d4c0564a0c31a2df87d735353a1971e ]

pci_disable_device() need be called while module exiting, switch to use
pcim_enable(), pci_disable_device() will be called in pcim_release().

Fixes: 3285ea10e9b0 ("ALSA: asihpi - Interrelated HPI tidy up.")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Link: https://lore.kernel.org/r/20221126021429.3029562-1-liushixin2@huawei.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/asihpi/hpioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/asihpi/hpioctl.c b/sound/pci/asihpi/hpioctl.c
index b4ccd9f92400..81f240472943 100644
--- a/sound/pci/asihpi/hpioctl.c
+++ b/sound/pci/asihpi/hpioctl.c
@@ -359,7 +359,7 @@ int asihpi_adapter_probe(struct pci_dev *pci_dev,
 		pci_dev->device, pci_dev->subsystem_vendor,
 		pci_dev->subsystem_device, pci_dev->devfn);
 
-	if (pci_enable_device(pci_dev) < 0) {
+	if (pcim_enable_device(pci_dev) < 0) {
 		dev_err(&pci_dev->dev,
 			"pci_enable_device failed, disabling device\n");
 		return -EIO;
-- 
2.35.1



