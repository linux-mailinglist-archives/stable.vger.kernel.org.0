Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069024F3037
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiDEJgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235345AbiDEJBf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:01:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1C22181;
        Tue,  5 Apr 2022 01:53:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CDBFCCE1C6F;
        Tue,  5 Apr 2022 08:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83F1C385A3;
        Tue,  5 Apr 2022 08:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148824;
        bh=TIY/MaJG64dJFYhgSREZ7Io2V0kw+HnjbuZ5wtzkwkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H68CV2/eU3BXaXuNGZxhUdKMhG8Utn40AP9CBRUNnADy8ZJIc78033afQ43Z6pAto
         ULklZkweYILrPL/nldraPEifGpd5y8GBHxhLN+MYSlqP85Fp3UcVhflmxm1T3EIaZU
         M/BeQdgSPSR6f5fviCfBMoqRQiU/6off1aWQdlLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhiqian Guan <zhguan@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0494/1017] libbpf: Use dynamically allocated buffer when receiving netlink messages
Date:   Tue,  5 Apr 2022 09:23:27 +0200
Message-Id: <20220405070408.963184032@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 9c3de619e13ee6693ec5ac74f50b7aa89056a70e ]

When receiving netlink messages, libbpf was using a statically allocated
stack buffer of 4k bytes. This happened to work fine on systems with a 4k
page size, but on systems with larger page sizes it can lead to truncated
messages. The user-visible impact of this was that libbpf would insist no
XDP program was attached to some interfaces because that bit of the netlink
message got chopped off.

Fix this by switching to a dynamically allocated buffer; we borrow the
approach from iproute2 of using recvmsg() with MSG_PEEK|MSG_TRUNC to get
the actual size of the pending message before receiving it, adjusting the
buffer as necessary. While we're at it, also add retries on interrupted
system calls around the recvmsg() call.

v2:
  - Move peek logic to libbpf_netlink_recv(), don't double free on ENOMEM.

Fixes: 8bbb77b7c7a2 ("libbpf: Add various netlink helpers")
Reported-by: Zhiqian Guan <zhguan@redhat.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/bpf/20220211234819.612288-1-toke@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/netlink.c | 55 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 39f25e09b51e..69b353d55dbf 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -87,29 +87,75 @@ enum {
 	NL_DONE,
 };
 
+static int netlink_recvmsg(int sock, struct msghdr *mhdr, int flags)
+{
+	int len;
+
+	do {
+		len = recvmsg(sock, mhdr, flags);
+	} while (len < 0 && (errno == EINTR || errno == EAGAIN));
+
+	if (len < 0)
+		return -errno;
+	return len;
+}
+
+static int alloc_iov(struct iovec *iov, int len)
+{
+	void *nbuf;
+
+	nbuf = realloc(iov->iov_base, len);
+	if (!nbuf)
+		return -ENOMEM;
+
+	iov->iov_base = nbuf;
+	iov->iov_len = len;
+	return 0;
+}
+
 static int libbpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 			       __dump_nlmsg_t _fn, libbpf_dump_nlmsg_t fn,
 			       void *cookie)
 {
+	struct iovec iov = {};
+	struct msghdr mhdr = {
+		.msg_iov = &iov,
+		.msg_iovlen = 1,
+	};
 	bool multipart = true;
 	struct nlmsgerr *err;
 	struct nlmsghdr *nh;
-	char buf[4096];
 	int len, ret;
 
+	ret = alloc_iov(&iov, 4096);
+	if (ret)
+		goto done;
+
 	while (multipart) {
 start:
 		multipart = false;
-		len = recv(sock, buf, sizeof(buf), 0);
+		len = netlink_recvmsg(sock, &mhdr, MSG_PEEK | MSG_TRUNC);
+		if (len < 0) {
+			ret = len;
+			goto done;
+		}
+
+		if (len > iov.iov_len) {
+			ret = alloc_iov(&iov, len);
+			if (ret)
+				goto done;
+		}
+
+		len = netlink_recvmsg(sock, &mhdr, 0);
 		if (len < 0) {
-			ret = -errno;
+			ret = len;
 			goto done;
 		}
 
 		if (len == 0)
 			break;
 
-		for (nh = (struct nlmsghdr *)buf; NLMSG_OK(nh, len);
+		for (nh = (struct nlmsghdr *)iov.iov_base; NLMSG_OK(nh, len);
 		     nh = NLMSG_NEXT(nh, len)) {
 			if (nh->nlmsg_pid != nl_pid) {
 				ret = -LIBBPF_ERRNO__WRNGPID;
@@ -151,6 +197,7 @@ static int libbpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 	}
 	ret = 0;
 done:
+	free(iov.iov_base);
 	return ret;
 }
 
-- 
2.34.1



