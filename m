Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7304ABA46
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbiBGLXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343595AbiBGLL0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:11:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994D3C043181;
        Mon,  7 Feb 2022 03:11:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54CBDB80EC3;
        Mon,  7 Feb 2022 11:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77227C004E1;
        Mon,  7 Feb 2022 11:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232283;
        bh=vUVllwFVFBsSbxrgKrcpea+UkBuD/6BtF3/nSWDWPlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKOa0us9b+4DVWNAlZQFSJJm9h8a2nys09WHOq0GdjuldciughsUygZm1F98WKPYQ
         IpZ0vvGmXxTIlYL6op2wYsYZmYT3v4IwZS7i8pc9rsAZ8ip0pVz1lVPogVnxK4Wduw
         ldzF3dWHv2k4DjO3g7nq1jb1NX4M4H2udVUo2B8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 28/69] hwmon: (lm90) Reduce maximum conversion rate for G781
Date:   Mon,  7 Feb 2022 12:05:50 +0100
Message-Id: <20220207103756.549415962@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
@@ -359,7 +359,7 @@ static const struct lm90_params lm90_par
 		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT
 		  | LM90_HAVE_BROKEN_ALERT,
 		.alert_alarms = 0x7c,
-		.max_convrate = 8,
+		.max_convrate = 7,
 	},
 	[lm86] = {
 		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT,


