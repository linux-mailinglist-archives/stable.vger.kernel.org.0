Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D1F29B913
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802186AbgJ0Pp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801078AbgJ0Pi6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:38:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B76C52225E;
        Tue, 27 Oct 2020 15:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813138;
        bh=YGz0kRvMp3a153du/qEtZ/uEOueWubCMhTSqda6JJSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QIwZwnIsnDL2VTdUTAz1IfOq9l9etNsmj9NbQD3Yvq4Qt351FdAt7W4eyb2nQ3EDu
         oPjfEzqGtEkrrWvstydm1j57Uuu4qJG670Guyr92emBhh9difPxc1irPEuz+b8lBbF
         1pHqt34Fnw3c+7mI05pSfS8jFg1s/sIICiEQfPzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vaibhav Jain <vaibhav@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 451/757] powerpc/papr_scm: Fix warning triggered by perf_stats_show()
Date:   Tue, 27 Oct 2020 14:51:41 +0100
Message-Id: <20201027135511.690664716@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vaibhav Jain <vaibhav@linux.ibm.com>

[ Upstream commit ca78ef2f08ccfa29b711d644964cdf9d7ace15e5 ]

A warning is reported by the kernel in case perf_stats_show() returns
an error code. The warning is of the form below:

 papr_scm ibm,persistent-memory:ibm,pmemory@44100001:
 	  Failed to query performance stats, Err:-10
 dev_attr_show: perf_stats_show+0x0/0x1c0 [papr_scm] returned bad count
 fill_read_buffer: dev_attr_show+0x0/0xb0 returned bad count

On investigation it looks like that the compiler is silently
truncating the return value of drc_pmem_query_stats() from 'long' to
'int', since the variable used to store the return code 'rc' is an
'int'. This truncated value is then returned back as a 'ssize_t' back
from perf_stats_show() to 'dev_attr_show()' which thinks of it as a
large unsigned number and triggers this warning..

To fix this we update the type of variable 'rc' from 'int' to
'ssize_t' that prevents the compiler from truncating the return value
of drc_pmem_query_stats() and returning correct signed value back from
perf_stats_show().

Fixes: 2d02bf835e57 ("powerpc/papr_scm: Fetch nvdimm performance stats from PHYP")
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200912081451.66225-1-vaibhav@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/papr_scm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index a88a707a608aa..5493bc847bd08 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -785,7 +785,8 @@ static int papr_scm_ndctl(struct nvdimm_bus_descriptor *nd_desc,
 static ssize_t perf_stats_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
 {
-	int index, rc;
+	int index;
+	ssize_t rc;
 	struct seq_buf s;
 	struct papr_scm_perf_stat *stat;
 	struct papr_scm_perf_stats *stats;
@@ -820,7 +821,7 @@ static ssize_t perf_stats_show(struct device *dev,
 
 free_stats:
 	kfree(stats);
-	return rc ? rc : seq_buf_used(&s);
+	return rc ? rc : (ssize_t)seq_buf_used(&s);
 }
 DEVICE_ATTR_ADMIN_RO(perf_stats);
 
-- 
2.25.1



