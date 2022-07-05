Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B056C566C5E
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbiGEMO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234056AbiGEMNe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:13:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7D81AD91;
        Tue,  5 Jul 2022 05:11:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72A2561988;
        Tue,  5 Jul 2022 12:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40798C341C7;
        Tue,  5 Jul 2022 12:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023063;
        bh=YiCygZYgHmwf26uNvEy1H53XouYE1er55VWdDFhki7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2DVuJ1NoLnMvEXL7eSgK1iOuNtvM1Qi4AtkoKNLg6DRtj89SzjctXrdE2/5ECLfE
         uJxAMOa0w8frnYu+LI3vdmQBltNxs+k8D24wYm3Pim/oyX9h/PRX1840MYkoE0Vr6O
         iRHgjiNW/bufACPxPj0EtT+RXGcMjZ4o1VVvPdDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petar Penkov <ppenkov@aviatrix.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 24/98] net: tun: stop NAPI when detaching queues
Date:   Tue,  5 Jul 2022 13:57:42 +0200
Message-Id: <20220705115618.278365758@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
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

commit a8fc8cb5692aebb9c6f7afd4265366d25dcd1d01 upstream.

While looking at a syzbot report I noticed the NAPI only gets
disabled before it's deleted. I think that user can detach
the queue before destroying the device and the NAPI will never
be stopped.

Fixes: 943170998b20 ("tun: enable NAPI for TUN/TAP driver")
Acked-by: Petar Penkov <ppenkov@aviatrix.com>
Link: https://lore.kernel.org/r/20220623042105.2274812-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -274,6 +274,12 @@ static void tun_napi_init(struct tun_str
 	}
 }
 
+static void tun_napi_enable(struct tun_file *tfile)
+{
+	if (tfile->napi_enabled)
+		napi_enable(&tfile->napi);
+}
+
 static void tun_napi_disable(struct tun_file *tfile)
 {
 	if (tfile->napi_enabled)
@@ -654,8 +660,10 @@ static void __tun_detach(struct tun_file
 		if (clean) {
 			RCU_INIT_POINTER(tfile->tun, NULL);
 			sock_put(&tfile->sk);
-		} else
+		} else {
 			tun_disable_queue(tun, tfile);
+			tun_napi_disable(tfile);
+		}
 
 		synchronize_net();
 		tun_flow_delete_by_queue(tun, tun->numqueues + 1);
@@ -809,6 +817,7 @@ static int tun_attach(struct tun_struct
 
 	if (tfile->detached) {
 		tun_enable_queue(tfile);
+		tun_napi_enable(tfile);
 	} else {
 		sock_hold(&tfile->sk);
 		tun_napi_init(tun, tfile, napi, napi_frags);


