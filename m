Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9840A3A02E0
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236223AbhFHTLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:11:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237264AbhFHTH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:07:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B18B6145A;
        Tue,  8 Jun 2021 18:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178030;
        bh=Y+x07ts2834sKo/W/TEPkYGXiOK6fWJ6EvOPwwmPx4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ExqjIKp/n83+glHerHCI9q5k44ODnS842PDBtGkkQruhQikeQ448LLTH3HGrhvgbU
         yssr5bgrjNlrxICMlfSteEFzXUFsgx29g2LtU67Kzbg3FfSWsZXOCNHahjBI2Q8xcA
         MWV8Tv/yqO8ocS481swyU/EaowMC/IlHZfExfTe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 017/161] HID: pidff: fix error return code in hid_pidff_init()
Date:   Tue,  8 Jun 2021 20:25:47 +0200
Message-Id: <20210608175946.040861867@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 3dd653c077efda8152f4dd395359617d577a54cd ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 224ee88fe395 ("Input: add force feedback driver for PID devices")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index fddac7c72f64..07a9fe97d2e0 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -1292,6 +1292,7 @@ int hid_pidff_init(struct hid_device *hid)
 
 	if (pidff->pool[PID_DEVICE_MANAGED_POOL].value &&
 	    pidff->pool[PID_DEVICE_MANAGED_POOL].value[0] == 0) {
+		error = -EPERM;
 		hid_notice(hid,
 			   "device does not support device managed pool\n");
 		goto fail;
-- 
2.30.2



