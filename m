Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4BD328A2B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239491AbhCASNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:13:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:57190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239167AbhCASGi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:06:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BDE464F97;
        Mon,  1 Mar 2021 17:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621007;
        bh=6D0Z8dqC8Mexw3WoCc4cXSrcmIsTDdM4K8raB50DivI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ZTlrDCeXC4uwWpxfRLt6KYOx2Zp/i2Iv4zaYG10aOwhGeLXnKJM0BzeIy3/BftyU
         hn2tyvkPhY8k3p+veH6lium1Vc2hxZIqITFsduCEjxEf0GD9KqGgQCb9GLysc+Vl6x
         2U5ZbHPfjYHaMd2gu1wDXIHXBlfBVUCxu1B+86QA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Benn <evanbenn@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 359/775] platform/chrome: cros_ec_proto: Use EC_HOST_EVENT_MASK not BIT
Date:   Mon,  1 Mar 2021 17:08:47 +0100
Message-Id: <20210301161219.362411877@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Benn <evanbenn@chromium.org>

[ Upstream commit 0944ea07baa748741563c8842122010fa9017d16 ]

The host_event_code enum is 1-based, use EC_HOST_EVENT_MASK not BIT to
generate the intended mask. This patch changes the behaviour of the
mask, a following patch will restore the intended behaviour:
'Add LID and BATTERY to default mask'

Fixes: c214e564acb2 ("platform/chrome: cros_ec_proto: ignore unnecessary wakeups on old ECs")
Signed-off-by: Evan Benn <evanbenn@chromium.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Link: https://lore.kernel.org/r/20201209220306.1.I6133572c0ab3c6b95426f804bac2d3833e24acb1@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_proto.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
index 7c92a6e22d75d..3ad60190e11c6 100644
--- a/drivers/platform/chrome/cros_ec_proto.c
+++ b/drivers/platform/chrome/cros_ec_proto.c
@@ -526,11 +526,11 @@ int cros_ec_query_all(struct cros_ec_device *ec_dev)
 		 * power), not wake up.
 		 */
 		ec_dev->host_event_wake_mask = U32_MAX &
-			~(BIT(EC_HOST_EVENT_AC_DISCONNECTED) |
-			  BIT(EC_HOST_EVENT_BATTERY_LOW) |
-			  BIT(EC_HOST_EVENT_BATTERY_CRITICAL) |
-			  BIT(EC_HOST_EVENT_PD_MCU) |
-			  BIT(EC_HOST_EVENT_BATTERY_STATUS));
+			~(EC_HOST_EVENT_MASK(EC_HOST_EVENT_AC_DISCONNECTED) |
+			  EC_HOST_EVENT_MASK(EC_HOST_EVENT_BATTERY_LOW) |
+			  EC_HOST_EVENT_MASK(EC_HOST_EVENT_BATTERY_CRITICAL) |
+			  EC_HOST_EVENT_MASK(EC_HOST_EVENT_PD_MCU) |
+			  EC_HOST_EVENT_MASK(EC_HOST_EVENT_BATTERY_STATUS));
 		/*
 		 * Old ECs may not support this command. Complain about all
 		 * other errors.
-- 
2.27.0



