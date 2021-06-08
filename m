Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE983A02DE
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbhFHTLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:11:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234044AbhFHTHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:07:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBC706192F;
        Tue,  8 Jun 2021 18:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178027;
        bh=hA/ovwlzE7eQUKYBHZemaWhQaZlLZ3gwpGTr3TQDzAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=txnCeJ0iujalAg8rvsHiAMD4SQx04xQ/5dGjWNpaly0CBJMWnkANa7MEq7PSMq+MQ
         VTlYL+yHpxYJAQRSovFxgScOorwK0+cUZCMHhBGKjdKsubwZJjNjQToXNXw3wF5i1H
         luUR7ZCtqbgEcotL8BXoXfB5Z+sPu9DMNUi7rPow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        =?UTF-8?q?Filipe=20La=C3=ADns?= <lains@riseup.net>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 016/161] HID: logitech-hidpp: initialize level variable
Date:   Tue,  8 Jun 2021 20:25:46 +0200
Message-Id: <20210608175946.008174907@linuxfoundation.org>
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

From: Tom Rix <trix@redhat.com>

[ Upstream commit 81c8bf9170477d453b24a6bc3300d201d641e645 ]

Static analysis reports this representative problem

hid-logitech-hidpp.c:1356:23: warning: Assigned value is
  garbage or undefined
        hidpp->battery.level = level;
                             ^ ~~~~~

In some cases, 'level' is never set in hidpp20_battery_map_status_voltage()
Since level is not available on all hw, initialize level to unknown.

Fixes: be281368f297 ("hid-logitech-hidpp: read battery voltage from newer devices")
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Filipe Laíns <lains@riseup.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index d459e2dbe647..f7710fb2f48d 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -1262,6 +1262,7 @@ static int hidpp20_battery_map_status_voltage(u8 data[3], int *voltage,
 	int status;
 
 	long flags = (long) data[2];
+	*level = POWER_SUPPLY_CAPACITY_LEVEL_UNKNOWN;
 
 	if (flags & 0x80)
 		switch (flags & 0x07) {
-- 
2.30.2



