Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E7A49A4A8
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371608AbiAYAJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2364657AbiAXXsq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:48:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18C8C0419C3;
        Mon, 24 Jan 2022 13:43:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F2406150C;
        Mon, 24 Jan 2022 21:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9E8C340E4;
        Mon, 24 Jan 2022 21:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060631;
        bh=CebMge8ZokDceHnQirwT/xJla2PRMXWsgU00AcpgTGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qvtm+dGydx3j/ulWAcEoK0XwN+Q6aqBUwniOFcPPyM91r3cxBS0AMJKlRHd8h96Vp
         tDNVFJzeJCWPAcu68l5jdIhjPbvirMPB6qtr+VVMKZL+u6bJHbH/OSjr9i+OwDKe+o
         yw8fj/ftf5vhsRXOfSi0oSpPzv+IKfzT2qvkNoKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Johnston <matt@codeconstruct.com.au>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 0979/1039] mctp: test: zero out sockaddr
Date:   Mon, 24 Jan 2022 19:46:08 +0100
Message-Id: <20220124184158.194479211@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Johnston <matt@codeconstruct.com.au>

commit 284a4d94e8e74fbd731ee67e29196656ca823423 upstream.

MCTP now requires that padding bytes are zero.

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Fixes: 1e4b50f06d97 ("mctp: handle the struct sockaddr_mctp padding fields")
Link: https://lore.kernel.org/r/20220110021806.2343023-1-matt@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mctp/test/route-test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mctp/test/route-test.c
+++ b/net/mctp/test/route-test.c
@@ -285,7 +285,7 @@ static void __mctp_route_test_init(struc
 				   struct mctp_test_route **rtp,
 				   struct socket **sockp)
 {
-	struct sockaddr_mctp addr;
+	struct sockaddr_mctp addr = {0};
 	struct mctp_test_route *rt;
 	struct mctp_test_dev *dev;
 	struct socket *sock;


