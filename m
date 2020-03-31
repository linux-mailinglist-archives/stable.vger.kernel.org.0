Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEC66198F82
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730672AbgCaJEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:04:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730697AbgCaJEE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:04:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B4A120848;
        Tue, 31 Mar 2020 09:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645443;
        bh=lPv5/SVxRUsJE9C6iPhlGEWnmckp85fixzSHFBBxPAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIrc1RNQWaz6rSTlT1e1wIQPwH5IQqtp15OSz53mZofw2MQnG3enHj1aVZ+O/oDDE
         kM/HsoThHJlpALXs/eOFK62ENcMrzBVLLPliRDO5p9CmrVwXElVJu5LifwZb64ExP6
         9LU7/JytBeE11mECkbcz2BcNP0i7/octK1SvAFxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 055/170] hsr: set .netnsok flag
Date:   Tue, 31 Mar 2020 10:57:49 +0200
Message-Id: <20200331085430.483056576@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 09e91dbea0aa32be02d8877bd50490813de56b9a ]

The hsr module has been supporting the list and status command.
(HSR_C_GET_NODE_LIST and HSR_C_GET_NODE_STATUS)
These commands send node information to the user-space via generic netlink.
But, in the non-init_net namespace, these commands are not allowed
because .netnsok flag is false.
So, there is no way to get node information in the non-init_net namespace.

Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/hsr/hsr_netlink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -470,6 +470,7 @@ static struct genl_family hsr_genl_famil
 	.version = 1,
 	.maxattr = HSR_A_MAX,
 	.policy = hsr_genl_policy,
+	.netnsok = true,
 	.module = THIS_MODULE,
 	.ops = hsr_ops,
 	.n_ops = ARRAY_SIZE(hsr_ops),


