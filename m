Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265C31CAF4A
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbgEHMor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:44:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729224AbgEHMoq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:44:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89E4821974;
        Fri,  8 May 2020 12:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941885;
        bh=x/gFrVpT3Ffj+PZBClFJzWrlSI7AG0PbmewHrFiUroo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNADdHmCWjEKw+kMkX0PX/i9uS1LfaVBck/Rd4Pk6rIGIifjd20CCHlusJP7RTtHi
         WjerH2C0BPeIEj893Bg9kZB/xVKCoSRWSo+GC8sePswaA066dQZAbPQVArQIrcBZ9T
         jPk6KGV/SH9CHU9STYCIdaXSQAW0R1/6ev5X2o/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 211/312] bpf: fix map not being uncharged during map creation failure
Date:   Fri,  8 May 2020 14:33:22 +0200
Message-Id: <20200508123139.247890347@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 20b2b24f91f70e7d3f0918c077546cb21bd73a87 upstream.

In map_create(), we first find and create the map, then once that
suceeded, we charge it to the user's RLIMIT_MEMLOCK, and then fetch
a new anon fd through anon_inode_getfd(). The problem is, once the
latter fails f.e. due to RLIMIT_NOFILE limit, then we only destruct
the map via map->ops->map_free(), but without uncharging the previously
locked memory first. That means that the user_struct allocation is
leaked as well as the accounted RLIMIT_MEMLOCK memory not released.
Make the label names in the fix consistent with bpf_prog_load().

Fixes: aaac3ba95e4c ("bpf: charge user for creation of BPF maps and programs")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/syscall.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -152,7 +152,7 @@ static int map_create(union bpf_attr *at
 
 	err = bpf_map_charge_memlock(map);
 	if (err)
-		goto free_map;
+		goto free_map_nouncharge;
 
 	err = bpf_map_new_fd(map);
 	if (err < 0)
@@ -162,6 +162,8 @@ static int map_create(union bpf_attr *at
 	return err;
 
 free_map:
+	bpf_map_uncharge_memlock(map);
+free_map_nouncharge:
 	map->ops->map_free(map);
 	return err;
 }


