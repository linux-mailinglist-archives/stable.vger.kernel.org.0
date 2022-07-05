Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7069566BB4
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbiGEMJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234626AbiGEMHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:07:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B79192BF;
        Tue,  5 Jul 2022 05:06:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15D05B817CC;
        Tue,  5 Jul 2022 12:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575B5C341CB;
        Tue,  5 Jul 2022 12:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022805;
        bh=E5YABQN7CX2xcNUWZOZH99E/RjMbQ0oA1Q2OAU7l6Yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RLz7FoVXdSx97ET/zFF6zrEYMNyzadejNNk2aB/4/FbZcbMz3uBGvQeunSCjsfhtN
         oPbPWs1QBSS+pmf8n2u4Esc7TA2SX9bNtKQEGXPB3pZofzpDlGKs7wWaOCxRRtQWR9
         Y/5fXxAX44Z28tYK2hV+gr9PM6VmiTJupKs7ROt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b75c138e9286ac742647@syzkaller.appspotmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 17/84] net: tun: unlink NAPI from device on destruction
Date:   Tue,  5 Jul 2022 13:57:40 +0200
Message-Id: <20220705115615.829569288@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
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
@@ -733,6 +733,7 @@ static void tun_detach_all(struct net_de
 		sock_put(&tfile->sk);
 	}
 	list_for_each_entry_safe(tfile, tmp, &tun->disabled, next) {
+		tun_napi_del(tfile);
 		tun_enable_queue(tfile);
 		tun_queue_purge(tfile);
 		xdp_rxq_info_unreg(&tfile->xdp_rxq);


