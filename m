Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0BCE450B00
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236848AbhKORQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:16:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236938AbhKORPQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:15:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DCE461C14;
        Mon, 15 Nov 2021 17:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996309;
        bh=KjnLQHTkAYs14/AajWgBYzfjAJOa8K0J5aYqscpfdzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJgD92mdcmFUXWBrGZhyg9mLn4KjBYM82nxvgPNFTLFfFvVXkr+Y1nFg5VqGpP/hP
         yW9vThUY6BcfEUPFrcBLLzajFp42r7AWddU64yTX8kLQWsWqfede5TmAguW4bZEngm
         k3Y2FmMbvM7kG7myPXSBLjIdvD9bte/gN7x/LcXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zev Weiss <zev@bewilderbeest.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.4 065/355] hwmon: (pmbus/lm25066) Add offset coefficients
Date:   Mon, 15 Nov 2021 17:59:49 +0100
Message-Id: <20211115165315.912373540@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zev Weiss <zev@bewilderbeest.net>

commit ae59dc455a78fb73034dd1fbb337d7e59c27cbd8 upstream.

With the exception of the lm5066i, all the devices handled by this
driver had been missing their offset ('b') coefficients for direct
format readings.

Cc: stable@vger.kernel.org
Fixes: 58615a94f6a1 ("hwmon: (pmbus/lm25066) Add support for LM25056")
Fixes: e53e6497fc9f ("hwmon: (pmbus/lm25066) Refactor device specific coefficients")
Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Link: https://lore.kernel.org/r/20210928092242.30036-2-zev@bewilderbeest.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/lm25066.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/drivers/hwmon/pmbus/lm25066.c
+++ b/drivers/hwmon/pmbus/lm25066.c
@@ -55,22 +55,27 @@ static struct __coeff lm25066_coeff[6][P
 	[lm25056] = {
 		[PSC_VOLTAGE_IN] = {
 			.m = 16296,
+			.b = 1343,
 			.R = -2,
 		},
 		[PSC_CURRENT_IN] = {
 			.m = 13797,
+			.b = -1833,
 			.R = -2,
 		},
 		[PSC_CURRENT_IN_L] = {
 			.m = 6726,
+			.b = -537,
 			.R = -2,
 		},
 		[PSC_POWER] = {
 			.m = 5501,
+			.b = -2908,
 			.R = -3,
 		},
 		[PSC_POWER_L] = {
 			.m = 26882,
+			.b = -5646,
 			.R = -4,
 		},
 		[PSC_TEMPERATURE] = {
@@ -82,26 +87,32 @@ static struct __coeff lm25066_coeff[6][P
 	[lm25066] = {
 		[PSC_VOLTAGE_IN] = {
 			.m = 22070,
+			.b = -1800,
 			.R = -2,
 		},
 		[PSC_VOLTAGE_OUT] = {
 			.m = 22070,
+			.b = -1800,
 			.R = -2,
 		},
 		[PSC_CURRENT_IN] = {
 			.m = 13661,
+			.b = -5200,
 			.R = -2,
 		},
 		[PSC_CURRENT_IN_L] = {
 			.m = 6852,
+			.b = -3100,
 			.R = -2,
 		},
 		[PSC_POWER] = {
 			.m = 736,
+			.b = -3300,
 			.R = -2,
 		},
 		[PSC_POWER_L] = {
 			.m = 369,
+			.b = -1900,
 			.R = -2,
 		},
 		[PSC_TEMPERATURE] = {
@@ -111,26 +122,32 @@ static struct __coeff lm25066_coeff[6][P
 	[lm5064] = {
 		[PSC_VOLTAGE_IN] = {
 			.m = 4611,
+			.b = -642,
 			.R = -2,
 		},
 		[PSC_VOLTAGE_OUT] = {
 			.m = 4621,
+			.b = 423,
 			.R = -2,
 		},
 		[PSC_CURRENT_IN] = {
 			.m = 10742,
+			.b = 1552,
 			.R = -2,
 		},
 		[PSC_CURRENT_IN_L] = {
 			.m = 5456,
+			.b = 2118,
 			.R = -2,
 		},
 		[PSC_POWER] = {
 			.m = 1204,
+			.b = 8524,
 			.R = -3,
 		},
 		[PSC_POWER_L] = {
 			.m = 612,
+			.b = 11202,
 			.R = -3,
 		},
 		[PSC_TEMPERATURE] = {
@@ -140,26 +157,32 @@ static struct __coeff lm25066_coeff[6][P
 	[lm5066] = {
 		[PSC_VOLTAGE_IN] = {
 			.m = 4587,
+			.b = -1200,
 			.R = -2,
 		},
 		[PSC_VOLTAGE_OUT] = {
 			.m = 4587,
+			.b = -2400,
 			.R = -2,
 		},
 		[PSC_CURRENT_IN] = {
 			.m = 10753,
+			.b = -1200,
 			.R = -2,
 		},
 		[PSC_CURRENT_IN_L] = {
 			.m = 5405,
+			.b = -600,
 			.R = -2,
 		},
 		[PSC_POWER] = {
 			.m = 1204,
+			.b = -6000,
 			.R = -3,
 		},
 		[PSC_POWER_L] = {
 			.m = 605,
+			.b = -8000,
 			.R = -3,
 		},
 		[PSC_TEMPERATURE] = {


