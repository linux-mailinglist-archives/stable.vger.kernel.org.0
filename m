Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1143D3AF0CB
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhFUQwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232349AbhFUQuy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:50:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C77961378;
        Mon, 21 Jun 2021 16:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293303;
        bh=pMOcLHHKkvDjCSzr1r68wNfje47dMb3uCF+C6BLRH2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Yz+ki62ckOBIZQiMFrXnFtuXB29KEuQwUaFSnU2Cknf3EJ9NnLqbi0jFjq3WwYpk
         Fi8mpfP9akbHI37ukA2jWfNfiJwnDYIdlTcKdBEcbd9JOVXB++38x81z2bAO5lfamm
         LeMIW2ZAjuRrmbvB4aOJl/Pzj3KFfDwREJcB5Rmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.12 175/178] tools headers UAPI: Sync linux/in.h copy with the kernel sources
Date:   Mon, 21 Jun 2021 18:16:29 +0200
Message-Id: <20210621154928.707139202@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 1792a59eab9593de2eae36c40c5a22d70f52c026 upstream.

To pick the changes in:

  321827477360934d ("icmp: don't send out ICMP messages with a source address of 0.0.0.0")

That don't result in any change in tooling, as INADDR_ are not used to
generate id->string tables used by 'perf trace'.

This addresses this build warning:

  Warning: Kernel ABI header at 'tools/include/uapi/linux/in.h' differs from latest version at 'include/uapi/linux/in.h'
  diff -u tools/include/uapi/linux/in.h include/uapi/linux/in.h

Cc: David S. Miller <davem@davemloft.net>
Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/uapi/linux/in.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/include/uapi/linux/in.h
+++ b/tools/include/uapi/linux/in.h
@@ -289,6 +289,9 @@ struct sockaddr_in {
 /* Address indicating an error return. */
 #define	INADDR_NONE		((unsigned long int) 0xffffffff)
 
+/* Dummy address for src of ICMP replies if no real address is set (RFC7600). */
+#define	INADDR_DUMMY		((unsigned long int) 0xc0000008)
+
 /* Network number for local host loopback. */
 #define	IN_LOOPBACKNET		127
 


