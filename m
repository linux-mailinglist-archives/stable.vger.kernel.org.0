Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40BF246A3F
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730334AbgHQPcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:32:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730329AbgHQPcp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:32:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FC622343B;
        Mon, 17 Aug 2020 15:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678364;
        bh=qvwbes1AHvccrhOI+t66UJQh65PbZFktxOl3LhPNjg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g07J6lM42bqbdnduvitpf+zRSyf24E3FUvY/U+MlXMlcf9H3fn1zlYA7H5T6aJDG0
         WAHxofxL6X7Jm4kJEexWCzo+Ie4UJncEgMA5PKJ+8lKFTrPKpvN8bgGFHihxpyWuX6
         q/DAJI57If1r3RB99/CSxSkt30bxT0Pg8/2tjwI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 308/464] bpf: Fix bpf_ringbuf_output() signature to return long
Date:   Mon, 17 Aug 2020 17:14:21 +0200
Message-Id: <20200817143848.552776166@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit e1613b5714ee6c186c9628e9958edf65e9d9cddd ]

Due to bpf tree fix merge, bpf_ringbuf_output() signature ended up with int as
a return type, while all other helpers got converted to returning long. So fix
it in bpf-next now.

Fixes: b0659d8a950d ("bpf: Fix definition of bpf_ringbuf_output() helper in UAPI comments")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20200727224715.652037-1-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/bpf.h       | 2 +-
 tools/include/uapi/linux/bpf.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 8bd33050b7bbb..a3fd55194e0b1 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3168,7 +3168,7 @@ union bpf_attr {
  *	Return
  *		The id is returned or 0 in case the id could not be retrieved.
  *
- * int bpf_ringbuf_output(void *ringbuf, void *data, u64 size, u64 flags)
+ * long bpf_ringbuf_output(void *ringbuf, void *data, u64 size, u64 flags)
  * 	Description
  * 		Copy *size* bytes from *data* into a ring buffer *ringbuf*.
  * 		If **BPF_RB_NO_WAKEUP** is specified in *flags*, no notification
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 8bd33050b7bbb..a3fd55194e0b1 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3168,7 +3168,7 @@ union bpf_attr {
  *	Return
  *		The id is returned or 0 in case the id could not be retrieved.
  *
- * int bpf_ringbuf_output(void *ringbuf, void *data, u64 size, u64 flags)
+ * long bpf_ringbuf_output(void *ringbuf, void *data, u64 size, u64 flags)
  * 	Description
  * 		Copy *size* bytes from *data* into a ring buffer *ringbuf*.
  * 		If **BPF_RB_NO_WAKEUP** is specified in *flags*, no notification
-- 
2.25.1



