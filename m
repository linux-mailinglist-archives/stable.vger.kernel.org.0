Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE5B33B8FD
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhCOOFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231352AbhCON6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A299A64DAD;
        Mon, 15 Mar 2021 13:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816710;
        bh=0LN11zS0FSbgEzCqHfpzG5XxRooqU9F/ssw+YelPXWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lt6OgcWhJxTbZKLq8/sPrv+QXZmulgxvfs4UASSBhoGuACJ1oRroQXqHLHhKJaIID
         hGA7DJMa1DThiv04dhOYRAzx4SjU/wFzUzIu4TVz7X7IlaLizhxGM+MmhmliYQ2cMH
         ouIQLRdicGHDN7yUXkaeI5pNecm29jDWl48s8x+U=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kun-Chuan Hsieh <jetswayss@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5.11 078/306] tools/resolve_btfids: Fix build error with older host toolchains
Date:   Mon, 15 Mar 2021 14:52:21 +0100
Message-Id: <20210315135510.275986662@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Kun-Chuan Hsieh <jetswayss@gmail.com>

commit 41462c6e730ca0e63f5fed5a517052385d980c54 upstream.

Older libelf.h and glibc elf.h might not yet define the ELF compression
types.

Checking and defining SHF_COMPRESSED fix the build error when compiling
with older toolchains. Also, the tool resolve_btfids is compiled with host
toolchain. The host toolchain is more likely to be older than the cross
compile toolchain.

Fixes: 51f6463aacfb ("tools/resolve_btfids: Fix sections with wrong alignment")
Signed-off-by: Kun-Chuan Hsieh <jetswayss@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Link: https://lore.kernel.org/bpf/20210224052752.5284-1-jetswayss@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bpf/resolve_btfids/main.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -260,6 +260,11 @@ static struct btf_id *add_symbol(struct
 	return btf_id__add(root, id, false);
 }
 
+/* Older libelf.h and glibc elf.h might not yet define the ELF compression types. */
+#ifndef SHF_COMPRESSED
+#define SHF_COMPRESSED (1 << 11) /* Section with compressed data. */
+#endif
+
 /*
  * The data of compressed section should be aligned to 4
  * (for 32bit) or 8 (for 64 bit) bytes. The binutils ld


