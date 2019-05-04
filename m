Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1106E138DE
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbfEDK1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:27:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728082AbfEDK1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:27:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B40262085A;
        Sat,  4 May 2019 10:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965640;
        bh=cwqp4+XXCvYr9qVPS+8J29OTroYcZB6SEhj/dzuR198=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RYJJBzTcWIt2Wt4TnrKagc7jvATOPUpuVoVoVhkfLQCJHignBJEwUnW+BMK2a1p+8
         TCIxJIwZXibcaQex816vue3OJKl/+E/O2ZWbLs5lmBKKbsZMuOSh+uCxb5nJzpJyzJ
         xUq/GXbeGwW/8bat6PAyxXsXqHZQMkUCv11A0vy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 16/23] bnxt_en: Free short FW command HWRM memory in error path in bnxt_init_one()
Date:   Sat,  4 May 2019 12:25:18 +0200
Message-Id: <20190504102452.060278957@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102451.512405835@linuxfoundation.org>
References: <20190504102451.512405835@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit f9099d611449836a51a65f40ea7dc9cb5f2f665e ]

In the bnxt_init_one() error path, short FW command request memory
is not freed. This patch fixes it.

Fixes: e605db801bde ("bnxt_en: Support for Short Firmware Message")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9084,6 +9084,7 @@ init_err_cleanup_tc:
 	bnxt_clear_int_mode(bp);
 
 init_err_pci_clean:
+	bnxt_free_hwrm_short_cmd_req(bp);
 	bnxt_free_hwrm_resources(bp);
 	bnxt_cleanup_pci(bp);
 


