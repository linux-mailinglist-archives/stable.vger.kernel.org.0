Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDE14513B1
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348624AbhKOTym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:54:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343869AbhKOTWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B71866329C;
        Mon, 15 Nov 2021 18:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002065;
        bh=N2FZnSZFoO0MwQO7esxwLdsf5a+KCVLvrc7YZmABSbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z44dzAGq27080XdXynZkzUwfI2GRVjk0DZMoxm8IEh/9owSQ/mJ0leQVl47+nakUP
         1ZchZhIe+6xntCl+ysHEo+iJUCHrOO+pBv2chxWPmUdUlnv3pOz83Ow5A+PDyGyjFS
         MiRk3oBXiDT5MzFAvKxsOLPu5exheOQiXhmSuqbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zev Weiss <zev@bewilderbeest.net>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 426/917] hwmon: (pmbus/lm25066) Let compiler determine outer dimension of lm25066_coeff
Date:   Mon, 15 Nov 2021 17:58:41 +0100
Message-Id: <20211115165443.240318526@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index 1a660c4cd19f4..66d3e88b54172 100644
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



