Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A450C29B7ED
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798557AbgJ0P2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:28:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1795931AbgJ0PTz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:19:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FBD520728;
        Tue, 27 Oct 2020 15:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811994;
        bh=i0EIW0YgUxIOstdq/fu9DhJMZ/7qBkSR9SyVeIqPUnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCYPt2nzzAdQ535UXcppueGqDXl8e5zG3pqDmH9wyqyjwo2wucGT5e1T1owo3XOv6
         GwMnpDx+gvc48eZScoJiriXM/6BdjL7ie9sl3lITFs/ejrk1jm6prOGQDYYHCFQ9W0
         iZhSFSNTfsmClI0dEvViQzOK0yMeTOB5UsN0KpUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 056/757] mptcp: MPTCP_KUNIT_TESTS should depend on MPTCP instead of selecting it
Date:   Tue, 27 Oct 2020 14:45:06 +0100
Message-Id: <20201027135453.178961495@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit b142083b585c2c03af24cca4d274f797796a4064 ]

MPTCP_KUNIT_TESTS selects MPTCP, thus enabling an optional feature the
user may not want to enable.  Fix this by making the test depend on
MPTCP instead.

Fixes: a00a582203dbc43e ("mptcp: move crypto test to KUNIT")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Link: https://lore.kernel.org/r/20201019113240.11516-1-geert@linux-m68k.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/Kconfig |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/mptcp/Kconfig
+++ b/net/mptcp/Kconfig
@@ -22,11 +22,8 @@ config MPTCP_IPV6
 	select IPV6
 	default y
 
-endif
-
 config MPTCP_KUNIT_TESTS
 	tristate "This builds the MPTCP KUnit tests" if !KUNIT_ALL_TESTS
-	select MPTCP
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
 	help
@@ -39,3 +36,4 @@ config MPTCP_KUNIT_TESTS
 
 	  If unsure, say N.
 
+endif


