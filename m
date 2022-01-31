Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733734A44C5
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359660AbiAaLc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379574AbiAaLa0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:30:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B551C0613A0;
        Mon, 31 Jan 2022 03:21:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDB5161253;
        Mon, 31 Jan 2022 11:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4B2C340E8;
        Mon, 31 Jan 2022 11:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628064;
        bh=cyrUHQ/bV6GZ/AT9V/xmKq9w0SJfnB1JiyEl7DchvfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CWNPPF58UwhGgVUpA7QM1nG4DVIbbNXvrsIvo6wPVp64jn1wow+6EQeW5pATn6V+E
         k0eZ5S7z3JTKmrUsJBeATLQAdfC0o9GMPeSuFX76KlHtnCLA81RT2mOVBHwstiCj0J
         hrveJS5HQS29eRVCus3NdnkKrzwB7Kjr1LU8K6v8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 113/200] hwmon: (lm90) Reduce maximum conversion rate for G781
Date:   Mon, 31 Jan 2022 11:56:16 +0100
Message-Id: <20220131105237.383611388@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit a66c5ed539277b9f2363bbace0dba88b85b36c26 ]

According to its datasheet, G781 supports a maximum conversion rate value
of 8 (62.5 ms). However, chips labeled G781 and G780 were found to only
support a maximum conversion rate value of 7 (125 ms). On the other side,
chips labeled G781-1 and G784 were found to support a conversion rate value
of 8. There is no known means to distinguish G780 from G781 or G784; all
chips report the same manufacturer ID and chip revision.
Setting the conversion rate register value to 8 on chips not supporting
it causes unexpected behavior since the real conversion rate is set to 0
(16 seconds) if a value of 8 is written into the conversion rate register.
Limit the conversion rate register value to 7 for all G78x chips to avoid
the problem.

Fixes: ae544f64cc7b ("hwmon: (lm90) Add support for GMT G781")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm90.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -373,7 +373,7 @@ static const struct lm90_params lm90_par
 		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT
 		  | LM90_HAVE_BROKEN_ALERT | LM90_HAVE_CRIT,
 		.alert_alarms = 0x7c,
-		.max_convrate = 8,
+		.max_convrate = 7,
 	},
 	[lm86] = {
 		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT


