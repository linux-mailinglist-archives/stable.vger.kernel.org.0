Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB893FDB1C
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245744AbhIAMiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343676AbhIAMg1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:36:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6FA56113A;
        Wed,  1 Sep 2021 12:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499617;
        bh=mFocXmgVSL29Whb/Q4oIEBoQOT/3OAb0PeiOGH9bU4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KT2KqdLHdZal4xj7hvL9RR9j/evgtWUlvls1olHaCn5/IY29r/QM8xJTjc3et29l5
         1JOoCYaKOHHyR3eQ4ZUH8k2mxSt0uG+bgkjPTTR1tA+N0T7WZROKeaPxeNKJEm/qab
         5S7LVzEImtcnNdqNDz69WBvcgK8wkKURuQeFDu5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.10 002/103] bpf: Fix ringbuf helper function compatibility
Date:   Wed,  1 Sep 2021 14:27:12 +0200
Message-Id: <20210901122300.585416501@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
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
@@ -4693,8 +4693,6 @@ static int check_map_func_compatibility(
 	case BPF_MAP_TYPE_RINGBUF:
 		if (func_id != BPF_FUNC_ringbuf_output &&
 		    func_id != BPF_FUNC_ringbuf_reserve &&
-		    func_id != BPF_FUNC_ringbuf_submit &&
-		    func_id != BPF_FUNC_ringbuf_discard &&
 		    func_id != BPF_FUNC_ringbuf_query)
 			goto error;
 		break;
@@ -4798,6 +4796,12 @@ static int check_map_func_compatibility(
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


