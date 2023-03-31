Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E5F6D1FC3
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 14:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjCaMLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 08:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbjCaMLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 08:11:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7401C1E7
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 05:11:15 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1piDaw-0007FG-1z; Fri, 31 Mar 2023 14:11:02 +0200
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1piDas-007zAJ-JN; Fri, 31 Mar 2023 14:10:58 +0200
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1piDar-001AI2-Gf; Fri, 31 Mar 2023 14:10:57 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-wireless <linux-wireless@vger.kernel.org>
Cc:     Hans Ulli Kroll <linux@ulli-kroll.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Tim K <tpkuester@gmail.com>,
        "Alex G ." <mr.nuke.me@gmail.com>,
        Nick Morrow <morrownr@gmail.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Andreas Henriksson <andreas@fatal.se>,
        ValdikSS <iam@valdikss.org.ru>, kernel@pengutronix.de,
        stable@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 0/2] RTW88 USB bug fixes
Date:   Fri, 31 Mar 2023 14:10:52 +0200
Message-Id: <20230331121054.112758-1-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series fixes two bugs in the RTW88 USB driver I was reported from
several people and that I also encountered myself.

The first one resulted in "timed out to flush queue 3" messages from the
driver and sometimes a complete stall of the TX queues.

The second one is specific to the RTW8821CU chipset. Here 2GHz networks
were hardly seen and impossible to connect to. This goes down to
misinterpreting the rfe_option field in the efuse.

Sascha Hauer (2):
  wifi: rtw88: usb: fix priority queue to endpoint mapping
  wifi: rtw88: rtw8821c: Fix rfe_option field width

 drivers/net/wireless/realtek/rtw88/rtw8821c.c |  3 +-
 drivers/net/wireless/realtek/rtw88/usb.c      | 70 +++++++++++++------
 2 files changed, 48 insertions(+), 25 deletions(-)

-- 
2.39.2

