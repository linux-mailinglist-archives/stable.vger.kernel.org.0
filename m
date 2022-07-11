Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0EB956FA89
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbiGKJTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbiGKJS6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:18:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B56813F97;
        Mon, 11 Jul 2022 02:12:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33AE2B80E7B;
        Mon, 11 Jul 2022 09:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88AE4C34115;
        Mon, 11 Jul 2022 09:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530720;
        bh=ruEx4MVS5M1wTW8qnmp6vimm1tVCSCBwM9ARVgswI6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CdPRnI+toZ7M0Aj8/UdKy3u05acocId8UvKFURQaRDXlERh9hPJOM75O0ZPH0VlBA
         JCCxIvNkqrmxwZ+bWJf6HagmQEaFBdVY4Lrt3IQ1aj/poWiTowFMqJJ4Jjsk0X+EG2
         isTAclDayPskci9FUcuBgp4mkTFciYg/fq2FdL90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Larsson <andreas@gaisler.com>,
        Liang He <windhl@126.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 04/55] can: grcan: grcan_probe(): remove extra of_node_get()
Date:   Mon, 11 Jul 2022 11:06:52 +0200
Message-Id: <20220711090541.893750782@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090541.764895984@linuxfoundation.org>
References: <20220711090541.764895984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

commit 562fed945ea482833667f85496eeda766d511386 upstream.

In grcan_probe(), of_find_node_by_path() has already increased the
refcount. There is no need to call of_node_get() again, so remove it.

Link: https://lore.kernel.org/all/20220619070257.4067022-1-windhl@126.com
Fixes: 1e93ed26acf0 ("can: grcan: grcan_probe(): fix broken system id check for errata workaround needs")
Cc: stable@vger.kernel.org # v5.18
Cc: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/grcan.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1659,7 +1659,6 @@ static int grcan_probe(struct platform_d
 	 */
 	sysid_parent = of_find_node_by_path("/ambapp0");
 	if (sysid_parent) {
-		of_node_get(sysid_parent);
 		err = of_property_read_u32(sysid_parent, "systemid", &sysid);
 		if (!err && ((sysid & GRLIB_VERSION_MASK) >=
 			     GRCAN_TXBUG_SAFE_GRLIB_VERSION))


