Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0EE324F43C
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgHXIeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:34:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727843AbgHXIeE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:34:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04398206F0;
        Mon, 24 Aug 2020 08:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258044;
        bh=evrX5QJ9QJ1lif9LJ3zyHjUhpH2onfx59pzdGciYxas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUBDLhOGkJzUWce8Wmz31njJruZVySb8nH+oOeH9WSpO6k4Y+siaB47MOKrQC3Npb
         HNZ7s4k7LI09sC1/bQvFGdck9BZAOWVBnhF9Ws/7gdReJqNhFocfIzOlBZe/0mZu8e
         vDRD4dl6sWppDpeLtzrtD5t60saoK5TpG0T0rKLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rajendra Nayak <rnayak@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.8 024/148] opp: Put opp table in dev_pm_opp_set_rate() if _set_opp_bw() fails
Date:   Mon, 24 Aug 2020 10:28:42 +0200
Message-Id: <20200824082415.122358606@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

commit d4ec88d205583ac4f9482cf3e89128589bd881d2 upstream.

We get the opp_table pointer at the top of the function and so we should
put the pointer at the end of the function like all other exit paths
from this function do.

Cc: v5.8+ <stable@vger.kernel.org> # v5.8+
Fixes: b00e667a6d8b ("opp: Remove bandwidth votes when target_freq is zero")
Reviewed-by: Rajendra Nayak <rnayak@codeaurora.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
[ Viresh: Split the patch into two ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/opp/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -876,7 +876,7 @@ int dev_pm_opp_set_rate(struct device *d
 
 		ret = _set_opp_bw(opp_table, NULL, dev, true);
 		if (ret)
-			return ret;
+			goto put_opp_table;
 
 		if (opp_table->regulator_enabled) {
 			regulator_disable(opp_table->regulators[0]);


