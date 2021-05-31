Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF886395E94
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhEaOAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:00:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231578AbhEaN6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:58:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6E4F6193A;
        Mon, 31 May 2021 13:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468129;
        bh=RzBQ5/IUAAheWWePphH0Y5uFrcrszMTSwqfnXs89aBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKy+TXGvCD4qes2xdxPYOAOn0LkMphdRKij6K3fk4YCL405gjH1Qgli4owqV4FKbS
         LmYn56MUjCKgmMaxk9QTCZgiCNwQjyJfHvEkEL0PoKVnkXRcNYtTDTjSTpMNQZpzn3
         QjVfCh4SWiUSgVeTS9UpioVpEt9Vvd/MgHplP/Ng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 128/252] mptcp: drop unconditional pr_warn on bad opt
Date:   Mon, 31 May 2021 15:13:13 +0200
Message-Id: <20210531130702.363174029@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit 3812ce895047afdb78dc750a236515416e0ccded upstream.

This is a left-over of early day. A malicious peer can flood
the kernel logs with useless messages, just drop it.

Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -127,7 +127,6 @@ static void mptcp_parse_option(const str
 			memcpy(mp_opt->hmac, ptr, MPTCPOPT_HMAC_LEN);
 			pr_debug("MP_JOIN hmac");
 		} else {
-			pr_warn("MP_JOIN bad option size");
 			mp_opt->mp_join = 0;
 		}
 		break;


