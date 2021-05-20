Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90A238A86E
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237299AbhETKu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237208AbhETKr2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:47:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ED6161CAF;
        Thu, 20 May 2021 09:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504697;
        bh=ElMWXytHLhIqi64Gk7kpZGsahtsBL1G92TPQA90NMtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z4+JYn42S9Yiz1UR+OFR6W6SZOM0xGruLNbW+cYo2fFgP7/Qd6WGZgB80lkUPuQFA
         le/SurN0n+7frz+eH2pspm2CMeHk9Q9l1J3yXnpq//EB0ENgiZDT30KkLZYoKSevs9
         b27Jri5ll9cviDEUbUllfWTWIFSy1MrvNsQrL5E8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Langsdorf <mlangsdo@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.9 009/240] ACPI: custom_method: fix a possible memory leak
Date:   Thu, 20 May 2021 11:20:01 +0200
Message-Id: <20210520092108.917841282@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Langsdorf <mlangsdo@redhat.com>

commit 1cfd8956437f842836e8a066b40d1ec2fc01f13e upstream.

In cm_write(), if the 'buf' is allocated memory but not fully consumed,
it is possible to reallocate the buffer without freeing it by passing
'*ppos' as 0 on a subsequent call.

Add an explicit kfree() before kzalloc() to prevent the possible memory
leak.

Fixes: 526b4af47f44 ("ACPI: Split out custom_method functionality into an own driver")
Signed-off-by: Mark Langsdorf <mlangsdo@redhat.com>
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/custom_method.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/acpi/custom_method.c
+++ b/drivers/acpi/custom_method.c
@@ -37,6 +37,8 @@ static ssize_t cm_write(struct file *fil
 				   sizeof(struct acpi_table_header)))
 			return -EFAULT;
 		uncopied_bytes = max_size = table.length;
+		/* make sure the buf is not allocated */
+		kfree(buf);
 		buf = kzalloc(max_size, GFP_KERNEL);
 		if (!buf)
 			return -ENOMEM;


