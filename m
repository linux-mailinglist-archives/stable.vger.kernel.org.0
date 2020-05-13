Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99F71D0F2D
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732712AbgEMJqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:46:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732689AbgEMJqq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:46:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62FB1206F5;
        Wed, 13 May 2020 09:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363205;
        bh=FR8Ifg9rP8tzSzi0f8DEsEecajjqrvZMp0gu9VxDTkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cP1VEZuVVxRB8UMZfiX2oe7mjhnbF5wv3N8UVboLxibiz37jxDH6Wy8iqTCPfNfkP
         4BHCfnfzyqG1nf0VrhXx4CLjxIiveBCjqyFSg9Lw7e2yKYJGORK9Ajt3HxjqHafLDb
         j2F44J+oe7BVw0NuN3CbE4Vr0n3M51gaDP0BkSMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oscar Carter <oscar.carter@gmx.com>,
        Richard Yeh <rcy@google.com>
Subject: [PATCH 4.19 29/48] staging: gasket: Check the return value of gasket_get_bar_index()
Date:   Wed, 13 May 2020 11:44:55 +0200
Message-Id: <20200513094358.457452609@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094351.100352960@linuxfoundation.org>
References: <20200513094351.100352960@linuxfoundation.org>
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
@@ -933,6 +933,10 @@ do_map_region(const struct gasket_dev *g
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


