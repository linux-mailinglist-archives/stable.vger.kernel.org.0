Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A15591D0ECE
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387424AbgEMKCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 06:02:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387414AbgEMJt5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:49:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE9A5206D6;
        Wed, 13 May 2020 09:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363397;
        bh=EnnBG/aX6Kg6Mk78SEPquxSEbjde6dpFg9+8Mqr0Sik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nuseMn/r2b6Tx038ZiLqyhJPfj+23QyCLt5jxGMFzUGEk3JueAor5gGyf/X96L8el
         N62OeXKIZfDlPuh931D5pjPtTl11RTG3hGVB9U1pAbgsY1l833bpmX0Nz4sqVVaEF/
         XvFCNiJXsCBNhO/U9M0U1iEsfR5D3jMLsMlNoe/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 40/90] net: mvpp2: cls: Prevent buffer overflow in mvpp2_ethtool_cls_rule_del()
Date:   Wed, 13 May 2020 11:44:36 +0200
Message-Id: <20200513094412.888788715@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 722c0f00d4feea77475a5dc943b53d60824a1e4e ]

The "info->fs.location" is a u32 that comes from the user via the
ethtool_set_rxnfc() function.  We need to check for invalid values to
prevent a buffer overflow.

I copy and pasted this check from the mvpp2_ethtool_cls_rule_ins()
function.

Fixes: 90b509b39ac9 ("net: mvpp2: cls: Add Classification offload support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -1422,6 +1422,9 @@ int mvpp2_ethtool_cls_rule_del(struct mv
 	struct mvpp2_ethtool_fs *efs;
 	int ret;
 
+	if (info->fs.location >= MVPP2_N_RFS_ENTRIES_PER_FLOW)
+		return -EINVAL;
+
 	efs = port->rfs_rules[info->fs.location];
 	if (!efs)
 		return -EINVAL;


