Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A529B396264
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbhEaOzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:55:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234040AbhEaOxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:53:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A0FD61CA6;
        Mon, 31 May 2021 13:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469522;
        bh=ZVRUcOSvAINhYD9WrYhTBPu86cPPOFC09xaeCR1Yfh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZiArtgy3O187sWQytPbgFiK6t62emdeyEnE9Y16kel2g2tv26sbDAdmXjkFUNsw2C
         i4HLRK3Q6r3leTQ8l5s0jDWaBHUeysqs5Q0p5hIacDIHR4xaFs1tqcA0xpMaRri5+S
         Vmr4Jk+CrMgWCxDjpw5Hsg2edBm6VMmweWvRq7rs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 229/296] vfio-ccw: Check initialized flag in cp_init()
Date:   Mon, 31 May 2021 15:14:44 +0200
Message-Id: <20210531130711.517434247@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

[ Upstream commit c6c82e0cd8125d30f2f1b29205c7e1a2f1a6785b ]

We have a really nice flag in the channel_program struct that
indicates if it had been initialized by cp_init(), and use it
as a guard in the other cp accessor routines, but not for a
duplicate call into cp_init(). The possibility of this occurring
is low, because that flow is protected by the private->io_mutex
and FSM CP_PROCESSING state. But then why bother checking it
in (for example) cp_prefetch() then?

Let's just be consistent and check for that in cp_init() too.

Fixes: 71189f263f8a3 ("vfio-ccw: make it safe to access channel programs")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Matthew Rosato <mjrosato@linux.ibm.com>
Message-Id: <20210511195631.3995081-2-farman@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/vfio_ccw_cp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index b9febc581b1f..8d1b2771c1aa 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -638,6 +638,10 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
 	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 1);
 	int ret;
 
+	/* this is an error in the caller */
+	if (cp->initialized)
+		return -EBUSY;
+
 	/*
 	 * We only support prefetching the channel program. We assume all channel
 	 * programs executed by supported guests likewise support prefetching.
-- 
2.30.2



