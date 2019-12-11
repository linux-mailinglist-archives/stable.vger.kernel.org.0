Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B91FF11B2B1
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733031AbfLKPhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:37:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:44402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388056AbfLKPf3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:35:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DACF822B48;
        Wed, 11 Dec 2019 15:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078528;
        bh=OQdp4TgrbgfbRGbXenCdDqQbGJBrsX3oXG85qHT1b7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VqizXPNufQX6IdcWVu4tAy289Rix05NMDy/Dl6F88/perUdk4HrDNc+dh8I4ERe8n
         oeF/6LOGt2qGWcbD84QONpGjXXs/WykCw+AvUygBdibOPi4sNsMK5o/m6LY5ROQmL6
         B/cNWThxFsKr8F+8RbgE4TpG6+WVYQaEPEXgrogg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 17/42] clk: qcom: Allow constant ratio freq tables for rcg
Date:   Wed, 11 Dec 2019 10:34:45 -0500
Message-Id: <20191211153510.23861-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211153510.23861-1-sashal@kernel.org>
References: <20191211153510.23861-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>

[ Upstream commit efd164b5520afd6fb2883b68e0d408a7de29c491 ]

Some RCGs (the gfx_3d_src_clk in msm8998 for example) are basically just
some constant ratio from the input across the entire frequency range.  It
would be great if we could specify the frequency table as a single entry
constant ratio instead of a long list, ie:

	{ .src = P_GPUPLL0_OUT_EVEN, .pre_div = 3 },
        { }

So, lets support that.

We need to fix a corner case in qcom_find_freq() where if the freq table
is non-null, but has no frequencies, we end up returning an "entry" before
the table array, which is bad.  Then, we need ignore the freq from the
table, and instead base everything on the requested freq.

Suggested-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Link: https://lkml.kernel.org/r/20191031185715.15504-1-jeffrey.l.hugo@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rcg2.c | 2 ++
 drivers/clk/qcom/common.c   | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index a071bba8018c4..0ae1b0a66eb55 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -196,6 +196,8 @@ static int _freq_tbl_determine_rate(struct clk_hw *hw,
 	p = clk_hw_get_parent_by_index(hw, index);
 	if (clk_flags & CLK_SET_RATE_PARENT) {
 		if (f->pre_div) {
+			if (!rate)
+				rate = req->rate;
 			rate /= 2;
 			rate *= f->pre_div + 1;
 		}
diff --git a/drivers/clk/qcom/common.c b/drivers/clk/qcom/common.c
index fffcbaf0fba74..f89a9f0aa606e 100644
--- a/drivers/clk/qcom/common.c
+++ b/drivers/clk/qcom/common.c
@@ -37,6 +37,9 @@ struct freq_tbl *qcom_find_freq(const struct freq_tbl *f, unsigned long rate)
 	if (!f)
 		return NULL;
 
+	if (!f->freq)
+		return f;
+
 	for (; f->freq; f++)
 		if (rate <= f->freq)
 			return f;
-- 
2.20.1

