Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A0069CC42
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjBTNio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbjBTNin (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:38:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872A61B567
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:38:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D53AB80D44
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BF0C433D2;
        Mon, 20 Feb 2023 13:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900320;
        bh=XpOmjL4rZAZF3gpGNKAk3Yqsv8PYa6+k6gWhY78I28g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=daXGOzx2M8b0TvW+Ef/e5bkr934uKn1gscalnTLGPu1PQldv8a4/m7ygv30s42kmY
         PEVUfwMWsL9fFKZRjl38gvqIWevr33zYlDWOezb7MAHVzOjyQ7i8Dj5Fo3k+HgPk1m
         cq6MZy8IIId/Rkonq07CrL6eHGD1ZWYGiv9uAUu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 06/53] sctp: do not check hb_timer.expires when resetting hb_timer
Date:   Mon, 20 Feb 2023 14:35:32 +0100
Message-Id: <20230220133548.393857156@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 8f35ae17ef565a605de5f409e04bcd49a55d7646 ]

It tries to avoid the frequently hb_timer refresh in commit ba6f5e33bdbb
("sctp: avoid refreshing heartbeat timer too often"), and it only allows
mod_timer when the new expires is after hb_timer.expires. It means even
a much shorter interval for hb timer gets applied, it will have to wait
until the current hb timer to time out.

In sctp_do_8_2_transport_strike(), when a transport enters PF state, it
expects to update the hb timer to resend a heartbeat every rto after
calling sctp_transport_reset_hb_timer(), which will not work as the
change mentioned above.

The frequently hb_timer refresh was caused by sctp_transport_reset_timers()
called in sctp_outq_flush() and it was already removed in the commit above.
So we don't have to check hb_timer.expires when resetting hb_timer as it is
now not called very often.

Fixes: ba6f5e33bdbb ("sctp: avoid refreshing heartbeat timer too often")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Link: https://lore.kernel.org/r/d958c06985713ec84049a2d5664879802710179a.1675095933.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/transport.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index af56651169b2..79d2aa44c6e5 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -210,9 +210,7 @@ void sctp_transport_reset_hb_timer(struct sctp_transport *transport)
 
 	/* When a data chunk is sent, reset the heartbeat interval.  */
 	expires = jiffies + sctp_transport_timeout(transport);
-	if ((time_before(transport->hb_timer.expires, expires) ||
-	     !timer_pending(&transport->hb_timer)) &&
-	    !mod_timer(&transport->hb_timer,
+	if (!mod_timer(&transport->hb_timer,
 		       expires + prandom_u32_max(transport->rto)))
 		sctp_transport_hold(transport);
 }
-- 
2.39.0



