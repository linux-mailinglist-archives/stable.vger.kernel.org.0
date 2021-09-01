Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5327F3FDC04
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344817AbhIAMq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:46:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345277AbhIAMmz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:42:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4489A610E8;
        Wed,  1 Sep 2021 12:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499881;
        bh=sS4iCWWeDvKhp/KqBSQkAVKHX7N8oer4nRAAKtHaes4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bfC8zfSTwzqLc2UT2cfW9DZOaQsfZcwDMiWuf20nMLQb4OaR9xH8B4rWaUVtY2Npe
         HjSJPTPHsT5mpEtX+537O/VnOj8RrUHIedwUHnXC8LAekbaEMCHrQ/bX9hbb7+VWkc
         QQyLfHQU8Vt69czlG1U1e1eEcugCST0QmDFJaSVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.13 002/113] bpf: Fix ringbuf helper function compatibility
Date:   Wed,  1 Sep 2021 14:27:17 +0200
Message-Id: <20210901122302.062245760@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 5b029a32cfe4600f5e10e36b41778506b90fd4de upstream.

Commit 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support
for it") extended check_map_func_compatibility() by enforcing map -> helper
function match, but not helper -> map type match.

Due to this all of the bpf_ringbuf_*() helper functions could be used with
a wrong map type such as array or hash map, leading to invalid access due
to type confusion.

Also, both BPF_FUNC_ringbuf_{submit,discard} have ARG_PTR_TO_ALLOC_MEM as
argument and not a BPF map. Therefore, their check_map_func_compatibility()
presence is incorrect since it's only for map type checking.

Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it")
Reported-by: Ryota Shiga (Flatt Security)
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5148,8 +5148,6 @@ static int check_map_func_compatibility(
 	case BPF_MAP_TYPE_RINGBUF:
 		if (func_id != BPF_FUNC_ringbuf_output &&
 		    func_id != BPF_FUNC_ringbuf_reserve &&
-		    func_id != BPF_FUNC_ringbuf_submit &&
-		    func_id != BPF_FUNC_ringbuf_discard &&
 		    func_id != BPF_FUNC_ringbuf_query)
 			goto error;
 		break;
@@ -5258,6 +5256,12 @@ static int check_map_func_compatibility(
 		if (map->map_type != BPF_MAP_TYPE_PERF_EVENT_ARRAY)
 			goto error;
 		break;
+	case BPF_FUNC_ringbuf_output:
+	case BPF_FUNC_ringbuf_reserve:
+	case BPF_FUNC_ringbuf_query:
+		if (map->map_type != BPF_MAP_TYPE_RINGBUF)
+			goto error;
+		break;
 	case BPF_FUNC_get_stackid:
 		if (map->map_type != BPF_MAP_TYPE_STACK_TRACE)
 			goto error;


