Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E32411C89
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345443AbhITRKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:10:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345115AbhITRIs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:08:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB7FC617E2;
        Mon, 20 Sep 2021 16:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156959;
        bh=NmQzoMEdQul50NFlf+7/qxfkT1Aq30lSXnWCdT6eg0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A7doxJpIfzkAtjIpYNKYi5ZHf0oI0t+Ap5/+pXuTNV7VHrMXI1mK+nTWMjYh+1bLA
         GvorgZlZMaDM18YEXgahYFOfTVAfWker6wo3ru8DzMPll8oOv1l4SMxghWGVKygh6r
         gr8Hppwf9czZm6z3xwRtqRjS1YJ5uk1hAQKT5dws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 164/175] ibmvnic: check failover_pending in login response
Date:   Mon, 20 Sep 2021 18:43:33 +0200
Message-Id: <20210920163923.428883575@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

commit 273c29e944bda9a20a30c26cfc34c9a3f363280b upstream.

If a failover occurs before a login response is received, the login
response buffer maybe undefined. Check that there was no failover
before accessing the login response buffer.

Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2527,6 +2527,14 @@ static int handle_login_rsp(union ibmvni
 		return 0;
 	}
 
+	if (adapter->failover_pending) {
+		adapter->init_done_rc = -EAGAIN;
+		netdev_dbg(netdev, "Failover pending, ignoring login response\n");
+		complete(&adapter->init_done);
+		/* login response buffer will be released on reset */
+		return 0;
+	}
+
 	netdev_dbg(adapter->netdev, "Login Response Buffer:\n");
 	for (i = 0; i < (adapter->login_rsp_buf_sz - 1) / 8 + 1; i++) {
 		netdev_dbg(adapter->netdev, "%016lx\n",


