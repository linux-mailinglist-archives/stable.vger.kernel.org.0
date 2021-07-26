Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD8D3D6167
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhGZPbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237865AbhGZP30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BFB661057;
        Mon, 26 Jul 2021 16:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315741;
        bh=20ZTeeWqgrfn6J4cK//oJ7/YD3FgITpyfR4ejpfZ5zU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EtM3YB6+rkUTttA6DGVfsTOVh9S/2oG/GkQbzi1EyPqblAGJcawcwPlSAKqXyevl4
         PNFVOzizDRbRKfip2qaQDTORXaHRIUjRtVnEeUcVwWQwvLDNc7Ga5MYfSE4X9pSgzw
         lXNKphqPipvi6vZL+H0s3OanlEBvX1LqGh+io080=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianguo Wu <wujianguo@chinatelecom.cn>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 031/223] mptcp: remove redundant req destruct in subflow_check_req()
Date:   Mon, 26 Jul 2021 17:37:03 +0200
Message-Id: <20210726153847.264818513@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

[ Upstream commit 030d37bd1cd2443a1f21db47eb301899bfa45a2a ]

In subflow_check_req(), if subflow sport is mismatch, will put msk,
destroy token, and destruct req, then return -EPERM, which can be
done by subflow_req_destructor() via:

  tcp_conn_request()
    |--__reqsk_free()
      |--subflow_req_destructor()

So we should remove these redundant code, otherwise will call
tcp_v4_reqsk_destructor() twice, and may double free
inet_rsk(req)->ireq_opt.

Fixes: 5bc56388c74f ("mptcp: add port number check for MP_JOIN")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/subflow.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index cbc452d0901e..5493c851ca6c 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -212,11 +212,6 @@ again:
 				 ntohs(inet_sk(sk_listener)->inet_sport),
 				 ntohs(inet_sk((struct sock *)subflow_req->msk)->inet_sport));
 			if (!mptcp_pm_sport_in_anno_list(subflow_req->msk, sk_listener)) {
-				sock_put((struct sock *)subflow_req->msk);
-				mptcp_token_destroy_request(req);
-				tcp_request_sock_ops.destructor(req);
-				subflow_req->msk = NULL;
-				subflow_req->mp_join = 0;
 				SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_MISMATCHPORTSYNRX);
 				return -EPERM;
 			}
-- 
2.30.2



