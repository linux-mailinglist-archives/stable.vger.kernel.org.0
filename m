Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1927133B662
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbhCON5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231572AbhCON5P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04CE764F18;
        Mon, 15 Mar 2021 13:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816635;
        bh=Ov+vMxu7B3lb5UN/RgPNTqrMU4kdSUd3pJNbWAZnNKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OzyoPmOqd3ang9+JQo2jGaCdcUY1az2ER1YBAQMgm8Fq55YKLoJKvOUwXfr+H0/Mr
         58SZ+3u/admrZ1iO1fcTsxPHfWCGb/RMITW0m/ngz4DiGfLd87XRFkNwkbUVtLLrCb
         DEA7pHYrHlI22dlLlpkrODudTkT35okMJHOgcvoQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>
Subject: [PATCH 5.11 033/306] libbpf: Clear map_info before each bpf_obj_get_info_by_fd
Date:   Mon, 15 Mar 2021 14:51:36 +0100
Message-Id: <20210315135508.748269654@linuxfoundation.org>
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

commit 2b2aedabc44e9660f90ccf7ba1ca2706d75f411f upstream.

xsk_lookup_bpf_maps, based on prog_fd, looks whether current prog has a
reference to XSKMAP. BPF prog can include insns that work on various BPF
maps and this is covered by iterating through map_ids.

The bpf_map_info that is passed to bpf_obj_get_info_by_fd for filling
needs to be cleared at each iteration, so that it doesn't contain any
outdated fields and that is currently missing in the function of
interest.

To fix that, zero-init map_info via memset before each
bpf_obj_get_info_by_fd call.

Also, since the area of this code is touched, in general strcmp is
considered harmful, so let's convert it to strncmp and provide the
size of the array name for current map_info.

While at it, do s/continue/break/ once we have found the xsks_map to
terminate the search.

Fixes: 5750902a6e9b ("libbpf: proper XSKMAP cleanup")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Link: https://lore.kernel.org/bpf/20210303185636.18070-4-maciej.fijalkowski@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/bpf/xsk.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -535,15 +535,16 @@ static int xsk_lookup_bpf_maps(struct xs
 		if (fd < 0)
 			continue;
 
+		memset(&map_info, 0, map_len);
 		err = bpf_obj_get_info_by_fd(fd, &map_info, &map_len);
 		if (err) {
 			close(fd);
 			continue;
 		}
 
-		if (!strcmp(map_info.name, "xsks_map")) {
+		if (!strncmp(map_info.name, "xsks_map", sizeof(map_info.name))) {
 			ctx->xsks_map_fd = fd;
-			continue;
+			break;
 		}
 
 		close(fd);


