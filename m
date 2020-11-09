Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289C12ABBF4
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731215AbgKINHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:07:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:59708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730272AbgKINHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:07:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84A0721D46;
        Mon,  9 Nov 2020 13:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927219;
        bh=D9MdidTb1f6jW5+wfj5jVQvlNROQTt2Eti39U2kxRbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jWAjKVAHfby8JKWb0ATBGSHo3LyBHo1IldiHjq/4QZ5CJD6U+6CqDB5JiUs7hLdru
         UePr4Nfme3k2wMrQ8YsUwkcd4yc9ulgr23LDJXDrKvkYS+5OLCom01ArWkGihgrVX8
         cBmTA2w+oWSJbnJk2BZjO2lYRk0SFwxfxiDJ+L04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 34/48] ACPI: NFIT: Fix comparison to -ENXIO
Date:   Mon,  9 Nov 2020 13:55:43 +0100
Message-Id: <20201109125018.444264155@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125016.734107741@linuxfoundation.org>
References: <20201109125016.734107741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 85f971b65a692b68181438e099b946cc06ed499b ]

Initial value of rc is '-ENXIO', and we should
use the initial value to check it.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
[ rjw: Subject edit ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/nfit/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 68205002f561e..20fd197ef74cc 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1273,7 +1273,7 @@ static ssize_t format1_show(struct device *dev,
 					le16_to_cpu(nfit_dcr->dcr->code));
 			break;
 		}
-		if (rc != ENXIO)
+		if (rc != -ENXIO)
 			break;
 	}
 	mutex_unlock(&acpi_desc->init_mutex);
-- 
2.27.0



