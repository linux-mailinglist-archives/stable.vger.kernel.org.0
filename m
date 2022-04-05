Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1FC74F2B01
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236668AbiDEJbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235847AbiDEIQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:16:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF2857B1B;
        Tue,  5 Apr 2022 01:03:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 879EF616DF;
        Tue,  5 Apr 2022 08:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B56C385A1;
        Tue,  5 Apr 2022 08:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145820;
        bh=TIY/MaJG64dJFYhgSREZ7Io2V0kw+HnjbuZ5wtzkwkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FC2X+4BF7GNIoizLoL8VdSTYIWHJg2TYlJ+tASeeW0nBn5JxR7B/22FnFUlIpfNbi
         PAsbDwa3d7rMpcS1D4bd8NmE/jAnCHQzfxIOjWOwbirtgZMlu57b7NO/JqGUM4TGQ5
         CALEwA7sBgKh5Hj9Yf91a7WDyh8H26qYU5XobsyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhiqian Guan <zhguan@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0540/1126] libbpf: Use dynamically allocated buffer when receiving netlink messages
Date:   Tue,  5 Apr 2022 09:21:27 +0200
Message-Id: <20220405070423.482079955@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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



