Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 825F812ED03
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbgABWYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:24:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:47380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729337AbgABWYC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:24:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00C6F20863;
        Thu,  2 Jan 2020 22:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003841;
        bh=G6NnBJZ1UzJd5r3ZsXJcxufTsEqjjWfqF1RkzhQvnaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFecNE9sFAo6xbTwiubFemVNq8IMCdQAZjAp52jzue7dYQb06yWXzHKMqdbiMqD4D
         HonrmBuK4qBdb4ufOOUWZX00Z6q0Bv3dAGxa4QzZloBS4aWzCoWKQxOtvXuPKKBSna
         zaZpflXAiZsdskDq3dApbKR2udJewyuDfRAkmvBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 21/91] clk: qcom: Allow constant ratio freq tables for rcg
Date:   Thu,  2 Jan 2020 23:07:03 +0100
Message-Id: <20200102220421.771119187@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
References: <20200102220356.856162165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1a0985ae20d2..a93439242565 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -212,6 +212,8 @@ static int _freq_tbl_determine_rate(struct clk_hw *hw, const struct freq_tbl *f,
 	p = clk_hw_get_parent_by_index(hw, index);
 	if (clk_flags & CLK_SET_RATE_PARENT) {
 		if (f->pre_div) {
+			if (!rate)
+				rate = req->rate;
 			rate /= 2;
 			rate *= f->pre_div + 1;
 		}
diff --git a/drivers/clk/qcom/common.c b/drivers/clk/qcom/common.c
index 28ceaf1e9937..ae9352f7706d 100644
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



