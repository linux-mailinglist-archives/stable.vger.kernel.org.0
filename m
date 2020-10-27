Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF8129C34D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1821531AbgJ0Rok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:44:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896816AbgJ0Oa7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:30:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B5BC20754;
        Tue, 27 Oct 2020 14:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809058;
        bh=iG/ZtFBtD9K8lVaaUApF8USyyuaAr5SEgS2eFeIPbV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMx9tBeS4G/zHto76H/EUPkdt3Ej0PvlkWjqI/I4fU/v9mpp3zPn5kb8P5Y1GdIty
         gMPxDsoaTcKGXdS5FUAphudidRjExiI16BtsVR0FJxQ2nqQ+4XN/U0cih3bglHl76I
         TbTybmulxXZZKD+z2vu9PufI2da7vFr/L/AKtfDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Salter <msalter@redhat.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/408] drivers/perf: thunderx2_pmu: Fix memory resource error handling
Date:   Tue, 27 Oct 2020 14:49:59 +0100
Message-Id: <20201027135457.894078663@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

[ Upstream commit 688494a407d1419a6b158c644b262c61cde39f48 ]

In tx2_uncore_pmu_init_dev(), a call to acpi_dev_get_resources() is used
to create a list _CRS resources which is searched for the device base
address. There is an error check following this:

   if (!rentry->res)
           return NULL

In no case, will rentry->res be NULL, so the test is useless. Even
if the test worked, it comes before the resource list memory is
freed. None of this really matters as long as the ACPI table has
the memory resource. Let's clean it up so that it makes sense and
will give a meaningful error should firmware leave out the memory
resource.

Fixes: 69c32972d593 ("drivers/perf: Add Cavium ThunderX2 SoC UNCORE PMU driver")
Signed-off-by: Mark Salter <msalter@redhat.com>
Link: https://lore.kernel.org/r/20200915204110.326138-2-msalter@redhat.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/thunderx2_pmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/thunderx2_pmu.c b/drivers/perf/thunderx2_pmu.c
index 9e1c3c7eeba9b..170ccb164c604 100644
--- a/drivers/perf/thunderx2_pmu.c
+++ b/drivers/perf/thunderx2_pmu.c
@@ -627,14 +627,17 @@ static struct tx2_uncore_pmu *tx2_uncore_pmu_init_dev(struct device *dev,
 	list_for_each_entry(rentry, &list, node) {
 		if (resource_type(rentry->res) == IORESOURCE_MEM) {
 			res = *rentry->res;
+			rentry = NULL;
 			break;
 		}
 	}
+	acpi_dev_free_resource_list(&list);
 
-	if (!rentry->res)
+	if (rentry) {
+		dev_err(dev, "PMU type %d: Fail to find resource\n", type);
 		return NULL;
+	}
 
-	acpi_dev_free_resource_list(&list);
 	base = devm_ioremap_resource(dev, &res);
 	if (IS_ERR(base)) {
 		dev_err(dev, "PMU type %d: Fail to map resource\n", type);
-- 
2.25.1



