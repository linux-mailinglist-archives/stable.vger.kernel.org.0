Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966A15F9980
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbiJJHNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbiJJHLi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:11:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850D55E64E;
        Mon, 10 Oct 2022 00:07:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1ED49B80E59;
        Mon, 10 Oct 2022 07:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87295C433C1;
        Mon, 10 Oct 2022 07:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385620;
        bh=N+KfCRxX1t/yyKxANDtaUUgj6VN8/odcAxx/cAj/G0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYr94tcQnyLidiaVFZmnpYyw4/idDA8j18vthyeK4e6EV2bLmogT4m5y2+jwZpZvp
         evSowVLqCQ60FOLGwvPSNVIG7NDvBxasmiQrS+gFdLBYsUgRq1YcP8DsHqc+8tNs7+
         YYw7iGpJHSP8TduapCQ8Ph59dWvNDVv8X5ABcuVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jules Irenge <jbi.octave@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.19 47/48] bpf: Fix resetting logic for unreferenced kptrs
Date:   Mon, 10 Oct 2022 09:05:45 +0200
Message-Id: <20221010070334.914562306@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
References: <20221010070333.676316214@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jules Irenge <jbi.octave@gmail.com>

commit 9fad7fe5b29803584c7f17a2abe6c2936fec6828 upstream.

Sparse reported a warning at bpf_map_free_kptrs()
"warning: Using plain integer as NULL pointer"
During the process of fixing this warning, it was discovered that the current
code erroneously writes to the pointer variable instead of deferencing and
writing to the actual kptr. Hence, Sparse tool accidentally helped to uncover
this problem. Fix this by doing WRITE_ONCE(*p, 0) instead of WRITE_ONCE(p, 0).

Note that the effect of this bug is that unreferenced kptrs will not be cleared
during check_and_free_fields. It is not a problem if the clearing is not done
during map_free stage, as there is nothing to free for them.

Fixes: 14a324f6a67e ("bpf: Wire up freeing of referenced kptr")
Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Link: https://lore.kernel.org/r/Yxi3pJaK6UDjVJSy@playground
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/syscall.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -578,7 +578,7 @@ void bpf_map_free_kptrs(struct bpf_map *
 		if (off_desc->type == BPF_KPTR_UNREF) {
 			u64 *p = (u64 *)btf_id_ptr;
 
-			WRITE_ONCE(p, 0);
+			WRITE_ONCE(*p, 0);
 			continue;
 		}
 		old_ptr = xchg(btf_id_ptr, 0);


