Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7786B12F185
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 00:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgABWLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:11:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:49344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgABWLV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:11:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91B6C21D7D;
        Thu,  2 Jan 2020 22:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003081;
        bh=JrOqbF6YDPDMz5f+9FqIzqyRoV/6CWGrgcynEh5Fehw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VcP2dqXUsRr1nwcT+0xQFzQJVtZcwfw9kXjj9LkELOmqXOqfnRFdTbqKlKnIRq9zv
         Fe0L84dxFlgsUEhprjDbK29+87tE4EH0y45ZGbS464FA0CR39B7j/i1oD7paMmoWCo
         96a4WisZnpSQG3UF0SMo1+OixahlrViy3EBSzcB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vaibhav Jain <vaibhav@linux.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 012/191] powerpc/papr_scm: Fix an off-by-one check in papr_scm_meta_{get, set}
Date:   Thu,  2 Jan 2020 23:04:54 +0100
Message-Id: <20200102215831.033993270@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 61883291defc..ee07d0718bf1 100644
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



