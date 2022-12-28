Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB13657E92
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234176AbiL1PzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234162AbiL1PzF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:55:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9AE18B1C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:55:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 876CA6156C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C01C433D2;
        Wed, 28 Dec 2022 15:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242903;
        bh=FoxYHp9WbO8yNbj/wlK5JvWJiKXSe9+l6W+iEX6c9Cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqIxoPIEo+0pew/uunlrTjjyoKBT6nO4ir5x8lMRlbuVv1GOB7RiSwHGe465E8FCk
         Vn7Tbmoh9LFxs5NhNhV/rvd0K2zkm2WKLdwb8BZuQEFHbx2t+I/QJdd5Cjtkv4SQ7W
         4C/NKVwp1rkNx9n5jxpTLJX1+2lQHVMD7qh+ANfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liu Shixin <liushixin2@huawei.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0429/1146] ALSA: asihpi: fix missing pci_disable_device()
Date:   Wed, 28 Dec 2022 15:32:48 +0100
Message-Id: <20221228144341.835358891@linuxfoundation.org>
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
index bb31b7fe867d..477a5b4b50bc 100644
--- a/sound/pci/asihpi/hpioctl.c
+++ b/sound/pci/asihpi/hpioctl.c
@@ -361,7 +361,7 @@ int asihpi_adapter_probe(struct pci_dev *pci_dev,
 		pci_dev->device, pci_dev->subsystem_vendor,
 		pci_dev->subsystem_device, pci_dev->devfn);
 
-	if (pci_enable_device(pci_dev) < 0) {
+	if (pcim_enable_device(pci_dev) < 0) {
 		dev_err(&pci_dev->dev,
 			"pci_enable_device failed, disabling device\n");
 		return -EIO;
-- 
2.35.1



