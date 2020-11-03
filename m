Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C347D2A3927
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgKCBUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:20:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:35428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728147AbgKCBUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:20:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50B0B2244C;
        Tue,  3 Nov 2020 01:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366434;
        bh=2EPBhjUcKwhQAiBveff2wv2l0sDCS99DGzUfWWYOiLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IUsH8d7hp7DC1/7EqKk8ULeybgt+VhPdU91XdTcMBJb2vDVS13mpFcE0YBVrNakYQ
         BHRKjD+j/jAl5Eo77+6c1glG8ATOQ6tcd1JXkFnQ1bGR0rKgUBrMR/cfRnwBhvpNjc
         4fGQ9hCv5jCK+1C9YKq3r0Cc+gPlrj4BeSqyzqNo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-nvdimm@lists.01.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 20/24] ACPI: NFIT: Fix comparison to '-ENXIO'
Date:   Mon,  2 Nov 2020 20:20:03 -0500
Message-Id: <20201103012007.183429-20-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103012007.183429-1-sashal@kernel.org>
References: <20201103012007.183429-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 12d980aafc5ff..9d78f29cf9967 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1553,7 +1553,7 @@ static ssize_t format1_show(struct device *dev,
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

