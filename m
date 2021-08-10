Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AFD3E81C3
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbhHJSCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233662AbhHJSAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:00:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7D6E61390;
        Tue, 10 Aug 2021 17:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617605;
        bh=Z0qU4/2yKzhC+XXVvaVOFrD17qTEYzJulLpeR9Dy9Yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LLlcabRwuMkIdRsRzlVx3kM81JmRNnPDxI40Y9C7FMtSrOp/Pp5j87S5UjOmms5UE
         jX1sjYI226+BqY6htyW+7yY6WUPXF4sMGAUZVRAoI1dNB+SmWpr/ptPJOD0Dl31Ddb
         tikoAruZs2QLcroW+ilpYlbFOydpn4RVX3xFg9YM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Yilun <yilun.xu@intel.com>,
        Wu Hao <hao.wu@intel.com>, Kajol Jain <kjain@linux.ibm.com>,
        Moritz Fischer <mdf@kernel.org>
Subject: [PATCH 5.13 131/175] fpga: dfl: fme: Fix cpu hotplug issue in performance reporting
Date:   Tue, 10 Aug 2021 19:30:39 +0200
Message-Id: <20210810173005.266339438@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kajol Jain <kjain@linux.ibm.com>

commit ec6446d5304b3c3dd692a1e244df7e40bbb5af36 upstream.

The performance reporting driver added cpu hotplug
feature but it didn't add pmu migration call in cpu
offline function.
This can create an issue incase the current designated
cpu being used to collect fme pmu data got offline,
as based on current code we are not migrating fme pmu to
new target cpu. Because of that perf will still try to
fetch data from that offline cpu and hence we will not
get counter data.

Patch fixed this issue by adding pmu_migrate_context call
in fme_perf_offline_cpu function.

Fixes: 724142f8c42a ("fpga: dfl: fme: add performance reporting support")
Cc: stable@vger.kernel.org
Tested-by: Xu Yilun <yilun.xu@intel.com>
Acked-by: Wu Hao <hao.wu@intel.com>
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Signed-off-by: Moritz Fischer <mdf@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/dfl-fme-perf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/fpga/dfl-fme-perf.c
+++ b/drivers/fpga/dfl-fme-perf.c
@@ -953,6 +953,8 @@ static int fme_perf_offline_cpu(unsigned
 		return 0;
 
 	priv->cpu = target;
+	perf_pmu_migrate_context(&priv->pmu, cpu, target);
+
 	return 0;
 }
 


