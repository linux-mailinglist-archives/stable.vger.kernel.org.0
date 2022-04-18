Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B45BE50531A
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240415AbiDRMzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240152AbiDRMzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:55:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069DF26D8;
        Mon, 18 Apr 2022 05:36:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B43D5B80EDB;
        Mon, 18 Apr 2022 12:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12266C385A7;
        Mon, 18 Apr 2022 12:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285368;
        bh=FKCuWOC6ffndzrnpSTTa28q33b3gOGJNIh/XhkYXer0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hsi5CQPmEvEB0HGedN2y5ZIlQj+gV1/2eAVG9qqO7UB6trcuDEikVp7/8/zQotwLL
         RKiDtElP3iNFtWaD+EZtYG8NtSGdj8m5fCcq1/lTVq1UhcRu7pjtZg82QugDPFffqB
         Lme32364WTf5ZFdgLWumvkyR/V9lZ9A5o4eDKI8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Duoming Zhou <duoming@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.15 187/189] ax25: fix NPD bug in ax25_disconnect
Date:   Mon, 18 Apr 2022 14:13:27 +0200
Message-Id: <20220418121208.707407249@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

commit 7ec02f5ac8a5be5a3f20611731243dc5e1d9ba10 upstream.

The ax25_disconnect() in ax25_kill_by_device() is not
protected by any locks, thus there is a race condition
between ax25_disconnect() and ax25_destroy_socket().
when ax25->sk is assigned as NULL by ax25_destroy_socket(),
a NULL pointer dereference bug will occur if site (1) or (2)
dereferences ax25->sk.

ax25_kill_by_device()                | ax25_release()
  ax25_disconnect()                  |   ax25_destroy_socket()
    ...                              |
    if(ax25->sk != NULL)             |     ...
      ...                            |     ax25->sk = NULL;
      bh_lock_sock(ax25->sk); //(1)  |     ...
      ...                            |
      bh_unlock_sock(ax25->sk); //(2)|

This patch moves ax25_disconnect() into lock_sock(), which can
synchronize with ax25_destroy_socket() in ax25_release().

Fail log:
===============================================================
BUG: kernel NULL pointer dereference, address: 0000000000000088
...
RIP: 0010:_raw_spin_lock+0x7e/0xd0
...
Call Trace:
ax25_disconnect+0xf6/0x220
ax25_device_event+0x187/0x250
raw_notifier_call_chain+0x5e/0x70
dev_close_many+0x17d/0x230
rollback_registered_many+0x1f1/0x950
unregister_netdevice_queue+0x133/0x200
unregister_netdev+0x13/0x20
...

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
[OP: backport to 5.15: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ax25/af_ax25.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -102,8 +102,8 @@ again:
 				dev_put(ax25_dev->dev);
 				ax25_dev_put(ax25_dev);
 			}
-			release_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
+			release_sock(sk);
 			spin_lock_bh(&ax25_list_lock);
 			sock_put(sk);
 			/* The entry could have been deleted from the


