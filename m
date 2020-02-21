Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5981670EE
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgBUHtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:49:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:46260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729399AbgBUHtm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:49:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6673208C4;
        Fri, 21 Feb 2020 07:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271381;
        bh=AM/cxaMLSs+1tt+XbdmWhg83uD3mrehTan0F9wpp1Xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvZL6mGYig004T0QDMeDNhsDsYscQvxMXPvNq6tEPfJmLuzCU4lMllZYMRtmvMJo5
         1sPA3PUT4sPKkaP9QxhoQh+RWso3krsC5ANdwg3uogR3r6Z+spgp6J1tq70bTXaCfo
         nOO6siT9D64VKSavSpnNbKaWkJKQ8xcyx5vfnILA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 143/399] samples/bpf: Set -fno-stack-protector when building BPF programs
Date:   Fri, 21 Feb 2020 08:37:48 +0100
Message-Id: <20200221072416.391366107@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 450278977acbf494a20367c22fbb38729772d1fc ]

It seems Clang can in some cases turn on stack protection by default, which
doesn't work with BPF. This was reported once before[0], but it seems the
flag to explicitly turn off the stack protector wasn't added to the
Makefile, so do that now.

The symptom of this is compile errors like the following:

error: <unknown>:0:0: in function bpf_prog1 i32 (%struct.__sk_buff*): A call to built-in function '__stack_chk_fail' is not supported.

[0] https://www.spinics.net/lists/netdev/msg556400.html

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20191216103819.359535-1-toke@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index c0147a8cf1882..06ebe3104cc03 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -236,6 +236,7 @@ BTF_LLVM_PROBE := $(shell echo "int main() { return 0; }" | \
 			  readelf -S ./llvm_btf_verify.o | grep BTF; \
 			  /bin/rm -f ./llvm_btf_verify.o)
 
+BPF_EXTRA_CFLAGS += -fno-stack-protector
 ifneq ($(BTF_LLVM_PROBE),)
 	BPF_EXTRA_CFLAGS += -g
 else
-- 
2.20.1



