Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B16547AC55
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235812AbhLTOnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:43:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35424 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235333AbhLTOlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:41:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DAD661165;
        Mon, 20 Dec 2021 14:41:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0060AC36AEA;
        Mon, 20 Dec 2021 14:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011296;
        bh=fM3PYIoyw/Yh/A2gm/PmcJH0j14pJovNzpJBiS+sBFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+tNf0HsIRGnDXtII5JboIKBl8nKTfO31WK9X0mHw2MvJtKU9PTM1pL+zQpkSPjqt
         Q33ULjhG8UwXbDl0dp/iZodKelt9FboZ9kmBxSAj0YpTFK1y7gnKx+xNNVqkyPWT8z
         HmZYAU5QFHArxRHfZzBww9mj5ipzdE3P7WkwJt1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Haimin Zhang <tcs.kernel@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/56] netdevsim: Zero-initialize memory for new maps value in function nsim_bpf_map_alloc
Date:   Mon, 20 Dec 2021 15:34:20 +0100
Message-Id: <20211220143024.339119930@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143023.451982183@linuxfoundation.org>
References: <20211220143023.451982183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haimin Zhang <tcs.kernel@gmail.com>

[ Upstream commit 481221775d53d6215a6e5e9ce1cce6d2b4ab9a46 ]

Zero-initialize memory for new map's value in function nsim_bpf_map_alloc
since it may cause a potential kernel information leak issue, as follows:
1. nsim_bpf_map_alloc calls nsim_map_alloc_elem to allocate elements for
a new map.
2. nsim_map_alloc_elem uses kmalloc to allocate map's value, but doesn't
zero it.
3. A user application can use IOCTL BPF_MAP_LOOKUP_ELEM to get specific
element's information in the map.
4. The kernel function map_lookup_elem will call bpf_map_copy_value to get
the information allocated at step-2, then use copy_to_user to copy to the
user buffer.
This can only leak information for an array map.

Fixes: 395cacb5f1a0 ("netdevsim: bpf: support fake map offload")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Haimin Zhang <tcs.kernel@gmail.com>
Link: https://lore.kernel.org/r/20211215111530.72103-1-tcs.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/bpf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/netdevsim/bpf.c b/drivers/net/netdevsim/bpf.c
index 81444208b2162..12f100392ed11 100644
--- a/drivers/net/netdevsim/bpf.c
+++ b/drivers/net/netdevsim/bpf.c
@@ -493,6 +493,7 @@ nsim_bpf_map_alloc(struct netdevsim *ns, struct bpf_offloaded_map *offmap)
 				goto err_free;
 			key = nmap->entry[i].key;
 			*key = i;
+			memset(nmap->entry[i].value, 0, offmap->map.value_size);
 		}
 	}
 
-- 
2.33.0



