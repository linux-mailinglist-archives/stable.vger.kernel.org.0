Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEAA3C47E5
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236659AbhGLGfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:35:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237103AbhGLGeJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:34:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0836561159;
        Mon, 12 Jul 2021 06:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071422;
        bh=Fzt2JJGWqqOA+kL5so5Q3TuU+hirVyfpKnoG+xKTcgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3pbbttCp2EWi0J0nGfnvwb7RCM6Dmej44FPUKKOKWAhc+SbcnSm8u5nyr8HlxnvY
         3asHnmIpDGeCI9Jdsthx3J7G9WAzEgMrkEcKom0xpPHxsobrTXiuxpyCc94zVYwFc0
         paAjk6ItPSakrpA05ghUNq2+hp7ewt23i+F2DO7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>
Subject: [PATCH 5.10 025/593] usb: typec: Add the missed altmode_id_remove() in typec_register_altmode()
Date:   Mon, 12 Jul 2021 08:03:05 +0200
Message-Id: <20210712060845.963064128@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
@@ -446,8 +446,10 @@ typec_register_altmode(struct device *pa
 	int ret;
 
 	alt = kzalloc(sizeof(*alt), GFP_KERNEL);
-	if (!alt)
+	if (!alt) {
+		altmode_id_remove(parent, id);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	alt->adev.svid = desc->svid;
 	alt->adev.mode = desc->mode;


