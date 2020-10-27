Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C099A29C117
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368290AbgJ0Oyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:54:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1766568AbgJ0OtU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:49:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B04E5206E5;
        Tue, 27 Oct 2020 14:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810159;
        bh=plV74ACRqJ0VnjFZjAIsVTWYzSWS5YeylkC4Puqi540=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vsGEejswlIECJe7KxogtbEB8NmkpoRZ+EeHdsOU8zIwHA3fJU3Isa9Qcku+AtT1Pl
         K2RiIUErhjye7JOcQPjSIxHr19KlLyY19dT1hxFwyMYwtBP+ecD4ySOq/wnShz4UEk
         hV14LE6yuQp8z+GKf/Qu5nfASQS4jbuQaxwcESoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geliang Tang <geliangtang@gmail.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 040/633] mptcp: initialize mptcp_options_receiveds ahmac
Date:   Tue, 27 Oct 2020 14:46:23 +0100
Message-Id: <20201027135524.574858427@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

[ Upstream commit fe2d9b1a0e7805384770ec0ddd34c9f1e9fe6fa8 ]

Initialize mptcp_options_received's ahmac to zero, otherwise it
will be a random number when receiving ADD_ADDR suboption with echo-flag=1.

Fixes: 3df523ab582c5 ("mptcp: Add ADD_ADDR handling")
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -296,6 +296,7 @@ void mptcp_get_options(const struct sk_b
 	mp_opt->mp_capable = 0;
 	mp_opt->mp_join = 0;
 	mp_opt->add_addr = 0;
+	mp_opt->ahmac = 0;
 	mp_opt->rm_addr = 0;
 	mp_opt->dss = 0;
 


