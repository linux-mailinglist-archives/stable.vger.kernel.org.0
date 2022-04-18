Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59D50505151
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiDRMeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239813AbiDRMda (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:33:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF32E1B7BC;
        Mon, 18 Apr 2022 05:26:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B2BBB80EC4;
        Mon, 18 Apr 2022 12:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF383C385A7;
        Mon, 18 Apr 2022 12:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284794;
        bh=fQz95VQGj/snvgUQr1orr2rTIm2nhPy3+TCq+9h2NW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qXjZ+NXCqpc2grWSxQIzAoxaVW9MEjfaBc/Kj7UWImEghyAGzbOd+m+NsNMmdHA1p
         lVp75A5/p94E/0E/Kxp4jqzukudlyhxsXv9YluWIDDyp96ZTmb0flnUBqt9uNJNYyN
         O1u76IUoXKQT73C+nP4he883VO4cdueazgEgOJsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Xu Jia <xujia39@huawei.com>
Subject: [PATCH 5.15 003/189] hamradio: defer 6pack kfree after unregister_netdev
Date:   Mon, 18 Apr 2022 14:10:23 +0200
Message-Id: <20220418121200.464640857@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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
@@ -674,9 +674,11 @@ static void sixpack_close(struct tty_str
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


