Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F92566D3B
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236718AbiGEMVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237651AbiGEMTd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:19:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E800D18E00;
        Tue,  5 Jul 2022 05:15:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96184B817AC;
        Tue,  5 Jul 2022 12:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D35C341C7;
        Tue,  5 Jul 2022 12:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023349;
        bh=ZVMKvq6nEv0PjRmO1sVB9snpTOPkH4ykEw7NIvNnQzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aeim7BJKDitsQF9/mOkFe4aOIv2wNz4Zy6MaZ2DBe++EqKNuhYcV9fxHOgM9QckH9
         iLLol/y+DjpYMIPUobNqLuqXcEKnRagU2y7I2DIGMBM5/juofIWalSz2qs75sA7p4Q
         f53ljNfSeuXVybQnv+FPegnuWpp0Lrt8cwnNvUP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b75c138e9286ac742647@syzkaller.appspotmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.18 028/102] net: tun: unlink NAPI from device on destruction
Date:   Tue,  5 Jul 2022 13:57:54 +0200
Message-Id: <20220705115619.215623310@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

commit 3b9bc84d311104906d2b4995a9a02d7b7ddab2db upstream.

Syzbot found a race between tun file and device destruction.
NAPIs live in struct tun_file which can get destroyed before
the netdev so we have to del them explicitly. The current
code is missing deleting the NAPI if the queue was detached
first.

Fixes: 943170998b20 ("tun: enable NAPI for TUN/TAP driver")
Reported-by: syzbot+b75c138e9286ac742647@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20220623042039.2274708-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -728,6 +728,7 @@ static void tun_detach_all(struct net_de
 		sock_put(&tfile->sk);
 	}
 	list_for_each_entry_safe(tfile, tmp, &tun->disabled, next) {
+		tun_napi_del(tfile);
 		tun_enable_queue(tfile);
 		tun_queue_purge(tfile);
 		xdp_rxq_info_unreg(&tfile->xdp_rxq);


