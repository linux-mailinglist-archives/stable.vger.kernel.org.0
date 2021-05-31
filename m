Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF50395E90
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbhEaOAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:00:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232977AbhEaN62 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:58:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96598613F5;
        Mon, 31 May 2021 13:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468132;
        bh=3aIgDmPsqoOhDLuQaV1yi37v5raac+mgycOPE1w4/+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WuZd6YcOfiJxxkOMQ6b1xupRXzoeX605EtuI5yXAGMZ96/xlld1+2nulymWmQXnwz
         zbkmQ9skrabMEIW9c4TLDTAJ3am6lzHAaBNx/MH9gbydZ1l6GyopGpaViwCSg1xC3p
         arwDNds0pLlFWxAWjqrEuHw2LiMXBFHNsnIKcc38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxim Galaganov <max@internet.ru>
Subject: [PATCH 5.10 129/252] mptcp: fix data stream corruption
Date:   Mon, 31 May 2021 15:13:14 +0200
Message-Id: <20210531130702.399802167@linuxfoundation.org>
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

commit 29249eac5225429b898f278230a6ca2baa1ae154 upstream.

Maxim reported several issues when forcing a TCP transparent proxy
to use the MPTCP protocol for the inbound connections. He also
provided a clean reproducer.

The problem boils down to 'mptcp_frag_can_collapse_to()' assuming
that only MPTCP will use the given page_frag.

If others - e.g. the plain TCP protocol - allocate page fragments,
we can end-up re-using already allocated memory for mptcp_data_frag.

Fix the issue ensuring that the to-be-expanded data fragment is
located at the current page frag end.

v1 -> v2:
 - added missing fixes tag (Mat)

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/178
Reported-and-tested-by: Maxim Galaganov <max@internet.ru>
Fixes: 18b683bff89d ("mptcp: queue data for mptcp level retransmission")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -758,11 +758,17 @@ static bool mptcp_skb_can_collapse_to(u6
 	return mpext && mpext->data_seq + mpext->data_len == write_seq;
 }
 
+/* we can append data to the given data frag if:
+ * - there is space available in the backing page_frag
+ * - the data frag tail matches the current page_frag free offset
+ * - the data frag end sequence number matches the current write seq
+ */
 static bool mptcp_frag_can_collapse_to(const struct mptcp_sock *msk,
 				       const struct page_frag *pfrag,
 				       const struct mptcp_data_frag *df)
 {
 	return df && pfrag->page == df->page &&
+		pfrag->offset == (df->offset + df->data_len) &&
 		df->data_seq + df->data_len == msk->write_seq;
 }
 


