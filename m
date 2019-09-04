Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC122A90B8
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389338AbfIDSLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:11:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390255AbfIDSLT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:11:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E364B208E4;
        Wed,  4 Sep 2019 18:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620678;
        bh=akaLcIMGPl7jRk2vLyKokSdiNDoH6/m1Fi2RRn2Oagk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kZ/PP0rKt5BaBLDAmv2BZtUBDllkYVnrMiPEYa+b+YL5yMZCCBKtdOrlrthts/RT7
         XSVc2ILn0oLfSNXLVxCo/Ta7zKiBOfkGr5wKbKemdvaTsXUV3O+y3JwtBSlo7t/h36
         rVv7JuaFrTo5uXXyEMrMmvFDZnYNQK/DThhVPFkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li RongQing <lirongqing@baidu.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Zhang Yu <zhangyu31@baidu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 052/143] net: fix __ip_mc_inc_group usage
Date:   Wed,  4 Sep 2019 19:53:15 +0200
Message-Id: <20190904175316.104436971@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit a1c4cd67840ef80f6ca5f73326fa9a6719303a95 ]

in ip_mc_inc_group, memory allocation flag, not mcast mode, is expected
by __ip_mc_inc_group

similar issue in __ip_mc_join_group, both mcase mode and gfp_t are needed
here, so use ____ip_mc_inc_group(...)

Fixes: 9fb20801dab4 ("net: Fix ip_mc_{dec,inc}_group allocation context")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/igmp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1474,7 +1474,7 @@ EXPORT_SYMBOL(__ip_mc_inc_group);
 
 void ip_mc_inc_group(struct in_device *in_dev, __be32 addr)
 {
-	__ip_mc_inc_group(in_dev, addr, MCAST_EXCLUDE);
+	__ip_mc_inc_group(in_dev, addr, GFP_KERNEL);
 }
 EXPORT_SYMBOL(ip_mc_inc_group);
 
@@ -2196,7 +2196,7 @@ static int __ip_mc_join_group(struct soc
 	iml->sflist = NULL;
 	iml->sfmode = mode;
 	rcu_assign_pointer(inet->mc_list, iml);
-	__ip_mc_inc_group(in_dev, addr, mode);
+	____ip_mc_inc_group(in_dev, addr, mode, GFP_KERNEL);
 	err = 0;
 done:
 	return err;


