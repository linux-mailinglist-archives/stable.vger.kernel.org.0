Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19D1B150D49
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbgBCQcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:32:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:45894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729860AbgBCQcN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:32:13 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35F3C21744;
        Mon,  3 Feb 2020 16:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747532;
        bh=CslaSSQI+Lm9q11vj17D/LgMKJ+dG/2Gb2LaHCRJXVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wLUv9+uCqVw6X9sGM6S+EyS9swUbECRKcl0x+EWYEEPtlt6/+PfcYTSO8hj25sePe
         raf9u3Acm9/9slg9Ze7QjmSoYsFiEQHEuyCrzexS8kehEkXP2PXDz7uRvXQqONa9V/
         s3z6bP9VUjxmp+WoRrik881ZabceqWy1wCaEmztM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>,
        Stephen Boyd <sboyd@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 33/70] clk: mmp2: Fix the order of timer mux parents
Date:   Mon,  3 Feb 2020 16:19:45 +0000
Message-Id: <20200203161917.321882979@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
References: <20200203161912.158976871@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lubomir Rintel <lkundrak@v3.sk>

[ Upstream commit 8bea5ac0fbc5b2103f8779ddff216122e3c2e1ad ]

Determined empirically, no documentation is available.

The OLPC XO-1.75 laptop used parent 1, that one being VCTCXO/4 (65MHz), but
thought it's a VCTCXO/2 (130MHz). The mmp2 timer driver, not knowing
what is going on, ended up just dividing the rate as of
commit f36797ee4380 ("ARM: mmp/mmp2: dt: enable the clock")'

Link: https://lore.kernel.org/r/20191218190454.420358-3-lkundrak@v3.sk
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mmp/clk-of-mmp2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/mmp/clk-of-mmp2.c b/drivers/clk/mmp/clk-of-mmp2.c
index d083b860f0833..10689d8cd3867 100644
--- a/drivers/clk/mmp/clk-of-mmp2.c
+++ b/drivers/clk/mmp/clk-of-mmp2.c
@@ -134,7 +134,7 @@ static DEFINE_SPINLOCK(ssp3_lock);
 static const char *ssp_parent_names[] = {"vctcxo_4", "vctcxo_2", "vctcxo", "pll1_16"};
 
 static DEFINE_SPINLOCK(timer_lock);
-static const char *timer_parent_names[] = {"clk32", "vctcxo_2", "vctcxo_4", "vctcxo"};
+static const char *timer_parent_names[] = {"clk32", "vctcxo_4", "vctcxo_2", "vctcxo"};
 
 static DEFINE_SPINLOCK(reset_lock);
 
-- 
2.20.1



