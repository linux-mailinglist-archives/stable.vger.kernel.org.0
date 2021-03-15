Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69AA133B668
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhCON5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230440AbhCON5P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5B9164EFD;
        Mon, 15 Mar 2021 13:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816635;
        bh=evrf6oqzd8CNxRcF1PGp1PXD0H2LYHfWSV6wHhLQ3DY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ufva10Trf5Qx1b9Qn1LjY0L7oqBDX+w9P1VXxfwWiLHoD6VkImdkmc0DlLOBZdQkw
         srYuMw480X/6mrvtczQTKKwH/lsHuRsNUKx2MTP2dzleS6UWEnsxd1fpvh+BewdeFb
         IeDGoA5w/sgAkHO2MKBXFekITNAjNR/2afvpCM6Q=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>
Subject: [PATCH 5.10 025/290] samples, bpf: Add missing munmap in xdpsock
Date:   Mon, 15 Mar 2021 14:51:58 +0100
Message-Id: <20210315135542.785343842@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

commit 6bc6699881012b5bd5d49fa861a69a37fc01b49c upstream.

We mmap the umem region, but we never munmap it.
Add the missing call at the end of the cleanup.

Fixes: 3945b37a975d ("samples/bpf: use hugepages in xdpsock app")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Link: https://lore.kernel.org/bpf/20210303185636.18070-3-maciej.fijalkowski@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/bpf/xdpsock_user.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1543,5 +1543,7 @@ int main(int argc, char **argv)
 
 	xdpsock_cleanup();
 
+	munmap(bufs, NUM_FRAMES * opt_xsk_frame_size);
+
 	return 0;
 }


