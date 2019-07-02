Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8116A5CB41
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbfGBIIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:08:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727842AbfGBIIq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:08:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6551206A2;
        Tue,  2 Jul 2019 08:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054925;
        bh=8X71bpmRYa3Yx+gOlVC9pX5bTxnVVFLRsTAVsZOIFnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQf/WA6gcCY/aCfrjLLuRmuhg90q6J8fqGDtYHDNLxbaXzs9y7sGxxJu9RNJB/T+p
         QWFt2DmOMGFfvyADD/RLkac9urXxp0OwRnnQN5q058FFIgmmXnT50qje7FBqmspWx+
         ssXaDXQ/n2zcgzEWBSeX3U5r4cI2sHBv3A+fI82g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martynas Pumputis <m@lambda.lt>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.19 62/72] bpf: simplify definition of BPF_FIB_LOOKUP related flags
Date:   Tue,  2 Jul 2019 10:02:03 +0200
Message-Id: <20190702080127.840630441@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martynas Pumputis <m@lambda.lt>

commit b1d6c15b9d824a58c5415673f374fac19e8eccdf upstream.

Previously, the BPF_FIB_LOOKUP_{DIRECT,OUTPUT} flags in the BPF UAPI
were defined with the help of BIT macro. This had the following issues:

- In order to use any of the flags, a user was required to depend
  on <linux/bits.h>.
- No other flag in bpf.h uses the macro, so it seems that an unwritten
  convention is to use (1 << (nr)) to define BPF-related flags.

Fixes: 87f5fc7e48dd ("bpf: Provide helper to do forwarding lookups in kernel FIB table")
Signed-off-by: Martynas Pumputis <m@lambda.lt>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/bpf.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2705,8 +2705,8 @@ struct bpf_raw_tracepoint_args {
 /* DIRECT:  Skip the FIB rules and go to FIB table associated with device
  * OUTPUT:  Do lookup from egress perspective; default is ingress
  */
-#define BPF_FIB_LOOKUP_DIRECT  BIT(0)
-#define BPF_FIB_LOOKUP_OUTPUT  BIT(1)
+#define BPF_FIB_LOOKUP_DIRECT  (1U << 0)
+#define BPF_FIB_LOOKUP_OUTPUT  (1U << 1)
 
 enum {
 	BPF_FIB_LKUP_RET_SUCCESS,      /* lookup successful */


