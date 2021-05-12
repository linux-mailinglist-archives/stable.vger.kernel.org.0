Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51AFE37C711
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbhELP6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:58:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233492AbhELPvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:51:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8A01619D0;
        Wed, 12 May 2021 15:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833174;
        bh=HH/D9Pn2RaJvhrcPfIpMqvLhEA2rGhnWd1gQMZdlTDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7c4ILuRNSuyxN/YKDkYSGJsD6fEOdoyqJ86jjf7E5ATxDyy7F2bIuWnGJopgFyMp
         L9jQcItQK2vOlu4nr+0yl7La3TEI0KJaxCjQpx2TJP+GC9SFHv5K/Gk2HKzk3Ahkdp
         nUigLOfn9/RDwnrFI2Yh4mFGH0zyivaE9Jld1PYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Ni <xni@redhat.com>,
        Song Liu <song@kernel.org>
Subject: [PATCH 5.11 047/601] async_xor: increase src_offs when dropping destination page
Date:   Wed, 12 May 2021 16:42:04 +0200
Message-Id: <20210512144829.370797171@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiao Ni <xni@redhat.com>

commit ceaf2966ab082bbc4d26516f97b3ca8a676e2af8 upstream.

Now we support sharing one page if PAGE_SIZE is not equal stripe size. To
support this, it needs to support calculating xor value with different
offsets for each r5dev. One offset array is used to record those offsets.

In RMW mode, parity page is used as a source page. It sets
ASYNC_TX_XOR_DROP_DST before calculating xor value in ops_run_prexor5.
So it needs to add src_list and src_offs at the same time. Now it only
needs src_list. So the xor value which is calculated is wrong. It can
cause data corruption problem.

I can reproduce this problem 100% on a POWER8 machine. The steps are:

  mdadm -CR /dev/md0 -l5 -n3 /dev/sdb1 /dev/sdc1 /dev/sdd1 --size=3G
  mkfs.xfs /dev/md0
  mount /dev/md0 /mnt/test
  mount: /mnt/test: mount(2) system call failed: Structure needs cleaning.

Fixes: 29bcff787a25 ("md/raid5: add new xor function to support different page offset")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/async_tx/async_xor.c |    1 +
 1 file changed, 1 insertion(+)

--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -233,6 +233,7 @@ async_xor_offs(struct page *dest, unsign
 		if (submit->flags & ASYNC_TX_XOR_DROP_DST) {
 			src_cnt--;
 			src_list++;
+			src_offs++;
 		}
 
 		/* wait for any prerequisite operations */


