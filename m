Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F38215C447
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbgBMPpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:45:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:50364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387439AbgBMP1Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:25 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 529432468D;
        Thu, 13 Feb 2020 15:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607644;
        bh=8o5e555fo6HVVk33P4Q8tLT7prYOfmlPR4EsrzZIo9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h+pw4i7nRZlG8EZRPrcrLPvPOdEyQJXO9XCt6fRQPZkK+eMpA1iq2dACRB+Rq4DY+
         RPQdw+muETkY2StTG2X8IGU2Y6BSUIiF+icUbQY7Xud3rzwBL1HFUCeB4baQq6wvTV
         /0QvNRuZJilUOt2IWFa8zTTk+tO6EchrXQFYMKZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rajendra Nayak <rnayak@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.4 52/96] soc: qcom: rpmhpd: Set active_only for active only power domains
Date:   Thu, 13 Feb 2020 07:20:59 -0800
Message-Id: <20200213151859.509408868@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

commit 5d0d4d42bed0090d3139e7c5ca1587d76d48add6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/soc/qcom/rpmhpd.c |    2 ++
 1 file changed, 2 insertions(+)

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


