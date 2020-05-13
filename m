Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB481D0EC5
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732792AbgEMJuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387464AbgEMJuO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:50:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD8CB20575;
        Wed, 13 May 2020 09:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363414;
        bh=/ignZR7GNcTHAuBeR3m6gniiTyCHIeXYnBm8RqmIW5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0YEpo8OTDCzwlQBebKRC2DNUdGyFvX/Tspp+Vhk3rILuB1+3+398L2UgEFcVKdh0H
         VjLHCjcpdlrERTE2NBL3Fl6Hxjzp9RYl9oc3OBt7JQzYCORMLf/VGaW8kBJDAwKkPb
         VuSDqCmKdDEFuXng2/Gaw/Wus2BUzFfS/K1MQljc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oscar Carter <oscar.carter@gmx.com>,
        Richard Yeh <rcy@google.com>
Subject: [PATCH 5.4 64/90] staging: gasket: Check the return value of gasket_get_bar_index()
Date:   Wed, 13 May 2020 11:45:00 +0200
Message-Id: <20200513094416.227059430@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oscar Carter <oscar.carter@gmx.com>

commit 769acc3656d93aaacada814939743361d284fd87 upstream.

Check the return value of gasket_get_bar_index function as it can return
a negative one (-EINVAL). If this happens, a negative index is used in
the "gasket_dev->bar_data" array.

Addresses-Coverity-ID: 1438542 ("Negative array index read")
Fixes: 9a69f5087ccc2 ("drivers/staging: Gasket driver framework + Apex driver")
Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Richard Yeh <rcy@google.com>
Link: https://lore.kernel.org/r/20200501155118.13380-1-oscar.carter@gmx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/gasket/gasket_core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/staging/gasket/gasket_core.c
+++ b/drivers/staging/gasket/gasket_core.c
@@ -926,6 +926,10 @@ do_map_region(const struct gasket_dev *g
 		gasket_get_bar_index(gasket_dev,
 				     (vma->vm_pgoff << PAGE_SHIFT) +
 				     driver_desc->legacy_mmap_address_offset);
+
+	if (bar_index < 0)
+		return DO_MAP_REGION_INVALID;
+
 	phys_base = gasket_dev->bar_data[bar_index].phys_base + phys_offset;
 	while (mapped_bytes < map_length) {
 		/*


