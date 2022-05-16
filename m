Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4A65291BC
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbiEPUJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351029AbiEPUB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EFA4738B;
        Mon, 16 May 2022 12:56:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF947B81614;
        Mon, 16 May 2022 19:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BDFC385AA;
        Mon, 16 May 2022 19:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730997;
        bh=q9gU/Mr7BlvIaiZEGB9eEEKAmSd+1AXD+9YImC1STPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bd052qXz7mpQfPQecEKzPeklpMak9AEPycIw+31+xnTwKs1qEOnYrixEHtN+nReEx
         J6xeyxY0Y4eT72KCewv5vkD/yz1nmJcOaG3ii7DAUra26If82/0ZXsknGXmFzhmMpQ
         OcE7gA+4qqG2RV64rTEvLZvvy3wp8yPLSSNfftdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 044/114] net/smc: non blocking recvmsg() return -EAGAIN when no data and signal_pending
Date:   Mon, 16 May 2022 21:36:18 +0200
Message-Id: <20220516193626.758823377@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guangguan Wang <guangguan.wang@linux.alibaba.com>

[ Upstream commit f3c46e41b32b6266cf60b0985c61748f53bf1c61 ]

Non blocking sendmsg will return -EAGAIN when any signal pending
and no send space left, while non blocking recvmsg return -EINTR
when signal pending and no data received. This may makes confused.
As TCP returns -EAGAIN in the conditions described above. Align the
behavior of smc with TCP.

Fixes: 846e344eb722 ("net/smc: add receive timeout check")
Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Acked-by: Karsten Graul <kgraul@linux.ibm.com>
Link: https://lore.kernel.org/r/20220512030820.73848-1-guangguan.wang@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index 51e8eb2933ff..338b9ef806e8 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -355,12 +355,12 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
 				}
 				break;
 			}
+			if (!timeo)
+				return -EAGAIN;
 			if (signal_pending(current)) {
 				read_done = sock_intr_errno(timeo);
 				break;
 			}
-			if (!timeo)
-				return -EAGAIN;
 		}
 
 		if (!smc_rx_data_available(conn)) {
-- 
2.35.1



