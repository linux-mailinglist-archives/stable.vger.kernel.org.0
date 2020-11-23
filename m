Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9367F2C0AFF
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731419AbgKWMen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:34:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731413AbgKWMek (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:34:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 165C120857;
        Mon, 23 Nov 2020 12:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134880;
        bh=0QUuYwQkWoMKYnKni8fZwZNkzY8pchoHHX125HGgVnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pyuGSGxoqHPG2y2cP22ZMPNuCsw3a2QAPuFDrANPfV7iGYCU4QpbGsZNjt3DmPO5A
         IdDe2A3DABWuxidADFZ6cYzyXTs2hYkkzOP5kGCkk5BJD98vUlWkB2TAIRw1Ir/Sr0
         nrA4QzhomDavUoHVZA3decJQsDq7gKtLDG4DcQRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 006/158] inet_diag: Fix error path to cancel the meseage in inet_req_diag_fill()
Date:   Mon, 23 Nov 2020 13:20:34 +0100
Message-Id: <20201123121820.251426365@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit e33de7c5317e2827b2ba6fd120a505e9eb727b05 ]

nlmsg_cancel() needs to be called in the error path of
inet_req_diag_fill to cancel the message.

Fixes: d545caca827b ("net: inet: diag: expose the socket mark to privileged processes.")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Link: https://lore.kernel.org/r/20201116082018.16496-1-wanghai38@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_diag.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -388,8 +388,10 @@ static int inet_req_diag_fill(struct soc
 	r->idiag_inode	= 0;
 
 	if (net_admin && nla_put_u32(skb, INET_DIAG_MARK,
-				     inet_rsk(reqsk)->ir_mark))
+				     inet_rsk(reqsk)->ir_mark)) {
+		nlmsg_cancel(skb, nlh);
 		return -EMSGSIZE;
+	}
 
 	nlmsg_end(skb, nlh);
 	return 0;


