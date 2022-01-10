Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17CE84890B1
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239217AbiAJHYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbiAJHYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:24:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CC6C06173F;
        Sun,  9 Jan 2022 23:24:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33A276112C;
        Mon, 10 Jan 2022 07:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F31C36AED;
        Mon, 10 Jan 2022 07:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799441;
        bh=Kbi0JQrMxN2+K0VsedL1+2Bcy7LxBtnCLQWqadVCPCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KiUdPlle/JatO2ayE+Z+3SEhrLUWqEEE2HLH/zU3RyYMc6REqJ0POzrXArIV4+Rer
         wOJO75boAzkz6uGW9kToMIgm7ZpcXXHud4RZ9JcooWpAmHHaCBITyLEHG65LeKFZfx
         0NLQmL0uwZt8Pz5Cwq+eRKtjjvcQWIMPOe8j2UkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 01/14] bpf, test: fix ld_abs + vlan push/pop stress test
Date:   Mon, 10 Jan 2022 08:22:40 +0100
Message-Id: <20220110071811.826938268@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071811.779189823@linuxfoundation.org>
References: <20220110071811.779189823@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 0d906b1e8d4002cdd59590fec630f4e75023e288 upstream.

After commit 636c2628086e ("net: skbuff: Remove errornous length
validation in skb_vlan_pop()") mentioned test case stopped working,
throwing a -12 (ENOMEM) return code. The issue however is not due to
636c2628086e, but rather due to a buggy test case that got uncovered
from the change in behaviour in 636c2628086e.

The data_size of that test case for the skb was set to 1. In the
bpf_fill_ld_abs_vlan_push_pop() handler bpf insns are generated that
loop with: reading skb data, pushing 68 tags, reading skb data,
popping 68 tags, reading skb data, etc, in order to force a skb
expansion and thus trigger that JITs recache skb->data. Problem is
that initial data_size is too small.

While before 636c2628086e, the test silently bailed out due to the
skb->len < VLAN_ETH_HLEN check with returning 0, and now throwing an
error from failing skb_ensure_writable(). Set at least minimum of
ETH_HLEN as an initial length so that on first push of data, equivalent
pop will succeed.

Fixes: 4d9c5c53ac99 ("test_bpf: add bpf_skb_vlan_push/pop() tests")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/test_bpf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -4556,7 +4556,7 @@ static struct bpf_test tests[] = {
 		{ },
 		INTERNAL,
 		{ 0x34 },
-		{ { 1, 0xbef } },
+		{ { ETH_HLEN, 0xbef } },
 		.fill_helper = bpf_fill_ld_abs_vlan_push_pop,
 	},
 	/*


