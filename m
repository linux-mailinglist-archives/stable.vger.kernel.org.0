Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E876AF3CC
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjCGTJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjCGTJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:09:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47100B3285
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:54:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA770B819D6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033A2C433A0;
        Tue,  7 Mar 2023 18:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215224;
        bh=s45eB0R8juTjlWTD+m+madG1BptmyRT70x9JDqDwhck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=znt60Lyinku90X5tDZSfOZSN+QGs4GWznUD4Zecprs12pI4Ztj3SFDBJaIdDLSMFi
         BAZQpC27p1bOQ3xSiTUoFSswkfAHjJqXoKC9wcY1kahUzvk31BgkWkp6QdaXWwzPw1
         a8DCew0FAZTcKGNcL8BuG5W18/P3gIXfSiiaOwEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 159/567] selftests/net: Interpret UDP_GRO cmsg data as an int value
Date:   Tue,  7 Mar 2023 17:58:15 +0100
Message-Id: <20230307165912.816137837@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit 436864095a95fcc611c20c44a111985fa9848730 ]

Data passed to user-space with a (SOL_UDP, UDP_GRO) cmsg carries an
int (see udp_cmsg_recv), not a u16 value, as strace confirms:

  recvmsg(8, {msg_name=...,
              msg_iov=[{iov_base="\0\0..."..., iov_len=96000}],
              msg_iovlen=1,
              msg_control=[{cmsg_len=20,         <-- sizeof(cmsghdr) + 4
                            cmsg_level=SOL_UDP,
                            cmsg_type=0x68}],    <-- UDP_GRO
                            msg_controllen=24,
                            msg_flags=0}, 0) = 11200

Interpreting the data as an u16 value won't work on big-endian platforms.
Since it is too late to back out of this API decision [1], fix the test.

[1]: https://lore.kernel.org/netdev/20230131174601.203127-1-jakub@cloudflare.com/

Fixes: 3327a9c46352 ("selftests: add functionals test for UDP GRO")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/udpgso_bench_rx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
index 4058c7451e70d..f35a924d4a303 100644
--- a/tools/testing/selftests/net/udpgso_bench_rx.c
+++ b/tools/testing/selftests/net/udpgso_bench_rx.c
@@ -214,11 +214,10 @@ static void do_verify_udp(const char *data, int len)
 
 static int recv_msg(int fd, char *buf, int len, int *gso_size)
 {
-	char control[CMSG_SPACE(sizeof(uint16_t))] = {0};
+	char control[CMSG_SPACE(sizeof(int))] = {0};
 	struct msghdr msg = {0};
 	struct iovec iov = {0};
 	struct cmsghdr *cmsg;
-	uint16_t *gsosizeptr;
 	int ret;
 
 	iov.iov_base = buf;
@@ -237,8 +236,7 @@ static int recv_msg(int fd, char *buf, int len, int *gso_size)
 		     cmsg = CMSG_NXTHDR(&msg, cmsg)) {
 			if (cmsg->cmsg_level == SOL_UDP
 			    && cmsg->cmsg_type == UDP_GRO) {
-				gsosizeptr = (uint16_t *) CMSG_DATA(cmsg);
-				*gso_size = *gsosizeptr;
+				*gso_size = *(int *)CMSG_DATA(cmsg);
 				break;
 			}
 		}
-- 
2.39.2



