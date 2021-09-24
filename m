Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C05417236
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343844AbhIXMqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:46:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343851AbhIXMqQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:46:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A10861107;
        Fri, 24 Sep 2021 12:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487483;
        bh=Gm4mnpqtSfSrpcgs5FIvvr6IzR8B0B2lMAJ2GrXMP5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HzKBivgoCnNQ6klJV13ewM2mFMQbaaPaaPNVwNBV4wZS5Enqt6Woxdb9ALdYsno/G
         +PpRI+/V7UijXGZbiNBxL3ID4t4aip7WSJa5eC+J8gx3r4jN/uxbKnKNoTRKTM5KOS
         gpAdj74p66eRzv+yaEUhvIfEhVvsI8MrRalB5sEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 03/23] sctp: validate chunk size in __rcv_asconf_lookup
Date:   Fri, 24 Sep 2021 14:43:44 +0200
Message-Id: <20210924124327.939657668@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124327.816210800@linuxfoundation.org>
References: <20210924124327.816210800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

commit b6ffe7671b24689c09faa5675dd58f93758a97ae upstream.

In one of the fallbacks that SCTP has for identifying an association for an
incoming packet, it looks for AddIp chunk (from ASCONF) and take a peek.
Thing is, at this stage nothing was validating that the chunk actually had
enough content for that, allowing the peek to happen over uninitialized
memory.

Similar check already exists in actual asconf handling in
sctp_verify_asconf().

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/input.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -1008,6 +1008,9 @@ static struct sctp_association *__sctp_r
 	union sctp_addr_param *param;
 	union sctp_addr paddr;
 
+	if (ntohs(ch->length) < sizeof(*asconf) + sizeof(struct sctp_paramhdr))
+		return NULL;
+
 	/* Skip over the ADDIP header and find the Address parameter */
 	param = (union sctp_addr_param *)(asconf + 1);
 


