Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5904D7F243
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405604AbfHBJqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:46:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405590AbfHBJqv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:46:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D39320B7C;
        Fri,  2 Aug 2019 09:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739211;
        bh=hysyGQx4S7k2O9c18/c3vaD6tUW6VXFs/jIOKvpRrUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h4LxkJflpYq7TP1VOYHxD7FK+sz3sfCVWJ/gb3Pu0Zr3ptfU4/yLvWhJG34neWSJc
         qk89HpzpbZbLSqvuKNhfJBEDGTH4a95JUiQ0CsRy3OOZAmsjUZsbqNaOWOZZBEA4xY
         4d7XR26FfcsRJiGCxhdI0W3/3lP1qie6mdxnkAUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 156/223] nfsd: give out fewer session slots as limit approaches
Date:   Fri,  2 Aug 2019 11:36:21 +0200
Message-Id: <20190802092248.438219254@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit de766e570413bd0484af0b580299b495ada625c3 ]

Instead of granting client's full requests until we hit our DRC size
limit and then failing CREATE_SESSIONs (and hence mounts) completely,
start granting clients smaller slot tables as we approach the limit.

The factor chosen here is pretty much arbitrary.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 3656f87d11e3..0aacd1c850c3 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1507,6 +1507,11 @@ static u32 nfsd4_get_drc_mem(struct nfsd4_channel_attrs *ca)
 	spin_lock(&nfsd_drc_lock);
 	avail = min((unsigned long)NFSD_MAX_MEM_PER_SESSION,
 		    nfsd_drc_max_mem - nfsd_drc_mem_used);
+	/*
+	 * Never use more than a third of the remaining memory,
+	 * unless it's the only way to give this client a slot:
+	 */
+	avail = clamp_t(int, avail, slotsize, avail/3);
 	num = min_t(int, num, avail / slotsize);
 	nfsd_drc_mem_used += num * slotsize;
 	spin_unlock(&nfsd_drc_lock);
-- 
2.20.1



