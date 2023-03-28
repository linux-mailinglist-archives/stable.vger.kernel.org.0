Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6BEB6CC29A
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbjC1Oqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbjC1Oqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:46:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA218DBC6
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:46:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03FCBB81D73
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E65C4339C;
        Tue, 28 Mar 2023 14:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014768;
        bh=g645UCdRm+Q3STv9A/oykTW4x+t+jPpUxv6iQddpaZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pzMd7nKiSG3ZhhrUFEeDxoab/zdaFOW+pjJH5xFffj3rndBXWkmbPAek9NhAFLqEQ
         ZMfcgn0tTmQkweHdZcFvqzJKEB8JppSe5GcYmDxiqtumO/9O+VbxA2F2U3tF+MlpX0
         dmDET10A7xp4F3Aah4V1cDzGKlmIRo7YQxF3yZlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheng Wang <zyytlz.wz@163.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 046/240] xirc2ps_cs: Fix use after free bug in xirc2ps_detach
Date:   Tue, 28 Mar 2023 16:40:09 +0200
Message-Id: <20230328142621.631375961@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit e8d20c3ded59a092532513c9bd030d1ea66f5f44 ]

In xirc2ps_probe, the local->tx_timeout_task was bounded
with xirc2ps_tx_timeout_task. When timeout occurs,
it will call xirc_tx_timeout->schedule_work to start the
work.

When we call xirc2ps_detach to remove the driver, there
may be a sequence as follows:

Stop responding to timeout tasks and complete scheduled
tasks before cleanup in xirc2ps_detach, which will fix
the problem.

CPU0                  CPU1

                    |xirc2ps_tx_timeout_task
xirc2ps_detach      |
  free_netdev       |
    kfree(dev);     |
                    |
                    | do_reset
                    |   //use dev

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xircom/xirc2ps_cs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index 894e92ef415b9..9f505cf02d965 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -503,6 +503,11 @@ static void
 xirc2ps_detach(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv;
+    struct local_info *local = netdev_priv(dev);
+
+    netif_carrier_off(dev);
+    netif_tx_disable(dev);
+    cancel_work_sync(&local->tx_timeout_task);
 
     dev_dbg(&link->dev, "detach\n");
 
-- 
2.39.2



