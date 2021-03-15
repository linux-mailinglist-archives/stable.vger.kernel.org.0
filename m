Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5209B33B674
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhCON54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231926AbhCON5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0307264F00;
        Mon, 15 Mar 2021 13:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816639;
        bh=fJc62Oz+a/Fiquv8Q8uwC8LC00ejr5byc32G7xfch1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZJzyrB4z8SPPRJRSlu7M0PjGrn5/YVNxxyN3B6gyxAwox5dlXuSxuWkuXBuQqUef
         HmyFHRTgOqpxvG0nqclhwqVLjVEzFcV77NYEKfPJUVebgnUGghdVZqF7K0MooxIgrT
         oWEX5OHpDyL334rQUzYj2O7S6z7G1FN5WdhqxWik=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>
Subject: [PATCH 5.4 019/168] samples, bpf: Add missing munmap in xdpsock
Date:   Mon, 15 Mar 2021 14:54:11 +0100
Message-Id: <20210315135550.976065939@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
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
@@ -783,5 +783,7 @@ int main(int argc, char **argv)
 	else
 		l2fwd_all();
 
+	munmap(bufs, NUM_FRAMES * opt_xsk_frame_size);
+
 	return 0;
 }


