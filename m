Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A983CDD9E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245735AbhGSO7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:59:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245317AbhGSO6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:58:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65B9B613E3;
        Mon, 19 Jul 2021 15:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708950;
        bh=YS150Zw3EMrfbg7HTU/kACgheRdPjXylbhg3QzhH4fA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hz9Ml3WAziLtrLzPwgnP4OHzbM1vYUtNu9ibEwQTqNZoPQ58P1J44MhL3AwQsANQ+
         n9SU5J1gug3LWtJZUW3RGS5MJw+CbUn6/Ct/E5cY7mfwIcw+FLluyGTHkMmlYxl3QV
         Rth7g7/xGFC4yiQed0PcmEqbKQ2GD/Kz9vtyMiVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 195/421] visorbus: fix error return code in visorchipset_init()
Date:   Mon, 19 Jul 2021 16:50:06 +0200
Message-Id: <20210719144953.156227594@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit ce52ec5beecc1079c251f60e3973b3758f60eb59 ]

Commit 1366a3db3dcf ("staging: unisys: visorbus: visorchipset_init clean
up gotos") assigns the initial value -ENODEV to the local variable 'err',
and the first several error branches will return this value after "goto
error". But commit f1f537c2e7f5 ("staging: unisys: visorbus: Consolidate
controlvm channel creation.") overwrites 'err' in the middle of the way.
As a result, some error branches do not successfully return the initial
value -ENODEV of 'err', but return 0.

In addition, when kzalloc() fails, -ENOMEM should be returned instead of
-ENODEV.

Fixes: f1f537c2e7f5 ("staging: unisys: visorbus: Consolidate controlvm channel creation.")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20210528082614.9337-1-thunder.leizhen@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/visorbus/visorchipset.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/visorbus/visorchipset.c b/drivers/visorbus/visorchipset.c
index cb1eb7e05f87..5668cad86e37 100644
--- a/drivers/visorbus/visorchipset.c
+++ b/drivers/visorbus/visorchipset.c
@@ -1561,7 +1561,7 @@ schedule_out:
 
 static int visorchipset_init(struct acpi_device *acpi_device)
 {
-	int err = -ENODEV;
+	int err = -ENOMEM;
 	struct visorchannel *controlvm_channel;
 
 	chipset_dev = kzalloc(sizeof(*chipset_dev), GFP_KERNEL);
@@ -1584,8 +1584,10 @@ static int visorchipset_init(struct acpi_device *acpi_device)
 				 "controlvm",
 				 sizeof(struct visor_controlvm_channel),
 				 VISOR_CONTROLVM_CHANNEL_VERSIONID,
-				 VISOR_CHANNEL_SIGNATURE))
+				 VISOR_CHANNEL_SIGNATURE)) {
+		err = -ENODEV;
 		goto error_delete_groups;
+	}
 	/* if booting in a crash kernel */
 	if (is_kdump_kernel())
 		INIT_DELAYED_WORK(&chipset_dev->periodic_controlvm_work,
-- 
2.30.2



