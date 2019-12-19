Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEEA126ABA
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729970AbfLSSu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:50:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:44250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729979AbfLSSu0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:50:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAC402064B;
        Thu, 19 Dec 2019 18:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781425;
        bh=vVlHfKK7lbNM4dstoY77z0seU4XGgjMCnhLHwYP2yaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YfGxqdq4QBn0li4zZxTIS7m6DdAmlNlGD2xeJD2xhhgzzfOEGMVGMMsW/CHzoIKNK
         hJPIOWiRbuRNIFR+qEcDoRR3qu5GSSbbEjOBbSLKLrw6Ka0+P9ROPdIPJQHv6b+yS7
         GutXF+D67U1KN5E2X4WTQ/0Qq0Zt21pyK2RH3Svs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 06/36] tcp: md5: fix potential overestimation of TCP option space
Date:   Thu, 19 Dec 2019 19:34:23 +0100
Message-Id: <20191219182855.431781197@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219182848.708141124@linuxfoundation.org>
References: <20191219182848.708141124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9424e2e7ad93ffffa88f882c9bc5023570904b55 ]

Back in 2008, Adam Langley fixed the corner case of packets for flows
having all of the following options : MD5 TS SACK

Since MD5 needs 20 bytes, and TS needs 12 bytes, no sack block
can be cooked from the remaining 8 bytes.

tcp_established_options() correctly sets opts->num_sack_blocks
to zero, but returns 36 instead of 32.

This means TCP cooks packets with 4 extra bytes at the end
of options, containing unitialized bytes.

Fixes: 33ad798c924b ("tcp: options clean up")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -708,8 +708,9 @@ static unsigned int tcp_established_opti
 			min_t(unsigned int, eff_sacks,
 			      (remaining - TCPOLEN_SACK_BASE_ALIGNED) /
 			      TCPOLEN_SACK_PERBLOCK);
-		size += TCPOLEN_SACK_BASE_ALIGNED +
-			opts->num_sack_blocks * TCPOLEN_SACK_PERBLOCK;
+		if (likely(opts->num_sack_blocks))
+			size += TCPOLEN_SACK_BASE_ALIGNED +
+				opts->num_sack_blocks * TCPOLEN_SACK_PERBLOCK;
 	}
 
 	return size;


