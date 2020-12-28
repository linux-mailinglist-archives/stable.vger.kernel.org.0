Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943A72E41BB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438297AbgL1OHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:07:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:40908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437986AbgL1OGU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:06:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF60020715;
        Mon, 28 Dec 2020 14:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164339;
        bh=FRjXZpX3AwlKQ+iJhFp13U9eRVGJiB23t0LAqZjvKq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FD5LRXGvofZEKEMhnSotOiRsWzLrU0fNZLYQ4MlX4oe2S6BCQIgfqRkPLf4bOg5V7
         +oAiUXZ8I83+wOA4XW0ox51/SEkrlqeujMgNnjb8YyIz4iYFBepDoLtHFtwBZzenl2
         ZrQRW4cQPcqLHuUXWd4F0n7pRp2v9B6SYS2ka670=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/717] drm/amdkfd: Put ACPI table after using it
Date:   Mon, 28 Dec 2020 13:41:52 +0100
Message-Id: <20201228125026.423899153@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hanjun Guo <guohanjun@huawei.com>

[ Upstream commit c4cb773c702be5519442c8375a6476d08fe2cb46 ]

The acpi_get_table() should be coupled with acpi_put_table() if
the mapped table is not used at runtime to release the table
mapping which can prevent the memory leak.

In kfd_create_crat_image_acpi(), crat_table is copied to pcrat_image,
and in kfd_create_vcrat_image_cpu(), the acpi_table is only used to
get the OEM information, so those two table mappings need to be released
after using it.

Fixes: 174de876d6d0 ("drm/amdkfd: Group up CRAT related functions")
Fixes: 520b8fb755cc ("drm/amdkfd: Add topology support for CPUs")
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
index 3de5e14c5ae31..d7f67620f57ba 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -774,6 +774,7 @@ int kfd_create_crat_image_acpi(void **crat_image, size_t *size)
 	struct acpi_table_header *crat_table;
 	acpi_status status;
 	void *pcrat_image;
+	int rc = 0;
 
 	if (!crat_image)
 		return -EINVAL;
@@ -798,14 +799,17 @@ int kfd_create_crat_image_acpi(void **crat_image, size_t *size)
 	}
 
 	pcrat_image = kvmalloc(crat_table->length, GFP_KERNEL);
-	if (!pcrat_image)
-		return -ENOMEM;
+	if (!pcrat_image) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	memcpy(pcrat_image, crat_table, crat_table->length);
 	*crat_image = pcrat_image;
 	*size = crat_table->length;
-
-	return 0;
+out:
+	acpi_put_table(crat_table);
+	return rc;
 }
 
 /* Memory required to create Virtual CRAT.
@@ -988,6 +992,7 @@ static int kfd_create_vcrat_image_cpu(void *pcrat_image, size_t *size)
 				CRAT_OEMID_LENGTH);
 		memcpy(crat_table->oem_table_id, acpi_table->oem_table_id,
 				CRAT_OEMTABLEID_LENGTH);
+		acpi_put_table(acpi_table);
 	}
 	crat_table->total_entries = 0;
 	crat_table->num_domains = 0;
-- 
2.27.0



