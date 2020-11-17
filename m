Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC8E2B6425
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732813AbgKQNo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:44:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:51828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732808AbgKQNj5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:39:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71A882465E;
        Tue, 17 Nov 2020 13:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620397;
        bh=0lyIzkdCbUXab2zMjc4molrmvH2nayG/50E2rSZXsng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLSLB2CYU7MgE3SBBTcYLaU2q2ZEZ50dCc72KBgBqHG6aiPMRua2t5mOJ3oW3DjpN
         gPyHThbwUFuZGP5i6RT9KIfriXhhx7EXoeuBAgIb5Isdg2eEXT+951wBpnlSBD3Kz3
         Jv1bL7y+WjqywZALvORv/RkDbQIN2Bflamz3UGnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.9 205/255] mei: protect mei_cl_mtu from null dereference
Date:   Tue, 17 Nov 2020 14:05:45 +0100
Message-Id: <20201117122148.910493109@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit bcbc0b2e275f0a797de11a10eff495b4571863fc upstream.

A receive callback is queued while the client is still connected
but can still be called after the client was disconnected. Upon
disconnect cl->me_cl is set to NULL, hence we need to check
that ME client is not-NULL in mei_cl_mtu to avoid
null dereference.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20201029095444.957924-2-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/client.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -164,11 +164,11 @@ static inline u8 mei_cl_me_id(const stru
  *
  * @cl: host client
  *
- * Return: mtu
+ * Return: mtu or 0 if client is not connected
  */
 static inline size_t mei_cl_mtu(const struct mei_cl *cl)
 {
-	return cl->me_cl->props.max_msg_length;
+	return cl->me_cl ? cl->me_cl->props.max_msg_length : 0;
 }
 
 /**


