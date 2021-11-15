Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4A9450DE5
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239658AbhKOSJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:09:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239734AbhKOSEl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:04:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84D4761104;
        Mon, 15 Nov 2021 17:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997936;
        bh=j4VlMumYBfLyu3GiQYUT4673UhCSNKf0W6rlO0YCsvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHTg+/tXOA7zKbFzsG9OEme3QV8md4kTigEWYG9alVjaioewWe398XZIA+i/rzpZT
         ErHZYoryJo6HQm9q927eVYAEjobp8cxnScTcvOoy0cRqU0ZyzBFz8i94qTOYs505cW
         uej1NZn7y1k9ZHtnp75XNl45taE23YDBGjCjjzs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zev Weiss <zev@bewilderbeest.net>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 321/575] hwmon: (pmbus/lm25066) Let compiler determine outer dimension of lm25066_coeff
Date:   Mon, 15 Nov 2021 18:00:46 +0100
Message-Id: <20211115165354.906089987@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index d14f923b3740d..17199a1104c72 100644
--- a/drivers/hwmon/pmbus/lm25066.c
+++ b/drivers/hwmon/pmbus/lm25066.c
@@ -51,7 +51,7 @@ struct __coeff {
 #define PSC_CURRENT_IN_L	(PSC_NUM_CLASSES)
 #define PSC_POWER_L		(PSC_NUM_CLASSES + 1)
 
-static struct __coeff lm25066_coeff[6][PSC_NUM_CLASSES + 2] = {
+static struct __coeff lm25066_coeff[][PSC_NUM_CLASSES + 2] = {
 	[lm25056] = {
 		[PSC_VOLTAGE_IN] = {
 			.m = 16296,
-- 
2.33.0



