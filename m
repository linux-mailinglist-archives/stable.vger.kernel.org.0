Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68BD911B7B6
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731035AbfLKPMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:12:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:32826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731031AbfLKPMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E30CC2467F;
        Wed, 11 Dec 2019 15:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077121;
        bh=rjnKi9c9bSp4W5HmEkgKIOW16NgRTdaQnTGDcA+RRW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kK2N/LTxjaBNjmMbOrWFKp44u7rlRa1B7OHk3hbnKHhuCbOKO+h9IoqLAtNid1oNG
         j13bJ29wpAyEuxYW2eGjSZq91dnYnMzor2+zL8tDHi+WXj5pcuQ/5aDbJhgdc3MthO
         V51wEEuiWa/iif2n5hsSPAAVDTcUTObdHIwszfBE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vaibhav Jain <vaibhav@linux.ibm.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 010/134] powerpc/papr_scm: Fix an off-by-one check in papr_scm_meta_{get, set}
Date:   Wed, 11 Dec 2019 10:09:46 -0500
Message-Id: <20191211151150.19073-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vaibhav Jain <vaibhav@linux.ibm.com>

[ Upstream commit 612ee81b9461475b5a5612c2e8d71559dd3c7920 ]

A validation check to prevent out of bounds read/write inside
functions papr_scm_meta_{get,set}() is off-by-one that prevent reads
and writes to the last byte of the label area.

This bug manifests as a failure to probe a dimm when libnvdimm is
unable to read the entire config-area as advertised by
ND_CMD_GET_CONFIG_SIZE. This usually happens when there are large
number of namespaces created in the region backed by the dimm and the
label-index spans max possible config-area. An error of the form below
usually reported in the kernel logs:

[  255.293912] nvdimm: probe of nmem0 failed with error -22

The patch fixes these validation checks there by letting libnvdimm
access the entire config-area.

Fixes: 53e80bd042773('powerpc/nvdimm: Add support for multibyte read/write for metadata')
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190927062002.3169-1-vaibhav@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/papr_scm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index 61883291defc3..ee07d0718bf1a 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -152,7 +152,7 @@ static int papr_scm_meta_get(struct papr_scm_priv *p,
 	int len, read;
 	int64_t ret;
 
-	if ((hdr->in_offset + hdr->in_length) >= p->metadata_size)
+	if ((hdr->in_offset + hdr->in_length) > p->metadata_size)
 		return -EINVAL;
 
 	for (len = hdr->in_length; len; len -= read) {
@@ -206,7 +206,7 @@ static int papr_scm_meta_set(struct papr_scm_priv *p,
 	__be64 data_be;
 	int64_t ret;
 
-	if ((hdr->in_offset + hdr->in_length) >= p->metadata_size)
+	if ((hdr->in_offset + hdr->in_length) > p->metadata_size)
 		return -EINVAL;
 
 	for (len = hdr->in_length; len; len -= wrote) {
-- 
2.20.1

