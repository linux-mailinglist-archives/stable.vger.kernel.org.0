Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303F22B6191
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730525AbgKQNUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:20:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:53748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730512AbgKQNUV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:20:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B99FD2464E;
        Tue, 17 Nov 2020 13:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619219;
        bh=Yw1B9yR1LrXrJU3GGhQFjNUB3ifcuZATm5ZkwuY4VqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKk9gS+eOqq0nr7GbiBhgloZx9/nlgWnn/Rncvlmnz2HXX2DQdicUQ4j3m5eXyjKF
         DjcbUvyKbYexZK6rROIEiOv+ruy30WXiAS1IKMLPM42AZl8og5KmAgAtpFnq2WwWit
         AIDhf2BLk9mvMPr9X09+uLy49Wol6QrKM9uZwnHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 4.19 067/101] thunderbolt: Fix memory leak if ida_simple_get() fails in enumerate_services()
Date:   Tue, 17 Nov 2020 14:05:34 +0100
Message-Id: <20201117122116.374513186@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
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
@@ -774,6 +774,7 @@ static void enumerate_services(struct tb
 
 		id = ida_simple_get(&xd->service_ids, 0, 0, GFP_KERNEL);
 		if (id < 0) {
+			kfree(svc->key);
 			kfree(svc);
 			break;
 		}


