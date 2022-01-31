Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123DF4A4125
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358740AbiAaLCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358755AbiAaLBT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:01:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86460C061392;
        Mon, 31 Jan 2022 03:00:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52EC2B82A57;
        Mon, 31 Jan 2022 11:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F54C340E8;
        Mon, 31 Jan 2022 10:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626799;
        bh=0EFvWCyzPTR972W2aSbT7/hxxvBhl8DPD0Oj9l1LhLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKfRVeCJJD9AyjlCrGHqSzHUOysIOhn8Xsd+gMnfn6YFBCbcfdhcFY6WyVcCIoohp
         QU3Amm8JRZzm+63k2MSBmtOD5zL32Wc4OIz5CD95HfpqlaO+Gcqxr3fCZrw1YenIEp
         /mikEq9Ib1jzWsmZiCrUPxfHw9FmmrF2ViLiJa+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 36/64] hwmon: (lm90) Mark alert as broken for MAX6680
Date:   Mon, 31 Jan 2022 11:56:21 +0100
Message-Id: <20220131105216.900187278@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit 94746b0ba479743355e0d3cc1cb9cfe3011fb8be upstream.

Experiments with MAX6680 and MAX6681 show that the alert function of those
chips is broken, similar to other chips supported by the lm90 driver.
Mark it accordingly.

Fixes: 4667bcb8d8fc ("hwmon: (lm90) Introduce chip parameter structure")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm90.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -418,7 +418,7 @@ static const struct lm90_params lm90_par
 	},
 	[max6680] = {
 		.flags = LM90_HAVE_OFFSET | LM90_HAVE_CRIT
-		  | LM90_HAVE_CRIT_ALRM_SWP,
+		  | LM90_HAVE_CRIT_ALRM_SWP | LM90_HAVE_BROKEN_ALERT,
 		.alert_alarms = 0x7c,
 		.max_convrate = 7,
 	},


