Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C17413FE01
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391517AbgAPXbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:31:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:40412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391482AbgAPXbp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:31:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D12420661;
        Thu, 16 Jan 2020 23:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217505;
        bh=h+byEWvsgdhemHu13KACwa/7kqTpPFzXgZyL0H2/qjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jKrMYGtGA0bso20U8ZQs7SzMVbycSCqkQwjpwQk3BLjBUMF9hsPFW/++FFCkbCJZR
         1yGHMGJF00oa1jL45+3qnAaCahiZb8GBMdNT3T4EDl8cW4RFNGsGyws1FGiFp4vocW
         54cEJWHqe3+fOr/CQFUBIMEJYko4GS+WNUgw5VTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Michal Kubecek <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Miles Chen <miles.chen@mediatek.com>
Subject: [PATCH 4.14 04/71] ethtool: reduce stack usage with clang
Date:   Fri, 17 Jan 2020 00:18:02 +0100
Message-Id: <20200116231710.044940260@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 3499e87ea0413ee5b2cc028f4c8ed4d424bc7f98 upstream.

clang inlines the dev_ethtool() more aggressively than gcc does, leading
to a larger amount of used stack space:

net/core/ethtool.c:2536:24: error: stack frame size of 1216 bytes in function 'dev_ethtool' [-Werror,-Wframe-larger-than=]

Marking the sub-functions that require the most stack space as
noinline_for_stack gives us reasonable behavior on all compilers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/ethtool.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -2343,9 +2343,10 @@ static int ethtool_set_tunable(struct ne
 	return ret;
 }
 
-static int ethtool_get_per_queue_coalesce(struct net_device *dev,
-					  void __user *useraddr,
-					  struct ethtool_per_queue_op *per_queue_opt)
+static noinline_for_stack int
+ethtool_get_per_queue_coalesce(struct net_device *dev,
+			       void __user *useraddr,
+			       struct ethtool_per_queue_op *per_queue_opt)
 {
 	u32 bit;
 	int ret;
@@ -2375,9 +2376,10 @@ static int ethtool_get_per_queue_coalesc
 	return 0;
 }
 
-static int ethtool_set_per_queue_coalesce(struct net_device *dev,
-					  void __user *useraddr,
-					  struct ethtool_per_queue_op *per_queue_opt)
+static noinline_for_stack int
+ethtool_set_per_queue_coalesce(struct net_device *dev,
+			       void __user *useraddr,
+			       struct ethtool_per_queue_op *per_queue_opt)
 {
 	u32 bit;
 	int i, ret = 0;
@@ -2434,7 +2436,7 @@ roll_back:
 	return ret;
 }
 
-static int ethtool_set_per_queue(struct net_device *dev,
+static int noinline_for_stack ethtool_set_per_queue(struct net_device *dev,
 				 void __user *useraddr, u32 sub_cmd)
 {
 	struct ethtool_per_queue_op per_queue_opt;


