Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A27D3FDAD4
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245170AbhIAMfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:35:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245077AbhIAMeA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:34:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C519761101;
        Wed,  1 Sep 2021 12:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499542;
        bh=pDiIeXIMJJQSlQ9idD3XsFcHNUg17TiXQAif29lmiWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ip4m8D/fEix5J+iJxqPjiaWD/WfxC1u5k75X8SSv6mVLgE8heK4wDLK43sbcRY4xo
         Htoxq/3WtXzcg/9uz56nrBD8bxDDm91w2qDOVcxClSEviBwmgDA4fwCm3RckDs396A
         Nz25T1zJni9UzBjgX7X3g5EQB28sykVb8oCtK6/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>
Subject: [PATCH 5.4 40/48] bpf: Fix cast to pointer from integer of different size warning
Date:   Wed,  1 Sep 2021 14:28:30 +0200
Message-Id: <20210901122254.711952358@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
References: <20210901122253.388326997@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

commit 2dedd7d2165565bafa89718eaadfc5d1a7865f66 upstream.

Fix "warning: cast to pointer from integer of different size" when
casting u64 addr to void *.

Fixes: a23740ec43ba ("bpf: Track contents of read-only maps as scalars")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20191011172053.2980619-1-andriin@fb.com
Cc: Rafael David Tinoco <rafaeldtinoco@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2792,7 +2792,7 @@ static int bpf_map_direct_read(struct bp
 	err = map->ops->map_direct_value_addr(map, &addr, off);
 	if (err)
 		return err;
-	ptr = (void *)addr + off;
+	ptr = (void *)(long)addr + off;
 
 	switch (size) {
 	case sizeof(u8):


