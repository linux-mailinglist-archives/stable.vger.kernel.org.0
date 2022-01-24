Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E731B49971C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446833AbiAXVJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:09:29 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53558 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445759AbiAXVEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:04:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DA666131F;
        Mon, 24 Jan 2022 21:04:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51288C340E5;
        Mon, 24 Jan 2022 21:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058293;
        bh=MONWWN5Pw6rnKPiBEgg31qpoflv/TBpsiZxOuGbiM5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdWULLho5spHXQocU6/tTGN3Cbp2Giwa4H5GNCDEvv0xdLr5t/YWHNcPQhVBYIxLH
         IU7txAEktGkSa2oBxEWou4Km4fEk8zJevHeJQAOyO1b2R/eE3qN3Kzo46IiCjD04UO
         nvXr1XhaMzSEQAJwV9h9kFczxWBgg98+v7+1n840=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0243/1039] samples: bpf: Fix unknown warning group build warning on Clang
Date:   Mon, 24 Jan 2022 19:33:52 +0100
Message-Id: <20220124184133.493287897@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>

[ Upstream commit 6f670d06e47c774bc065aaa84a527a4838f34bd8 ]

Clang doesn't have 'stringop-truncation' group like GCC does, and
complains about it when building samples which use xdp_sample_user
infra:

 samples/bpf/xdp_sample_user.h:48:32: warning: unknown warning group '-Wstringop-truncation', ignored [-Wunknown-warning-option]
 #pragma GCC diagnostic ignored "-Wstringop-truncation"
                                ^
[ repeat ]

Those are harmless, but avoidable when guarding it with ifdef.
I could guard push/pop as well, but this would require one more
ifdef cruft around a single line which I don't think is reasonable.

Fixes: 156f886cf697 ("samples: bpf: Add basic infrastructure for XDP samples")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/bpf/20211203195004.5803-3-alexandr.lobakin@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/xdp_sample_user.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/samples/bpf/xdp_sample_user.h b/samples/bpf/xdp_sample_user.h
index d97465ff8c62c..5f44b877ecf5f 100644
--- a/samples/bpf/xdp_sample_user.h
+++ b/samples/bpf/xdp_sample_user.h
@@ -45,7 +45,9 @@ const char *get_driver_name(int ifindex);
 int get_mac_addr(int ifindex, void *mac_addr);
 
 #pragma GCC diagnostic push
+#ifndef __clang__
 #pragma GCC diagnostic ignored "-Wstringop-truncation"
+#endif
 __attribute__((unused))
 static inline char *safe_strncpy(char *dst, const char *src, size_t size)
 {
-- 
2.34.1



