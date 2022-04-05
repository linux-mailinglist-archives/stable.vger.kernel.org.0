Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F1A4F414D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383410AbiDEMZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238789AbiDEKyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:54:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CCFABF6F;
        Tue,  5 Apr 2022 03:28:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4654FB81C9B;
        Tue,  5 Apr 2022 10:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA52C385A2;
        Tue,  5 Apr 2022 10:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154501;
        bh=QY2EuOoLgTBXeW3ZsKJqoSutHxty6jHKXa2LviOib3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wQy5Q9lTsmoQWxfkk406Hmbf25tS9pLiUZtSqwre/Ujr9l1+XDNaYf+dsGsC0yz3/
         tHTZmTpwq6M2t0vKIc3E8JEfLsmQ8dtY9Cgcds/Pvs2ItoBl8uO9BYP0R9PJFVF4X3
         siW2gMVCQDykSpFqbkWsjnufCrqmmI1ZCaKgXP3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Derek Will <derekrobertwill@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 571/599] can: isotp: restore accidentally removed MSG_PEEK feature
Date:   Tue,  5 Apr 2022 09:34:25 +0200
Message-Id: <20220405070315.834665766@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit e382fea8ae54f5bb62869c6b69b33993d43adeca ]

In commit 42bf50a1795a ("can: isotp: support MSG_TRUNC flag when
reading from socket") a new check for recvmsg flags has been
introduced that only checked for the flags that are handled in
isotp_recvmsg() itself.

This accidentally removed the MSG_PEEK feature flag which is processed
later in the call chain in __skb_try_recv_from_queue().

Add MSG_PEEK to the set of valid flags to restore the feature.

Fixes: 42bf50a1795a ("can: isotp: support MSG_TRUNC flag when reading from socket")
Link: https://github.com/linux-can/can-utils/issues/347#issuecomment-1079554254
Link: https://lore.kernel.org/all/20220328113611.3691-1-socketcan@hartkopp.net
Reported-by: Derek Will <derekrobertwill@gmail.com>
Suggested-by: Derek Will <derekrobertwill@gmail.com>
Tested-by: Derek Will <derekrobertwill@gmail.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/isotp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 671c3673b7ea..63e6e8923200 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1007,7 +1007,7 @@ static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	int noblock = flags & MSG_DONTWAIT;
 	int ret = 0;
 
-	if (flags & ~(MSG_DONTWAIT | MSG_TRUNC))
+	if (flags & ~(MSG_DONTWAIT | MSG_TRUNC | MSG_PEEK))
 		return -EINVAL;
 
 	if (!so->bound)
-- 
2.34.1



