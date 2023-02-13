Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B62D6949D1
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbjBMPC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbjBMPCR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:02:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BCD1C7F2
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:01:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 151BB610A4
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28549C433D2;
        Mon, 13 Feb 2023 15:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300518;
        bh=YhAdBqEzmhfd98K/RMO2qNZfKjTbaovRi+FWHgdKGxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2g1jAGpEQz0EMoeUQy5wf2RffWxO+NyVssvzQGx6+l5pV5/Pl9YtRCcsVbwNjy+p
         la94v9OaRtdOyUJtRB9bM8r0vUtY7NgpvwKjFDUAsoskeuS9tmDcn6rXVfb/q/w5hH
         MV5qQKfrwWNH/yLWhSj+WcOVkAZkiVP/c7QehFjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bhaskar Upadhaya <bupadhaya@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/139] qede: add netpoll support for qede driver
Date:   Mon, 13 Feb 2023 15:49:42 +0100
Message-Id: <20230213144747.610907226@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhaskar Upadhaya <bupadhaya@marvell.com>

[ Upstream commit 961aa716235f58088e99acafbe66027d678061ce ]

handle netpoll case when qede_poll is called by
netpoll layer with budget 0

Signed-off-by: Bhaskar Upadhaya <bupadhaya@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 2ccce20d51fa ("qede: execute xdp_do_flush() before napi_complete_done()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index d210632676d3..5b1885c0a8bd 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1456,7 +1456,8 @@ int qede_poll(struct napi_struct *napi, int budget)
 	rx_work_done = (likely(fp->type & QEDE_FASTPATH_RX) &&
 			qede_has_rx_work(fp->rxq)) ?
 			qede_rx_int(fp, budget) : 0;
-	if (rx_work_done < budget) {
+	/* Handle case where we are called by netpoll with a budget of 0 */
+	if (rx_work_done < budget || !budget) {
 		if (!qede_poll_is_more_work(fp)) {
 			napi_complete_done(napi, rx_work_done);
 
-- 
2.39.0



