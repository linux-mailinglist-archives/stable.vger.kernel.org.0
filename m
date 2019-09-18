Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABFFBB5C48
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbfIRGYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:24:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbfIRGYs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:24:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 635EC21906;
        Wed, 18 Sep 2019 06:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787887;
        bh=UqpGjpQIsaWV6BoQvz6w19/Y036E3Hu8dlA49ww9pRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=APRqOiTAAjcSw1jFqUBN60QzWMfgi8/CAXYU2dJ7sRkpkGFpzTIODs6JFtbU2M43v
         kJx3/8P5XAZwojBElXaPyxtDKmanopA8u7cXx/MmY6SS9y5YF51q6s2Yph9LhycmNU
         YhirIa4xUf2Eb9rOAPLuOZlZKypiAQpM/5Hpqbuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 20/85] sctp: fix the missing put_user when dumping transport thresholds
Date:   Wed, 18 Sep 2019 08:18:38 +0200
Message-Id: <20190918061234.788486326@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit f794dc2304d83ab998c2eee5bab0549aff5c53a2 ]

This issue causes SCTP_PEER_ADDR_THLDS sockopt not to be able to dump
a transport thresholds info.

Fix it by adding 'goto' put_user in sctp_getsockopt_paddr_thresholds.

Fixes: 8add543e369d ("sctp: add SCTP_FUTURE_ASSOC for SCTP_PEER_ADDR_THLDS sockopt")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7176,7 +7176,7 @@ static int sctp_getsockopt_paddr_thresho
 		val.spt_pathmaxrxt = trans->pathmaxrxt;
 		val.spt_pathpfthld = trans->pf_retrans;
 
-		return 0;
+		goto out;
 	}
 
 	asoc = sctp_id2assoc(sk, val.spt_assoc_id);
@@ -7194,6 +7194,7 @@ static int sctp_getsockopt_paddr_thresho
 		val.spt_pathmaxrxt = sp->pathmaxrxt;
 	}
 
+out:
 	if (put_user(len, optlen) || copy_to_user(optval, &val, len))
 		return -EFAULT;
 


