Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460BB2F7AEC
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387485AbhAOMe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:34:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:41098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387478AbhAOMe1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:34:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA6FC2333E;
        Fri, 15 Jan 2021 12:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714052;
        bh=jcDxPuI8kFi/4vR0wJ+4fyZUtgphhDaIWa6HcUwqB2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tE6AJ6eX2x+OzCR7N7PFLR3YY8x0nr10EM/I+iwhfmgXciXf5QpZelUsU+X132Yu2
         p8b4IU5lm6V57/choq0BAndNqoOdyE72e4du2MQgAxTrO3BrLRbGJOsORfddU48J28
         W/mDuGRMzjU8G+zorAc4PU8dKxZosTxBxqGY2EpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 25/62] chtls: Added a check to avoid NULL pointer dereference
Date:   Fri, 15 Jan 2021 13:27:47 +0100
Message-Id: <20210115121959.622586303@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>

[ Upstream commit eade1e0a4fb31d48eeb1589d9bb859ae4dd6181d ]

In case of server removal lookup_stid() may return NULL pointer, which
is used as listen_ctx. So added a check before accessing this pointer.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1453,6 +1453,11 @@ static int chtls_pass_establish(struct c
 			sk_wake_async(sk, 0, POLL_OUT);
 
 		data = lookup_stid(cdev->tids, stid);
+		if (!data) {
+			/* listening server close */
+			kfree_skb(skb);
+			goto unlock;
+		}
 		lsk = ((struct listen_ctx *)data)->lsk;
 
 		bh_lock_sock(lsk);


