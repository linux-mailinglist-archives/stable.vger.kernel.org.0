Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941643961E3
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbhEaOrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:47:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232009AbhEaOpj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:45:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A252C61C83;
        Mon, 31 May 2021 13:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469331;
        bh=kezQKjHOc9G5y7JOeaR1tVS84j6O+vmfVzO6uJyggVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HqZszcyLDi+gboX1du93WZiDCxZq34R/qh8YbZi1adpmju8MgGuG2oGQXA0W25xbQ
         cIJYmYt7J4v8YckCFY7dKYtPlHCGg5DpNijplOHfP4EEjk0NSzXyech783PIiYGXXj
         UJszL+G2+Tgwutx7WGkYW+E4+XcRCGB9tLgOfb6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 157/296] mptcp: avoid error message on infinite mapping
Date:   Mon, 31 May 2021 15:13:32 +0200
Message-Id: <20210531130709.141161639@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit 3ed0a585bfadb6bd7080f11184adbc9edcce7dbc upstream.

Another left-over. Avoid flooding dmesg with useless text,
we already have a MIB for that event.

Fixes: 648ef4b88673 ("mptcp: Implement MPTCP receive path")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -839,7 +839,6 @@ static enum mapping_status get_mapping_s
 
 	data_len = mpext->data_len;
 	if (data_len == 0) {
-		pr_err("Infinite mapping not handled");
 		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_INFINITEMAPRX);
 		return MAPPING_INVALID;
 	}


