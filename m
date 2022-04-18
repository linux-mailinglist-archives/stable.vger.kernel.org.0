Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B155F5053F3
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238734AbiDRNBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241439AbiDRM6p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:58:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929ED1FA46;
        Mon, 18 Apr 2022 05:39:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB3186119B;
        Mon, 18 Apr 2022 12:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE82EC385A1;
        Mon, 18 Apr 2022 12:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285545;
        bh=5fViKXH6yIfHBoQAnKXrMdVGEo8QWYU9eBsjCEJYbQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VhAUN8HfCigBnaUwtmLWpQXRp3rsKq+OaU8xLlZm+wHPM8hBxryymZv8IFdr4Igwj
         GrYYzBKkTllyGH0otPzim5fkMR5e3d7Bld/N0u+BQyi+qaP7nBdpNeUiwwrwQ+sNxb
         H1W6whzYw3n2k8KoaDsBv/mUEjjgL4oqOo7zNmyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Xu Jia <xujia39@huawei.com>
Subject: [PATCH 5.10 002/105] hamradio: defer 6pack kfree after unregister_netdev
Date:   Mon, 18 Apr 2022 14:12:04 +0200
Message-Id: <20220418121145.301779931@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
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

From: Lin Ma <linma@zju.edu.cn>

commit 0b9111922b1f399aba6ed1e1b8f2079c3da1aed8 upstream.

There is a possible race condition (use-after-free) like below

 (USE)                       |  (FREE)
  dev_queue_xmit             |
   __dev_queue_xmit          |
    __dev_xmit_skb           |
     sch_direct_xmit         | ...
      xmit_one               |
       netdev_start_xmit     | tty_ldisc_kill
        __netdev_start_xmit  |  6pack_close
         sp_xmit             |   kfree
          sp_encaps          |
                             |

According to the patch "defer ax25 kfree after unregister_netdev", this
patch reorder the kfree after the unregister_netdev to avoid the possible
UAF as the unregister_netdev() is well synchronized and won't return if
there is a running routine.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Xu Jia <xujia39@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hamradio/6pack.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -679,9 +679,11 @@ static void sixpack_close(struct tty_str
 	del_timer_sync(&sp->tx_t);
 	del_timer_sync(&sp->resync_t);
 
-	/* Free all 6pack frame buffers. */
+	/* Free all 6pack frame buffers after unreg. */
 	kfree(sp->rbuff);
 	kfree(sp->xbuff);
+
+	free_netdev(sp->dev);
 }
 
 /* Perform I/O control on an active 6pack channel. */


