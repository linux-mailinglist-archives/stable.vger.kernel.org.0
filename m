Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E079C5B7365
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234812AbiIMPGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234769AbiIMPEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:04:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA316C114;
        Tue, 13 Sep 2022 07:30:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AA8FB80F88;
        Tue, 13 Sep 2022 14:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A190FC433C1;
        Tue, 13 Sep 2022 14:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079399;
        bh=kJnMTM4ch+C5OZcgzioPZy99krNqCRBxoSYBe+BzVks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c6dDT8CwM6JfjNWfEvsSuKkF8ZO1So7cZmjWBx169iZGudgZbb/AdpJ6P2EetOgTB
         95eXjuo8zYYOjv8gKmdLaEWwnMo1Udaw0W83chzRHQk2jRLTYWtgnziSawUGFe72+h
         CfB4iONCsNx0ocJ+RiYE35tUw3KQ8kMWI2JeCRC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/79] ieee802154/adf7242: defer destroy_workqueue call
Date:   Tue, 13 Sep 2022 16:06:29 +0200
Message-Id: <20220913140349.397572900@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
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

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit afe7116f6d3b888778ed6d95e3cf724767b9aedf ]

There is a possible race condition (use-after-free) like below

  (FREE)                     |  (USE)
  adf7242_remove             |  adf7242_channel
   cancel_delayed_work_sync  |
    destroy_workqueue (1)    |   adf7242_cmd_rx
                             |    mod_delayed_work (2)
                             |

The root cause for this race is that the upper layer (ieee802154) is
unaware of this detaching event and the function adf7242_channel can
be called without any checks.

To fix this, we can add a flag write at the beginning of adf7242_remove
and add flag check in adf7242_channel. Or we can just defer the
destructive operation like other commit 3e0588c291d6 ("hamradio: defer
ax25 kfree after unregister_netdev") which let the
ieee802154_unregister_hw() to handle the synchronization. This patch
takes the second option.

Fixes: 58e9683d1475 ("net: ieee802154: adf7242: Fix OCL calibration
runs")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Link: https://lore.kernel.org/r/20220808034224.12642-1-linma@zju.edu.cn
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/adf7242.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/adf7242.c b/drivers/net/ieee802154/adf7242.c
index a686926bba71e..6ef5523f4e717 100644
--- a/drivers/net/ieee802154/adf7242.c
+++ b/drivers/net/ieee802154/adf7242.c
@@ -1318,10 +1318,11 @@ static int adf7242_remove(struct spi_device *spi)
 
 	debugfs_remove_recursive(lp->debugfs_root);
 
+	ieee802154_unregister_hw(lp->hw);
+
 	cancel_delayed_work_sync(&lp->work);
 	destroy_workqueue(lp->wqueue);
 
-	ieee802154_unregister_hw(lp->hw);
 	mutex_destroy(&lp->bmux);
 	ieee802154_free_hw(lp->hw);
 
-- 
2.35.1



