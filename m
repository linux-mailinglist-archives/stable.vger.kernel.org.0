Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C56C528E18
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345546AbiEPTj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345654AbiEPTiz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:38:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6052E3F335;
        Mon, 16 May 2022 12:38:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BB8E6151A;
        Mon, 16 May 2022 19:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9331AC385AA;
        Mon, 16 May 2022 19:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652729920;
        bh=ImZUDBBgB97HF5DepotU5HncIpadO7ZFQwagfgBDrGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AdERLr+tSM56pez1pj+wjXAK3+jRZTHWYUSWr8V2WD/PDjOj1vbIrUV/hT+40WstS
         PxdobHJM7QqVGNcnxXmFIj54UWawBEdB4bFUbyPCAlAjSmYRXlXhsYilBkFdeEyHEz
         RSyWg/EwvRWNrQAgxJTQhCN3CnJKJJVpKrOOlWgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandra Winter <wintera@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 06/19] s390/ctcm: fix potential memory leak
Date:   Mon, 16 May 2022 21:36:19 +0200
Message-Id: <20220516193613.689815922@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193613.497233635@linuxfoundation.org>
References: <20220516193613.497233635@linuxfoundation.org>
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

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit 0c0b20587b9f25a2ad14db7f80ebe49bdf29920a ]

smatch complains about
drivers/s390/net/ctcm_mpc.c:1210 ctcmpc_unpack_skb() warn: possible memory leak of 'mpcginfo'

mpc_action_discontact() did not free mpcginfo. Consolidate the freeing in
ctcmpc_unpack_skb().

Fixes: 293d984f0e36 ("ctcm: infrastructure for replaced ctc driver")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/ctcm_mpc.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/s390/net/ctcm_mpc.c b/drivers/s390/net/ctcm_mpc.c
index c103fc7efe9f..f2559e20df70 100644
--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -624,8 +624,6 @@ static void mpc_rcvd_sweep_resp(struct mpcg_info *mpcginfo)
 		ctcm_clear_busy_do(dev);
 	}
 
-	kfree(mpcginfo);
-
 	return;
 
 }
@@ -1205,10 +1203,10 @@ static void ctcmpc_unpack_skb(struct channel *ch, struct sk_buff *pskb)
 						CTCM_FUNTAIL, dev->name);
 			priv->stats.rx_dropped++;
 			/* mpcginfo only used for non-data transfers */
-			kfree(mpcginfo);
 			if (do_debug_data)
 				ctcmpc_dump_skb(pskb, -8);
 		}
+		kfree(mpcginfo);
 	}
 done:
 
@@ -1998,7 +1996,6 @@ static void mpc_action_rcvd_xid0(fsm_instance *fsm, int event, void *arg)
 		}
 		break;
 	}
-	kfree(mpcginfo);
 
 	CTCM_PR_DEBUG("ctcmpc:%s() %s xid2:%i xid7:%i xidt_p2:%i \n",
 		__func__, ch->id, grp->outstanding_xid2,
@@ -2059,7 +2056,6 @@ static void mpc_action_rcvd_xid7(fsm_instance *fsm, int event, void *arg)
 		mpc_validate_xid(mpcginfo);
 		break;
 	}
-	kfree(mpcginfo);
 	return;
 }
 
-- 
2.35.1



