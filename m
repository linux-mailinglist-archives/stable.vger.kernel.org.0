Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC599521711
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242889AbiEJNXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243203AbiEJNVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:21:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0792C183F;
        Tue, 10 May 2022 06:15:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 725C2B81DAA;
        Tue, 10 May 2022 13:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E598FC385A6;
        Tue, 10 May 2022 13:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188507;
        bh=VtJerBDQCYbUCgpxXLdGU8t1nlWfii6eDosdmY9hF0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F0mAqS3Zfdi0NS+57tmp/Q0jyInaDB6RGYUuVqrp2LMIz1SvBIXQ8mMedhHM2LajV
         678Aw2yC1B/7sZlGdl1AegAO78Y9pz+NKDXYibSHHH39jcC77Yy4q2cDPXEygMJpZ2
         Acjk3Zn63yMEH0xemsXLKDFsrdMkpx68Bw6c/kRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 03/78] hamradio: remove needs_free_netdev to avoid UAF
Date:   Tue, 10 May 2022 15:06:49 +0200
Message-Id: <20220510130732.628205315@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.522479698@linuxfoundation.org>
References: <20220510130732.522479698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

commit 81b1d548d00bcd028303c4f3150fa753b9b8aa71 upstream.

The former patch "defer 6pack kfree after unregister_netdev" reorders
the kfree of two buffer after the unregister_netdev to prevent the race
condition. It also adds free_netdev() function in sixpack_close(), which
is a direct copy from the similar code in mkiss_close().

However, in sixpack driver, the flag needs_free_netdev is set to true in
sp_setup(), hence the unregister_netdev() will free the netdev
automatically. Therefore, as the sp is netdev_priv, use-after-free
occurs.

This patch removes the needs_free_netdev = true and just let the
free_netdev to finish this deallocation task.

Fixes: 0b9111922b1f ("hamradio: defer 6pack kfree after unregister_netdev")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Link: https://lore.kernel.org/r/20211111141402.7551-1-linma@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hamradio/6pack.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -311,7 +311,6 @@ static void sp_setup(struct net_device *
 {
 	/* Finish setting up the DEVICE info. */
 	dev->netdev_ops		= &sp_netdev_ops;
-	dev->needs_free_netdev	= true;
 	dev->mtu		= SIXP_MTU;
 	dev->hard_header_len	= AX25_MAX_HEADER_LEN;
 	dev->header_ops 	= &ax25_header_ops;


