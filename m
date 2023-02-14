Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78B56968BF
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 17:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjBNQFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 11:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjBNQFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 11:05:33 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B6592
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 08:05:32 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id az4-20020a05600c600400b003dff767a1f1so11992494wmb.2
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 08:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ztgPqq49kics+10J7Iq/tHqvzOz/l1zYeaPIluiheAY=;
        b=IJXRrvx6RAgtDCm4pUv3gwz+e7E1ShR7YXtuZohCeSte7a+RNffjhlda1Idd/9afmM
         PN/KRlnOci3jo/UqZ/76xNWc9OK04JeRlb0PwqPBxKbVD0QbuRDNeGKB8I4YkdjBguZp
         I50i3OgILvkaarIVom8TxUZlVZRv0ePNzfuvTUvIkQ5U/2e5jxMyjPacO+vN4b32Uy7t
         zD+SuQUwnK6pKZH/dkmI9ysZQUaHD67RzYj1fBJ+aFKq2SUBaa8+lfjRS7mEUERUrVFm
         rxZcBAm1VZtSFWQnWmxcxfXp3uu/ROiIMbSYGa00B0BdSv1qoZLmiEUcVGYRPg8Ijmgi
         Salw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ztgPqq49kics+10J7Iq/tHqvzOz/l1zYeaPIluiheAY=;
        b=E0HjjZzphv3WHNER9w7CRPzZ8wrVuwgibdsqLP1176l4o0SKlxMnoZOBU9npdbarF1
         3tfIorUNWIsKRw/o5tUhEZLYIXHgC9NsXTQeGYOWQ/TjiBixovgM7le2nomah6LKRpEl
         CxkQlZexxwlBHryM1EtKboHYgcRczTvVWuaEI9MLlxwLUyUVkr5M4V+JprA/b+gyikM9
         xG6C4/ly4kt0Y79uuc+zSO8XdibKQLzKMKYjn1UGhGyreosbYJGplBssQ9RSmunjEXvc
         pIZMrJt0HnDVl1H4I3Y5vozOXX2WDUnt42p9J9eP8iOzE15BASFLYrQss1wJFa2b0s1g
         ZPNA==
X-Gm-Message-State: AO0yUKW0n9NTJ4LH5fVbR06Rg3a8WSxCu8wHKRQ3DKhg37txdrB+WVDx
        CV4kXK7wCUWZHhd6j91Cz4IdUA==
X-Google-Smtp-Source: AK7set97SBchwfAt2mQ5Pa0Jk4z/FEUQ0ddnWcg3TRLhAKfq3e0XB0T4LNgs8eJv7YhVavl5KF1Olw==
X-Received: by 2002:a05:600c:a694:b0:3e0:1ab:cf2a with SMTP id ip20-20020a05600ca69400b003e001abcf2amr2518110wmb.39.1676390730708;
        Tue, 14 Feb 2023 08:05:30 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id bg30-20020a05600c3c9e00b003db012d49b7sm4435537wmb.2.2023.02.14.08.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 08:05:30 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Tue, 14 Feb 2023 17:05:09 +0100
Subject: [PATCH 6.1 3/4] mptcp: fix locking for in-kernel listener creation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230214-upstream-stable-20230214-linux-6-1-12-rc1-mptcp-fixes-v1-3-02f36fa30f8c@tessares.net>
References: <20230214-upstream-stable-20230214-linux-6-1-12-rc1-mptcp-fixes-v1-0-02f36fa30f8c@tessares.net>
In-Reply-To: <20230214-upstream-stable-20230214-linux-6-1-12-rc1-mptcp-fixes-v1-0-02f36fa30f8c@tessares.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, stable@vger.kernel.org,
        mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2466;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=W9RojX+R6gjvnbN8dvG5/529W0G43bBErUBVhqiK4cM=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj67FH3r03V7VmECAPwCkQ2W6wbeNZLwoDi1xCh
 jUSL8IA9BCJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY+uxRwAKCRD2t4JPQmmg
 cw6yEAC7vBfoU0ermaqP/7ijCgfqohK8967sRqGJzLMztYBDS78Ivp+sP9vWHCfDV3HcY2zwotL
 iOtdr9yVsDS/eBnqzUDLAkZm+lj65AjybktByWHnl1wFzevz7njKh9Lv1jb7zvZ6ZX5E16zQHX2
 +gxtZBqAdeAZueVqzTKrP6vcbXflFVp4vyN5ox0zsFMwFNJXyx1Q/AcjkmOlf+UKx+z/O/cjSvW
 9xK8JYLmh23rOxT4rXfzLh6gC+ImEfpkWFm9Xv6/z7d0aDuEN6PM8WfR15bQgsLiLm78qv2VP/l
 fYc0UjNRvCeaaYAkc09xNh9ZT3OIQhjPsh/vs44LiSc53Ti3iT4sb/Sd9K03rPaN4QUfItsa8rD
 BH0WJTd9pmyu83liqjhQqkMJTDYjnDFNTnpGqa9ieLjwaQSmTPjatWcrw+Ga107WzJIGvOOLxNj
 uU2KzcMdnkQZmWQX8FMeZAP2p713ZW9D7u0UZUAIa6Cm9blC3UzPGfkZzWUmGxnHJTL0YnfNSIi
 +tPiie+F+7Fde4zaQd/ETC/kgAyZsafbImRfFLkreMeNS9GJGoXvMnxoWLi+pVb6OmAcuOMXyZ8
 sA4zqEkiRFzWT/hmBGBGkDQ8ZmqcAH0mWbpxT9q6CP2ebfVTpaUS4SIfDQJ0N8YaELJhbpbFp30
 Y81+FfXvGYRC5lQ==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit ad2171009d968104ccda9dc517f5a3ba891515db ]

For consistency, in mptcp_pm_nl_create_listen_socket(), we need to
call the __mptcp_nmpc_socket() under the msk socket lock.

Note that as a side effect, mptcp_subflow_create_socket() needs a
'nested' lockdep annotation, as it will acquire the subflow (kernel)
socket lock under the in-kernel listener msk socket lock.

The current lack of locking is almost harmless, because the relevant
socket is not exposed to the user space, but in future we will add
more complexity to the mentioned helper, let's play safe.

Fixes: 1729cf186d8a ("mptcp: create the listening socket for new port")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/pm_netlink.c | 10 ++++++----
 net/mptcp/subflow.c    |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 9813ed0fde9b..15253afc3fff 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -992,8 +992,8 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 {
 	int addrlen = sizeof(struct sockaddr_in);
 	struct sockaddr_storage addr;
-	struct mptcp_sock *msk;
 	struct socket *ssock;
+	struct sock *newsk;
 	int backlog = 1024;
 	int err;
 
@@ -1002,13 +1002,15 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	if (err)
 		return err;
 
-	msk = mptcp_sk(entry->lsk->sk);
-	if (!msk) {
+	newsk = entry->lsk->sk;
+	if (!newsk) {
 		err = -EINVAL;
 		goto out;
 	}
 
-	ssock = __mptcp_nmpc_socket(msk);
+	lock_sock(newsk);
+	ssock = __mptcp_nmpc_socket(mptcp_sk(newsk));
+	release_sock(newsk);
 	if (!ssock) {
 		err = -EINVAL;
 		goto out;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 929b0ee8b3d5..c4971bc42f60 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1631,7 +1631,7 @@ int mptcp_subflow_create_socket(struct sock *sk, unsigned short family,
 	if (err)
 		return err;
 
-	lock_sock(sf->sk);
+	lock_sock_nested(sf->sk, SINGLE_DEPTH_NESTING);
 
 	/* the newly created socket has to be in the same cgroup as its parent */
 	mptcp_attach_cgroup(sk, sf->sk);

-- 
2.38.1

