Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9178A252DC2
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 14:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbgHZMGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 08:06:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729549AbgHZMDo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 08:03:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A326A2087D;
        Wed, 26 Aug 2020 12:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598443424;
        bh=GhJDUyqvGdl3u8cr2e13f+3GHvyblBYsXLgfMHNqZCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEPSaFPkv/oIO6u/RWKZZJBYXTOCVhL30lBr08c0r+LuW4os3KHVl1invs/iHweOs
         TWIQwiPOOEf89Nmu06sJ1lBt152otm3rRqTqm5tT1Y6BStj1g7pbRp7eG18dvCmdwW
         wwVsuT6tYou43wjKpjbh1KeyNWCnnLYit/oHuBB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alaa Hleihel <alaa@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 05/16] net/sched: act_ct: Fix skb double-free in tcf_ct_handle_fragments() error flow
Date:   Wed, 26 Aug 2020 14:02:42 +0200
Message-Id: <20200826114911.486591180@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200826114911.216745274@linuxfoundation.org>
References: <20200826114911.216745274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alaa Hleihel <alaa@mellanox.com>

[ Upstream commit eda814b97dfb8d9f4808eb2f65af9bd3705c4cae ]

tcf_ct_handle_fragments() shouldn't free the skb when ip_defrag() call
fails. Otherwise, we will cause a double-free bug.
In such cases, just return the error to the caller.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -704,7 +704,7 @@ static int tcf_ct_handle_fragments(struc
 		err = ip_defrag(net, skb, user);
 		local_bh_enable();
 		if (err && err != -EINPROGRESS)
-			goto out_free;
+			return err;
 
 		if (!err)
 			*defrag = true;


