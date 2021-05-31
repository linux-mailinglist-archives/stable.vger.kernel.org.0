Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2349396083
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbhEaO1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:27:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232719AbhEaOZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:25:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F6D561584;
        Mon, 31 May 2021 13:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468810;
        bh=HoD3XkrZGR7Nh9gEQTWIAdrxvzsPYzGy9RtVq6srMV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qtQcX3/omxz9XHZTTgwVkZcBdl+ISz+u9GpHLXmI1GCNRA1Xi/ZMApTrszpSA4NYe
         TOtvTc8Wy6n/wUtX6YnDaT9CZ8QHLefFEqlsIYEsXjwXSrOEKYx1iGNlGVFBG/rk/M
         uC527DaOhpdE41fuCTkxz92cetVYyCYzzEKKOY5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 138/177] vfio-ccw: Check initialized flag in cp_init()
Date:   Mon, 31 May 2021 15:14:55 +0200
Message-Id: <20210531130652.698988179@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
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
index 3645d1720c4b..9628e0f3add3 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -636,6 +636,10 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
 {
 	int ret;
 
+	/* this is an error in the caller */
+	if (cp->initialized)
+		return -EBUSY;
+
 	/*
 	 * XXX:
 	 * Only support prefetch enable mode now.
-- 
2.30.2



