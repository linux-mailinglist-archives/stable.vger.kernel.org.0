Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E862E99A9
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbhADQCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:02:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:39470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728748AbhADQCQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:02:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A56322245C;
        Mon,  4 Jan 2021 16:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776096;
        bh=vJnd11+QhbJEE4bfzlVETEJMHb+oixx6o4+E9ZUlmic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tNUggyKDYpv/y8NlFFB6zTmw4Jyk/PrKPRf9GUTXbTDnzsxU9DoFCJdKQA4MXKkPa
         XsuaeCitaV+cPmFn1nAsSR360WoddXr9COb/VGTBoSwyHeB4bvau4a27WFvHpQWLay
         LyubsRljmU1Mh1f+V5v9eG2CXseh9dnPlwgX+Q5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 02/63] mptcp: fix security context on server socket
Date:   Mon,  4 Jan 2021 16:56:55 +0100
Message-Id: <20210104155708.923436650@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 0c14846032f2c0a3b63234e1fc2759f4155b6067 ]

Currently MPTCP is not propagating the security context
from the ingress request socket to newly created msk
at clone time.

Address the issue invoking the missing security helper.

Fixes: cf7da0d66cc1 ("mptcp: Create SUBFLOW socket for incoming connections")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2081,6 +2081,8 @@ struct sock *mptcp_sk_clone(const struct
 	sock_reset_flag(nsk, SOCK_RCU_FREE);
 	/* will be fully established after successful MPC subflow creation */
 	inet_sk_state_store(nsk, TCP_SYN_RECV);
+
+	security_inet_csk_clone(nsk, req);
 	bh_unlock_sock(nsk);
 
 	/* keep a single reference */


