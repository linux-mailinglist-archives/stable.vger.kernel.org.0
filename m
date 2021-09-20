Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B41412319
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350773AbhITSVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377310AbhITSSS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:18:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7C2161A63;
        Mon, 20 Sep 2021 17:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158560;
        bh=nlLP1PcMFvreRz2bXlOXcM6f5l++eOJOjZaNDzVxO4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rGOSMOE/D00qCB0qgEPxZDhZ2SIwW1YK2jT9LAT4eidXBINcORqDLuPkWPfWM6qOv
         ZsOuZIwXRVehhxF6PkHz2fjU3FpDYsKP1Kwxvuf7PEpnYFmaBcpX3k39vfpZ1jbpjK
         SEBXCf958pwmeLH7Nj8D2IXCijNcr2B6vIuHhCUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenpeng Lin <zplin@psu.edu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 212/260] dccp: dont duplicate ccid when cloning dccp sock
Date:   Mon, 20 Sep 2021 18:43:50 +0200
Message-Id: <20210920163938.309822216@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin, Zhenpeng <zplin@psu.edu>

commit d9ea761fdd197351890418acd462c51f241014a7 upstream.

Commit 2677d2067731 ("dccp: don't free ccid2_hc_tx_sock ...") fixed
a UAF but reintroduced CVE-2017-6074.

When the sock is cloned, two dccps_hc_tx_ccid will reference to the
same ccid. So one can free the ccid object twice from two socks after
cloning.

This issue was found by "Hadar Manor" as well and assigned with
CVE-2020-16119, which was fixed in Ubuntu's kernel. So here I port
the patch from Ubuntu to fix it.

The patch prevents cloned socks from referencing the same ccid.

Fixes: 2677d2067731410 ("dccp: don't free ccid2_hc_tx_sock ...")
Signed-off-by: Zhenpeng Lin <zplin@psu.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dccp/minisocks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/dccp/minisocks.c
+++ b/net/dccp/minisocks.c
@@ -94,6 +94,8 @@ struct sock *dccp_create_openreq_child(c
 		newdp->dccps_role	    = DCCP_ROLE_SERVER;
 		newdp->dccps_hc_rx_ackvec   = NULL;
 		newdp->dccps_service_list   = NULL;
+		newdp->dccps_hc_rx_ccid     = NULL;
+		newdp->dccps_hc_tx_ccid     = NULL;
 		newdp->dccps_service	    = dreq->dreq_service;
 		newdp->dccps_timestamp_echo = dreq->dreq_timestamp_echo;
 		newdp->dccps_timestamp_time = dreq->dreq_timestamp_time;


