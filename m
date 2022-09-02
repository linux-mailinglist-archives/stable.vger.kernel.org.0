Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A53685AB039
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237763AbiIBMvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237785AbiIBMun (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:50:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16E2F72EA;
        Fri,  2 Sep 2022 05:36:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05F2CB82A8B;
        Fri,  2 Sep 2022 12:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50201C433C1;
        Fri,  2 Sep 2022 12:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121486;
        bh=BVmSj4j2lKWMzSNLk4z5AdM2bjhzmLxnEzZSY88b4KU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pljeTm/vK7m0na7EMDzPKf70UEtlK562dqIpGPRl98NV14rKUZ8mbEIJ86z1CW98J
         okbmWAwOFCsVA+JQ8Plu1gSVU43Ui0qsZG5L7ytvKMJ7unIEBMWJ3WWHo5p9fkvEdo
         nf0w9DLSRwoBuwPZAeEgrbk6gX8w3pOfM7E1y+N4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 23/56] net: Fix a data-race around sysctl_net_busy_poll.
Date:   Fri,  2 Sep 2022 14:18:43 +0200
Message-Id: <20220902121400.993054915@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121400.219861128@linuxfoundation.org>
References: <20220902121400.219861128@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit c42b7cddea47503411bfb5f2f93a4154aaffa2d9 ]

While reading sysctl_net_busy_poll, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 060212928670 ("net: add low latency socket poll")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/busy_poll.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index c76a5e9894dac..8f42f6f3af86f 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -43,7 +43,7 @@ extern unsigned int sysctl_net_busy_poll __read_mostly;
 
 static inline bool net_busy_loop_on(void)
 {
-	return sysctl_net_busy_poll;
+	return READ_ONCE(sysctl_net_busy_poll);
 }
 
 static inline bool sk_can_busy_loop(const struct sock *sk)
-- 
2.35.1



