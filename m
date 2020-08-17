Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F0D24726F
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731700AbgHQSmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:42:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388105AbgHQP5N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:57:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C19A206FA;
        Mon, 17 Aug 2020 15:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679832;
        bh=WlvDQtskn6xwf+z4ILMfovV5b5YPGWtu3a6oWPARq3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Txm4JtHTyDoxkxct/nDlYKAxoSncqm5AX8rt1JkA/mwDA+k8DNAYGDSLw1ZMmfT4S
         OTmJW8nCfsrlo2+aCye7L42ap1tdUe+0I4TkcsP5mFwjfL7j5rOrFqFJcEPqps/hUC
         IVx3TJtci/JFp46wbppoI+MsX86t7K0QXrLAIE3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 322/393] net: Set fput_needed iff FDPUT_FPUT is set
Date:   Mon, 17 Aug 2020 17:16:12 +0200
Message-Id: <20200817143835.219920420@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit ce787a5a074a86f76f5d3fd804fa78e01bfb9e89 ]

We should fput() file iff FDPUT_FPUT is set. So we should set fput_needed
accordingly.

Fixes: 00e188ef6a7e ("sockfd_lookup_light(): switch to fdget^W^Waway from fget_light")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/socket.c
+++ b/net/socket.c
@@ -500,7 +500,7 @@ static struct socket *sockfd_lookup_ligh
 	if (f.file) {
 		sock = sock_from_file(f.file, err);
 		if (likely(sock)) {
-			*fput_needed = f.flags;
+			*fput_needed = f.flags & FDPUT_FPUT;
 			return sock;
 		}
 		fdput(f);


