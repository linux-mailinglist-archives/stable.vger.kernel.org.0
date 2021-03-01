Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83284328E21
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241318AbhCATYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:24:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:45284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241303AbhCATTX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:19:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46EDF651CA;
        Mon,  1 Mar 2021 17:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619025;
        bh=eVpNBYO+zCrDSxxvHZxGxthYvU6+BsoZE78DED3ha/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0NKrJW7JJKsDigq4TRiutUke1dcvsXekGxBtO7uye8pwNMRezOQ2xuwKVn60JlwOp
         hZqyzX83a4xPBcugzwSTw8RPaMWoDZiQIHZqzk8WLBtM/H56F+EGtDrOrvCXQ/uD+o
         WwzvxeVmldJHeTu5fTC3Jc1WjTG49Esoqhed8htE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Benn <evanbenn@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 305/663] platform/chrome: cros_ec_proto: Add LID and BATTERY to default mask
Date:   Mon,  1 Mar 2021 17:09:13 +0100
Message-Id: <20210301161156.933768396@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Benn <evanbenn@chromium.org>

[ Upstream commit 852405d8efcbca0e02f14592fb1d1dcd0d3fb508 ]

After 'platform/chrome: cros_ec_proto: Use EC_HOST_EVENT_MASK not BIT'
some of the flags are not quite correct.
LID_CLOSED is used to suspend the device, so it makes sense to ignore that.
BATTERY events are also frequent and causing spurious wakes on elm/hana
mt8173 devices.

Fixes: c214e564acb2 ("platform/chrome: cros_ec_proto: ignore unnecessary wakeups on old ECs")
Signed-off-by: Evan Benn <evanbenn@chromium.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Link: https://lore.kernel.org/r/20201209220306.2.I3291bf83e4884c206b097ede34780e014fa3e265@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_proto.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
index 4e442175612d4..ea5149efcbeae 100644
--- a/drivers/platform/chrome/cros_ec_proto.c
+++ b/drivers/platform/chrome/cros_ec_proto.c
@@ -526,9 +526,11 @@ int cros_ec_query_all(struct cros_ec_device *ec_dev)
 		 * power), not wake up.
 		 */
 		ec_dev->host_event_wake_mask = U32_MAX &
-			~(EC_HOST_EVENT_MASK(EC_HOST_EVENT_AC_DISCONNECTED) |
+			~(EC_HOST_EVENT_MASK(EC_HOST_EVENT_LID_CLOSED) |
+			  EC_HOST_EVENT_MASK(EC_HOST_EVENT_AC_DISCONNECTED) |
 			  EC_HOST_EVENT_MASK(EC_HOST_EVENT_BATTERY_LOW) |
 			  EC_HOST_EVENT_MASK(EC_HOST_EVENT_BATTERY_CRITICAL) |
+			  EC_HOST_EVENT_MASK(EC_HOST_EVENT_BATTERY) |
 			  EC_HOST_EVENT_MASK(EC_HOST_EVENT_PD_MCU) |
 			  EC_HOST_EVENT_MASK(EC_HOST_EVENT_BATTERY_STATUS));
 		/*
-- 
2.27.0



