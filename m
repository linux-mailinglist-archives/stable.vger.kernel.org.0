Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621786DD97F
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 13:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjDKLgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 07:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDKLgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 07:36:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF358E60
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 04:36:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B4DC61DE7
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 11:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5919FC433D2;
        Tue, 11 Apr 2023 11:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681213003;
        bh=PXJnEXW+Tr+APodSo1V95IK9yLZbro39VjWd9D15ahY=;
        h=Subject:To:Cc:From:Date:From;
        b=mGITB2QffjLNUIf2yg0Ms2XLOZXMEQB8tebhBGT/BpbQ3gtmYcxZ+JvW5A3PxSz6S
         LyMd44Kp/YZoskRH/WX7gi+fLCKd3NptZ6ZMFPW326ZgnbHczOFOr9NWDyVcXxB1yX
         Yd/h9TMqv0SVA3dSJ7pUBf9bcXAtZv4MZm5TGqA8=
Subject: FAILED: patch "[PATCH] can: isotp: isotp_recvmsg(): use sock_recv_cmsgs() to get" failed to apply to 5.15-stable tree
To:     socketcan@hartkopp.net, mkl@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 Apr 2023 13:36:08 +0200
Message-ID: <2023041108-careless-semifinal-6234@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 0145462fc802cd447ef5d029758043c7f15b4b1e
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041108-careless-semifinal-6234@gregkh' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

0145462fc802 ("can: isotp: isotp_recvmsg(): use sock_recv_cmsgs() to get SOCK_RXQ_OVFL infos")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0145462fc802cd447ef5d029758043c7f15b4b1e Mon Sep 17 00:00:00 2001
From: Oliver Hartkopp <socketcan@hartkopp.net>
Date: Thu, 30 Mar 2023 19:02:48 +0200
Subject: [PATCH] can: isotp: isotp_recvmsg(): use sock_recv_cmsgs() to get
 SOCK_RXQ_OVFL infos

isotp.c was still using sock_recv_timestamp() which does not provide
control messages to detect dropped PDUs in the receive path.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20230330170248.62342-1-socketcan@hartkopp.net
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 9bc344851704..47c2ebad10ed 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1120,7 +1120,7 @@ static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	if (ret < 0)
 		goto out_err;
 
-	sock_recv_timestamp(msg, sk, skb);
+	sock_recv_cmsgs(msg, sk, skb);
 
 	if (msg->msg_name) {
 		__sockaddr_check_size(ISOTP_MIN_NAMELEN);

