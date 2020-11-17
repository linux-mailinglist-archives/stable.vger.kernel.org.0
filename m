Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE40D2B640F
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732549AbgKQNoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:44:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:53134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732949AbgKQNkz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:40:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12AC5246A5;
        Tue, 17 Nov 2020 13:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620454;
        bh=6Xj/UfNXlm5AE48Worr5DOIeURy7ha/pUSjLAuAIqik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vc7/tKtUTb6iP/5OAqAVnVoJm+pSfg/zLltVwEh/7JIe61WKOa0oTknkv1tfu1uPK
         C68Txn/L4JRCEXKwzKfD+uLuVOBT3zEBI0CkaN6M2I7j8y/In1W/+Tz3AOfl2FGzx9
         PzFpnpIQ/alQ0bTI3Zc4Rt8FqD1y3w3V/05qf1S4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.9 195/255] thunderbolt: Fix memory leak if ida_simple_get() fails in enumerate_services()
Date:   Tue, 17 Nov 2020 14:05:35 +0100
Message-Id: <20201117122148.420952563@linuxfoundation.org>
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit a663e0df4a374b8537562a44d1cecafb472cd65b upstream.

The svc->key field is not released as it should be if ida_simple_get()
fails so fix that.

Fixes: 9aabb68568b4 ("thunderbolt: Fix to check return value of ida_simple_get")
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/thunderbolt/xdomain.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -881,6 +881,7 @@ static void enumerate_services(struct tb
 
 		id = ida_simple_get(&xd->service_ids, 0, 0, GFP_KERNEL);
 		if (id < 0) {
+			kfree(svc->key);
 			kfree(svc);
 			break;
 		}


