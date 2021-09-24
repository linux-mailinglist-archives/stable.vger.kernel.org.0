Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93077417329
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344636AbhIXMyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:54:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344427AbhIXMxC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:53:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C34BF61283;
        Fri, 24 Sep 2021 12:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487794;
        bh=sVj4NViv8I9Ye7NZK+6h2fz6Y67/NjNqPhEZHcsmaKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2kja3ELRhUwbj1FNUJUZNC551lBDJe4W0XOuIHeQNDcBAeNb+x8EPaUYCAmq1sOi
         1oy7KC/qXBpFF5cKoBvOZ8BKKV4A6nUOixd8WMzJQPUvhgW3Jf9G7uHeC6PHYEEZeH
         RSWb9rAdII7gOIzl8uWotzArB8ZjE9E/Ru6+QNsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 15/50] sctp: validate chunk size in __rcv_asconf_lookup
Date:   Fri, 24 Sep 2021 14:44:04 +0200
Message-Id: <20210924124332.747997475@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124332.229289734@linuxfoundation.org>
References: <20210924124332.229289734@linuxfoundation.org>
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
@@ -1168,6 +1168,9 @@ static struct sctp_association *__sctp_r
 	union sctp_addr_param *param;
 	union sctp_addr paddr;
 
+	if (ntohs(ch->length) < sizeof(*asconf) + sizeof(struct sctp_paramhdr))
+		return NULL;
+
 	/* Skip over the ADDIP header and find the Address parameter */
 	param = (union sctp_addr_param *)(asconf + 1);
 


