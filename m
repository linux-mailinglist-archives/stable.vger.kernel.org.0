Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F32829E161
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731404AbfH0IAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730766AbfH0IAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:00:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E75721881;
        Tue, 27 Aug 2019 08:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892809;
        bh=HEpVpW11R6XtlhWzOO8ZB/UtKNUSDr6cgG+ECkGdp48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=peA28AS51ozGtVOPFPHLkZlcYTvJf7d0KydPrm9KLL+mZjys6WD7KyrXvVC1edc7m
         Q0JzY4R2syFI/JDTldheFMAe4bFGMTfiakIQimMKMPqSMwxUTD2KHknwy3gSsLDOjz
         bIlzwGWi94nhGrsIcFczkJ1/mHt02ZB7hUhybTAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 022/162] bpf: sockmap, synchronize_rcu before freeing map
Date:   Tue, 27 Aug 2019 09:49:10 +0200
Message-Id: <20190827072739.088740557@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2bb90e5cc90e1d09f631aeab041a9cf913a5bbe5 ]

We need to have a synchronize_rcu before free'ing the sockmap because
any outstanding psock references will have a pointer to the map and
when they use this could trigger a use after free.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 1d40e040320d2..bbc91597d8364 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -252,6 +252,8 @@ static void sock_map_free(struct bpf_map *map)
 	raw_spin_unlock_bh(&stab->lock);
 	rcu_read_unlock();
 
+	synchronize_rcu();
+
 	bpf_map_area_free(stab->sks);
 	kfree(stab);
 }
-- 
2.20.1



