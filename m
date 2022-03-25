Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B584E4E769E
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347622AbiCYPQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376670AbiCYPNP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:13:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372C8ADD47;
        Fri, 25 Mar 2022 08:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F0C9B82900;
        Fri, 25 Mar 2022 15:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA72C340F3;
        Fri, 25 Mar 2022 15:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221007;
        bh=KNwn+QBHBRBFD2JCHuCLDSoj/tzf/rXmQRsErk4L1h8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DAsetNK+uDX1m2AxvKtuG5c+Z92jPeZXbgITnqGZNRvYIRRsT3SYVc1Od7AmpSFQ7
         FY04Au3o00CyKIuMoYu4whe1jTEuSp7xP5hfGxSCiEqQvi0/e3r5JaialMOS0r9YuD
         vCqHk6Gtb1JFS2I7DzQ6iJez5+m0t6/nEKKgqrXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        =?UTF-8?q?=E8=B5=B5=E5=AD=90=E8=BD=A9?= <beraphin@gmail.com>,
        Stoyan Manolov <smanolov@suse.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 09/38] llc: fix netdevice reference leaks in llc_ui_bind()
Date:   Fri, 25 Mar 2022 16:04:53 +0100
Message-Id: <20220325150420.029041400@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150419.757836392@linuxfoundation.org>
References: <20220325150419.757836392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 764f4eb6846f5475f1244767d24d25dd86528a4a upstream.

Whenever llc_ui_bind() and/or llc_ui_autobind()
took a reference on a netdevice but subsequently fail,
they must properly release their reference
or risk the infamous message from unregister_netdevice()
at device dismantle.

unregister_netdevice: waiting for eth0 to become free. Usage count = 3

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: 赵子轩 <beraphin@gmail.com>
Reported-by: Stoyan Manolov <smanolov@suse.de>
Link: https://lore.kernel.org/r/20220323004147.1990845-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/llc/af_llc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -311,6 +311,10 @@ static int llc_ui_autobind(struct socket
 	sock_reset_flag(sk, SOCK_ZAPPED);
 	rc = 0;
 out:
+	if (rc) {
+		dev_put(llc->dev);
+		llc->dev = NULL;
+	}
 	return rc;
 }
 
@@ -409,6 +413,10 @@ static int llc_ui_bind(struct socket *so
 out_put:
 	llc_sap_put(sap);
 out:
+	if (rc) {
+		dev_put(llc->dev);
+		llc->dev = NULL;
+	}
 	release_sock(sk);
 	return rc;
 }


