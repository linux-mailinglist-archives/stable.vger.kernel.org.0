Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002A945C025
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346658AbhKXNFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:05:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347975AbhKXNDn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:03:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B408361A3D;
        Wed, 24 Nov 2021 12:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757386;
        bh=j+kbMIocsMcKNQlyECzyKvTuFSHnRs2fsppZmzEPd74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OAhu48yf+mBDrsXY+gldSqmE+ibiqVFqSWEjw335hdTWhH/NvWKBkcFt9qQBZGaKR
         SH/gecfdMzg+Us9BVPO76tZOqJbPlaplmVwag1XgBTYwFHctmoo/MU4GIoKOSz8Tde
         RfMqXHEK42creU6m8/W8NdClWsmQB+pHcjn71gfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zev Weiss <zev@bewilderbeest.net>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 149/323] hwmon: (pmbus/lm25066) Let compiler determine outer dimension of lm25066_coeff
Date:   Wed, 24 Nov 2021 12:55:39 +0100
Message-Id: <20211124115723.958592571@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zev Weiss <zev@bewilderbeest.net>

[ Upstream commit b7931a7b0e0df4d2a25fedd895ad32c746b77bc1 ]

Maintaining this manually is error prone (there are currently only
five chips supported, not six); gcc can do it for us automatically.

Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Fixes: 666c14906b49 ("hwmon: (pmbus/lm25066) Drop support for LM25063")
Link: https://lore.kernel.org/r/20210928092242.30036-5-zev@bewilderbeest.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/lm25066.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/lm25066.c b/drivers/hwmon/pmbus/lm25066.c
index 6eafcbb75dcd9..e25b801490862 100644
--- a/drivers/hwmon/pmbus/lm25066.c
+++ b/drivers/hwmon/pmbus/lm25066.c
@@ -60,7 +60,7 @@ struct __coeff {
 #define PSC_CURRENT_IN_L	(PSC_NUM_CLASSES)
 #define PSC_POWER_L		(PSC_NUM_CLASSES + 1)
 
-static struct __coeff lm25066_coeff[6][PSC_NUM_CLASSES + 2] = {
+static struct __coeff lm25066_coeff[][PSC_NUM_CLASSES + 2] = {
 	[lm25056] = {
 		[PSC_VOLTAGE_IN] = {
 			.m = 16296,
-- 
2.33.0



