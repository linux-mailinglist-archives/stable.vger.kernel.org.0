Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2CF659D59D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346082AbiHWJBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347510AbiHWJAe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:00:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B418276C;
        Tue, 23 Aug 2022 01:27:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D1486132D;
        Tue, 23 Aug 2022 08:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB86C433C1;
        Tue, 23 Aug 2022 08:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243243;
        bh=I7mToTYrlG00p7FiW4DaYlyEvxUMSTtAGzBRGbiFV+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbz3CEqxWzH5bD0e5pOMCcm84LpTjBtjPuJfO3cTZqre7lEOg2fbA/C130ErRhCne
         STZJ3bitoWfoNglrg1tG4vv+ksTeNaPB5mOnS+7sIPl7F95rHRtK83dRoOZNxirv3c
         b2fY0Z2NY/9em5cqpBC/ndGBSoeliN/pCoFoJVVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 215/365] net: dsa: felix: fix ethtool 256-511 and 512-1023 TX packet counters
Date:   Tue, 23 Aug 2022 10:01:56 +0200
Message-Id: <20220823080127.190879077@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 40d21c4565bce064c73a03b79a157a3493c518b9 upstream.

What the driver actually reports as 256-511 is in fact 512-1023, and the
TX packets in the 256-511 bucket are not reported. Fix that.

Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -601,7 +601,8 @@ static const struct ocelot_stat_layout v
 	{ .offset = 0x87,	.name = "tx_frames_below_65_octets", },
 	{ .offset = 0x88,	.name = "tx_frames_65_to_127_octets", },
 	{ .offset = 0x89,	.name = "tx_frames_128_255_octets", },
-	{ .offset = 0x8B,	.name = "tx_frames_256_511_octets", },
+	{ .offset = 0x8A,	.name = "tx_frames_256_511_octets", },
+	{ .offset = 0x8B,	.name = "tx_frames_512_1023_octets", },
 	{ .offset = 0x8C,	.name = "tx_frames_1024_1526_octets", },
 	{ .offset = 0x8D,	.name = "tx_frames_over_1526_octets", },
 	{ .offset = 0x8E,	.name = "tx_yellow_prio_0", },


