Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9CD81D0D90
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388050AbgEMJyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:54:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732826AbgEMJyH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:54:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F781205ED;
        Wed, 13 May 2020 09:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363646;
        bh=YXLFxgx/cR+xQ8Urciq83J/EM61NJniqRVSKvI+Ss68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A5zxQ4emUI9wsU31i6tLwh1NCiMxeQFqOL6AHW2eM3p/hxlJmBMZPDSKEFRDEzlTD
         G0dt0Panf8K4uvCwTuylkVDnOjNL5XNt757Gu0BV+sRlcFkODaNy+yHbJrIO3rlbJM
         AHaYf6pvwzS3HWzkhGbkgyQFlRl//RB7//iq2DgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 031/118] net/tls: Fix sk_psock refcnt leak in bpf_exec_tx_verdict()
Date:   Wed, 13 May 2020 11:44:10 +0200
Message-Id: <20200513094420.270139384@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit 095f5614bfe16e5b3e191b34ea41b10d6fdd4ced ]

bpf_exec_tx_verdict() invokes sk_psock_get(), which returns a reference
of the specified sk_psock object to "psock" with increased refcnt.

When bpf_exec_tx_verdict() returns, local variable "psock" becomes
invalid, so the refcount should be decreased to keep refcount balanced.

The reference counting issue happens in one exception handling path of
bpf_exec_tx_verdict(). When "policy" equals to NULL but "psock" is not
NULL, the function forgets to decrease the refcnt increased by
sk_psock_get(), causing a refcnt leak.

Fix this issue by calling sk_psock_put() on this error path before
bpf_exec_tx_verdict() returns.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -800,6 +800,8 @@ static int bpf_exec_tx_verdict(struct sk
 			*copied -= sk_msg_free(sk, msg);
 			tls_free_open_rec(sk);
 		}
+		if (psock)
+			sk_psock_put(sk, psock);
 		return err;
 	}
 more_data:


