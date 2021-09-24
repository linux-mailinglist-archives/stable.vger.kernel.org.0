Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678E94172EE
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344914AbhIXMwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344418AbhIXMvN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:51:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C19136124F;
        Fri, 24 Sep 2021 12:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487734;
        bh=dgxGTPGDtcmyifdM0E9+rHhzvxS4drkVUO2lqvM9bsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tB3ES4kdLpSHm45SaYfwzpvNPUZts8bVOCCeYg36WXhJeQ+qNAwn4kRngXOxkL3gD
         QjE/KIVa1RpBUy/tun36Y0U0izOIhdOgl290x/Fz7xU1sH0jXoNnR2PUA0zG/dh7FS
         1D/YcOVtn0ZYuWidN92bKdFCsypYB92OJjElLNTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 07/34] sctp: validate chunk size in __rcv_asconf_lookup
Date:   Fri, 24 Sep 2021 14:44:01 +0200
Message-Id: <20210924124330.206328802@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124329.965218583@linuxfoundation.org>
References: <20210924124329.965218583@linuxfoundation.org>
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
@@ -1125,6 +1125,9 @@ static struct sctp_association *__sctp_r
 	union sctp_addr_param *param;
 	union sctp_addr paddr;
 
+	if (ntohs(ch->length) < sizeof(*asconf) + sizeof(struct sctp_paramhdr))
+		return NULL;
+
 	/* Skip over the ADDIP header and find the Address parameter */
 	param = (union sctp_addr_param *)(asconf + 1);
 


