Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3DA115ECED
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389481AbgBNRag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:30:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:58720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390665AbgBNQHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:07:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DAE52067D;
        Fri, 14 Feb 2020 16:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696444;
        bh=kMUw6Js6eknNyxk3vBQwSZ6XBHAU+POFf0euwGKYmW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pGxiGkDfbjFuibu3JCz+k6Z6DjpmLXjXlO54HPMWsxBzMI3F8tN2SdQCPixT5endY
         fRzSM12doQTF87uTjF2pYlvRvFTxLdKvy1ClzKrHFJ17BNDRS0eE9icnQ3xruZX9NT
         R5Nfk7yCjGQX3eQzie9MiCRyQ3Mk0Gq6hmwkNSvw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Anderson <dianders@chromium.org>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 259/459] soc: qcom: rpmhpd: Set 'active_only' for active only power domains
Date:   Fri, 14 Feb 2020 10:58:29 -0500
Message-Id: <20200214160149.11681-259-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 5d0d4d42bed0090d3139e7c5ca1587d76d48add6 ]

The 'active_only' attribute was accidentally never set to true for any
power domains meaning that all the code handling this attribute was
dead.

NOTE that the RPM power domain code (as opposed to the RPMh one) gets
this right.

Acked-by: Rajendra Nayak <rnayak@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Fixes: 279b7e8a62cc ("soc: qcom: rpmhpd: Add RPMh power domain driver")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20190214173633.211000-1-dianders@chromium.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/rpmhpd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soc/qcom/rpmhpd.c b/drivers/soc/qcom/rpmhpd.c
index 5741ec3fa814c..51850cc68b701 100644
--- a/drivers/soc/qcom/rpmhpd.c
+++ b/drivers/soc/qcom/rpmhpd.c
@@ -93,6 +93,7 @@ static struct rpmhpd sdm845_mx = {
 
 static struct rpmhpd sdm845_mx_ao = {
 	.pd = { .name = "mx_ao", },
+	.active_only = true,
 	.peer = &sdm845_mx,
 	.res_name = "mx.lvl",
 };
@@ -107,6 +108,7 @@ static struct rpmhpd sdm845_cx = {
 
 static struct rpmhpd sdm845_cx_ao = {
 	.pd = { .name = "cx_ao", },
+	.active_only = true,
 	.peer = &sdm845_cx,
 	.parent = &sdm845_mx_ao.pd,
 	.res_name = "cx.lvl",
-- 
2.20.1

