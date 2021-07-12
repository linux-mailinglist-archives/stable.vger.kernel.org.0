Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF1D3C4B72
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239228AbhGLG51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:57:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240968AbhGLG4O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:56:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74624608FE;
        Mon, 12 Jul 2021 06:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072806;
        bh=3H0SwX8WVDWBTcYwGQUzvFicQGh1Vm57tG+Nwkc1Lt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDQ23Kvi+cRj68+EXRlWcPuPNrMupMPJBrvGoaitSyIzp4pGgrMOt9Kl4g/TtHhZE
         eoZlt9mek0daUQTmp7GO3+fV0OomiOypLDEIL7Gt4TQM3GdN2a2EjEvB2VMLHq54n2
         D0Qm5fgLzKaTEqiag/WI1L0t65lmOeutHROwGTlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>
Subject: [PATCH 5.12 027/700] usb: typec: Add the missed altmode_id_remove() in typec_register_altmode()
Date:   Mon, 12 Jul 2021 08:01:50 +0200
Message-Id: <20210712060928.519716837@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

commit 03026197bb657d784220b040c6173267a0375741 upstream.

typec_register_altmode() misses to call altmode_id_remove() in an error
path. Add the missed function call to fix it.

Fixes: 8a37d87d72f0 ("usb: typec: Bus type for alternate modes")
Cc: stable <stable@vger.kernel.org>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Link: https://lore.kernel.org/r/20210617073226.47599-1-jingxiangfeng@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/class.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -572,8 +572,10 @@ typec_register_altmode(struct device *pa
 	int ret;
 
 	alt = kzalloc(sizeof(*alt), GFP_KERNEL);
-	if (!alt)
+	if (!alt) {
+		altmode_id_remove(parent, id);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	alt->adev.svid = desc->svid;
 	alt->adev.mode = desc->mode;


