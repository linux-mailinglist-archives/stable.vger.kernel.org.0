Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F2B2E9A66
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbhADQJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:09:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:38446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728603AbhADQBd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:01:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C80F8224D4;
        Mon,  4 Jan 2021 16:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776078;
        bh=Qsw7kkjV4wurJiVt+Wqj5QaGaotP5tCVGEJj8RzI4A4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1rxRiBObT60iOmrGdiit3ZJQHxzR39S38rYgQmf1bPh5vHWlkd1ORwhP4VMKj8FaB
         GaZE4fhuWcCKJUV/879Zhy2RVC+AOBAzp8Gkqmyr/lHeV9/QrmBtbocoHKinOOMdgY
         dGYBnBxsAaElbuRX1p4n37qnjSxOMC4DgcSgGNcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.10 12/63] opp: Call the missing clk_put() on error
Date:   Mon,  4 Jan 2021 16:57:05 +0100
Message-Id: <20210104155709.406778571@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

commit 0e1d9ca1766f5d95fb881f57b6c4a1ffa63d4648 upstream.

Fix the clock reference counting by calling the missing clk_put() in the
error path.

Cc: v5.10 <stable@vger.kernel.org> # v5.10
Fixes: dd461cd9183f ("opp: Allow dev_pm_opp_get_opp_table() to return -EPROBE_DEFER")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/opp/core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -1111,7 +1111,7 @@ static struct opp_table *_allocate_opp_t
 	ret = dev_pm_opp_of_find_icc_paths(dev, opp_table);
 	if (ret) {
 		if (ret == -EPROBE_DEFER)
-			goto remove_opp_dev;
+			goto put_clk;
 
 		dev_warn(dev, "%s: Error finding interconnect paths: %d\n",
 			 __func__, ret);
@@ -1125,6 +1125,9 @@ static struct opp_table *_allocate_opp_t
 	list_add(&opp_table->node, &opp_tables);
 	return opp_table;
 
+put_clk:
+	if (!IS_ERR(opp_table->clk))
+		clk_put(opp_table->clk);
 remove_opp_dev:
 	_remove_opp_dev(opp_dev, opp_table);
 err:


