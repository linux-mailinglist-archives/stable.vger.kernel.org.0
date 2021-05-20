Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C5738A9CE
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239855AbhETLGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:06:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239984AbhETLEc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:04:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F59561D19;
        Thu, 20 May 2021 10:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505093;
        bh=RoA7G0ZmY5hKYB+MBB4C21QqDWguMEVxPPx+ofxXPxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PmCwBZQjWZhFy8F8qw6q2szqKO9RICBMqMKHMB+409PSJwsHF7MN0FtbJk16tSGA3
         RJpxqhLCCc0fs/oKJm3/rBDfOCti6Rt6RfVEnokJfjrtD1Bcn3IsCbCZx+UxY34WAy
         AuHqmtmuG4xZrpu1/brRbkuBOHhX+g/hOy4SQYqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yaqi Chen <chendotjs@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 185/240] samples/bpf: Fix broken tracex1 due to kprobe argument change
Date:   Thu, 20 May 2021 11:22:57 +0200
Message-Id: <20210520092114.865244055@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yaqi Chen <chendotjs@gmail.com>

[ Upstream commit 137733d08f4ab14a354dacaa9a8fc35217747605 ]

>From commit c0bbbdc32feb ("__netif_receive_skb_core: pass skb by
reference"), the first argument passed into __netif_receive_skb_core
has changed to reference of a skb pointer.

This commit fixes by using bpf_probe_read_kernel.

Signed-off-by: Yaqi Chen <chendotjs@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20210416154803.37157-1-chendotjs@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/tracex1_kern.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/tracex1_kern.c b/samples/bpf/tracex1_kern.c
index 107da148820f..9c74b45c5720 100644
--- a/samples/bpf/tracex1_kern.c
+++ b/samples/bpf/tracex1_kern.c
@@ -20,7 +20,7 @@
 SEC("kprobe/__netif_receive_skb_core")
 int bpf_prog1(struct pt_regs *ctx)
 {
-	/* attaches to kprobe netif_receive_skb,
+	/* attaches to kprobe __netif_receive_skb_core,
 	 * looks for packets on loobpack device and prints them
 	 */
 	char devname[IFNAMSIZ];
@@ -29,7 +29,7 @@ int bpf_prog1(struct pt_regs *ctx)
 	int len;
 
 	/* non-portable! works for the given kernel only */
-	skb = (struct sk_buff *) PT_REGS_PARM1(ctx);
+	bpf_probe_read_kernel(&skb, sizeof(skb), (void *)PT_REGS_PARM1(ctx));
 	dev = _(skb->dev);
 	len = _(skb->len);
 
-- 
2.30.2



