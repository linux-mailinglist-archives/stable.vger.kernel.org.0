Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11CE5126CFF
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbfLSSmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:42:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:33814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728695AbfLSSmd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:42:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFB0024672;
        Thu, 19 Dec 2019 18:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780953;
        bh=SQ+63E8dRGVFKoxnKVDyx3YwGbAdRpIHTG3O4filuZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyvfdWcSrs9jmHX9/aB7OatsyAwCZ9beiJjWMRmkZcV6gr+NUes6zyEfM9asQOFtR
         yGjmuc2/fIyFXwa2+ZU3r6o5vm0d0YFGdHOElGe8VgvHVQc3PdWi+OJeUiJJJCNZq1
         FQIRP2a7DCOIrfgVkX9GADSK4OFnuZHLLxjSu60Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 022/199] extcon: max8997: Fix lack of path setting in USB device mode
Date:   Thu, 19 Dec 2019 19:31:44 +0100
Message-Id: <20191219183216.039083350@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit a2dc50914744eea9f83a70a5db0486be625e5dc0 ]

MAX8997 driver disables automatic path selection from MicroUSB connector
and manually sets path to either UART or USB lines. However the code for
setting USB path worked only for USB host mode (when ID pin is set
to ground). When standard USB cable (USB device mode) is connected, path
registers are not touched. This means that once the non-USB accessory is
connected to MAX8997-operated micro USB port, the path is no longer set
to USB and USB device mode doesn't work. This patch fixes it by setting
USB path both for USB and USB host modes.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-max8997.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 4a0612fb9c070..b9b48d45a6dc4 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -321,12 +321,10 @@ static int max8997_muic_handle_usb(struct max8997_muic_info *info,
 {
 	int ret = 0;
 
-	if (usb_type == MAX8997_USB_HOST) {
-		ret = max8997_muic_set_path(info, info->path_usb, attached);
-		if (ret < 0) {
-			dev_err(info->dev, "failed to update muic register\n");
-			return ret;
-		}
+	ret = max8997_muic_set_path(info, info->path_usb, attached);
+	if (ret < 0) {
+		dev_err(info->dev, "failed to update muic register\n");
+		return ret;
 	}
 
 	switch (usb_type) {
-- 
2.20.1



