Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418C56968BD
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 17:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjBNQFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 11:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjBNQFb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 11:05:31 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADDCE3
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 08:05:30 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id g6-20020a05600c310600b003e1f6dff952so1384129wmo.1
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 08:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ly6DfkEKz/G+rxKKbWncYYr46bc2Li2tCDDJdiz0T8M=;
        b=ag05wB9PpHBHmboVYhZi7jl9gaupeMoVum/iIEd4UdEfztJtdlqtoqaxK8cG0vAqpa
         HVxiTBnhAm8HYDuRjIQn/h7S2LtHv9sRBA9JaSMxs1bgacFBXFIlNNIgPb6jGqzIGulf
         KUWRtn8mCG3blgQmHPsqTlgJZy5JQ4GN+cIkstq1VmD+ULkVnxxVk83M1+PyKLAyvb0v
         lXweCzJHI89+kBcTlSbe0GnZYeVfJZNjyrlta/XWFbFGKbhTOQbTGQAjDAXW1FaAH4a3
         Etvf1Mpp8cZMxqVzVoSMJs9RHKkTQh2IKypPgjHKx7E+gTTFI2+1NPt8CnaWNz9b1ZIE
         GTbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ly6DfkEKz/G+rxKKbWncYYr46bc2Li2tCDDJdiz0T8M=;
        b=nt8KX5Fvj8828zuKn+87nk6UE0Lcvj9zJz927WQj1+JPuUfoRyAh1OMsrrU8g7bAOi
         Wx00Gze5RnL3SUTihBzEertAYOIdtPwo97bpnmSgIjakTWSRkh0awJkuDA8WaSs0Zj62
         tHI8MYzHlWakiVDzUctUvxXFfTqvdb8nD/imzNWsexL0Z42cP59l0bKZyzU+Mr9YcMCo
         PgE7hNKfOvQgOkllXmfh6YZKnyD5kJzGgrEODqd9i2HZhgk/q8lWEvdlzgAueUtZv5X0
         0M3RJFrK6m2wnDM57XEoxor6KNX3YWWD6NyvV1+jnEPy9DVd96HlNHTXmgdq/qpxo6Sl
         0dpg==
X-Gm-Message-State: AO0yUKVaWp/qP4XKvu0WfQEXWJuBAU7/S/9Zo3vXC4hGuKtvNSP+oFkp
        1GyI3f8ZfnU7tGc9pQIovdLh4w==
X-Google-Smtp-Source: AK7set9dsNaaz8mZMAVPHChTu9UZgZGDw+xvILUMyZHZQ/STzLl27yRjoWAXXjB7Fo2PehqG7Lj3xg==
X-Received: by 2002:a05:600c:4ab0:b0:3de:d9f:3025 with SMTP id b48-20020a05600c4ab000b003de0d9f3025mr2313297wmp.0.1676390728817;
        Tue, 14 Feb 2023 08:05:28 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id bg30-20020a05600c3c9e00b003db012d49b7sm4435537wmb.2.2023.02.14.08.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 08:05:28 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Tue, 14 Feb 2023 17:05:07 +0100
Subject: [PATCH 6.1 1/4] mptcp: sockopt: make 'tcp_fastopen_connect'
 generic
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230214-upstream-stable-20230214-linux-6-1-12-rc1-mptcp-fixes-v1-1-02f36fa30f8c@tessares.net>
References: <20230214-upstream-stable-20230214-linux-6-1-12-rc1-mptcp-fixes-v1-0-02f36fa30f8c@tessares.net>
In-Reply-To: <20230214-upstream-stable-20230214-linux-6-1-12-rc1-mptcp-fixes-v1-0-02f36fa30f8c@tessares.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, stable@vger.kernel.org,
        mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2300;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=XgzkoybHN6ABv/TX942NWNid6qtwPZKWNVbrOVabEK8=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj67FGqQtd+YwgDINrS+SBqFBoIc+L3o3Bk6Jmi
 IEkgWfMNwmJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY+uxRgAKCRD2t4JPQmmg
 c7GtD/4un9n6YptAU7aNzIVTvTx9aLILOaddL0mVlwN6l+YChgp1geqYAsP6sfdxokobJZAouON
 qs+fzhGSJaQIl0ViU2OA+fzrNvLCLwvu/ZwNU0NbrEsSu5YmvFx1tR3VvjbvnPTf5CsNiuUSBt3
 fyleKiM9piQXwWBtRSnbhA7HHzlgKyVrl2T2a3a65CmfRYI6fX0WE4nrsIb7yZARdbxWAiNOonl
 op78YmaN1eiHuLziJxyw8tURkwM7X9AeftMw+yGJLMY1/+wtu1SVcn6BRKh2IyCS8/Ui6jiGs51
 OIJiT/vacHr4PHi1bsaBTiqt+Tb5ba3UCRy1JPwmzyFfFcTpoZ7LS5+5uUIErp0tz69IinxNg0r
 ryU6XsZ3OoMRYopVV7tXtQOmc06Ji6MYO68HPjGGBoFX0rR58JVLG/KO06nUSRe9XxF8f0PKPtt
 lQTd5d8Q+tFBFpZFx0x8Cpx63jsb3rmQNK5TryBJgAcIhhjDaoorYp6B4J6p1dP1UpENvdTky+A
 tK5ovhb92b3Kau0ejsleEdUZITndbT17y+2BXgM0erVKSz0now8CaxrRhQZlyhT8lDiyP6t77ss
 Rqf53ATYYx0Y3vzcpEusTiiui1zmPjUUrjgW5CGuOYOpzR9cxgfI/82LC3rO1yoGcVHv1psgEyC
 9Mhnev1123FwSYw==
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

[ Upstream commit d3d429047cc66ff49780c93e4fccd9527723d385 ]

There are other socket options that need to act only on the first
subflow, e.g. all TCP_FASTOPEN* socket options.

This is similar to the getsockopt version.

In the next commit, this new mptcp_setsockopt_first_sf_only() helper is
used by other another option.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 21e43569685d ("mptcp: fix locking for setsockopt corner-case")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/sockopt.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index c7cb68c725b2..8d3b09d75c3a 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -769,17 +769,17 @@ static int mptcp_setsockopt_sol_tcp_defer(struct mptcp_sock *msk, sockptr_t optv
 	return tcp_setsockopt(listener->sk, SOL_TCP, TCP_DEFER_ACCEPT, optval, optlen);
 }
 
-static int mptcp_setsockopt_sol_tcp_fastopen_connect(struct mptcp_sock *msk, sockptr_t optval,
-						     unsigned int optlen)
+static int mptcp_setsockopt_first_sf_only(struct mptcp_sock *msk, int level, int optname,
+					  sockptr_t optval, unsigned int optlen)
 {
 	struct socket *sock;
 
-	/* Limit to first subflow */
+	/* Limit to first subflow, before the connection establishment */
 	sock = __mptcp_nmpc_socket(msk);
 	if (!sock)
 		return -EINVAL;
 
-	return tcp_setsockopt(sock->sk, SOL_TCP, TCP_FASTOPEN_CONNECT, optval, optlen);
+	return tcp_setsockopt(sock->sk, level, optname, optval, optlen);
 }
 
 static int mptcp_setsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
@@ -811,7 +811,8 @@ static int mptcp_setsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 	case TCP_DEFER_ACCEPT:
 		return mptcp_setsockopt_sol_tcp_defer(msk, optval, optlen);
 	case TCP_FASTOPEN_CONNECT:
-		return mptcp_setsockopt_sol_tcp_fastopen_connect(msk, optval, optlen);
+		return mptcp_setsockopt_first_sf_only(msk, SOL_TCP, optname,
+						      optval, optlen);
 	}
 
 	return -EOPNOTSUPP;

-- 
2.38.1

