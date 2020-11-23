Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29752C0AD8
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730582AbgKWM32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:29:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:39936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730589AbgKWM30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:29:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E828E20728;
        Mon, 23 Nov 2020 12:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134564;
        bh=r/hVYxxV5KNm6KWW6ckHa52dmxcRaifvQfh2Ev3F/Zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lbjuVUMF9pyhF3e2KKueLcxSyZ5296C2PJhsJ+3XfO/CAlmuHr4690KXrbrQeA3hg
         xW9VlKPQMSgWghNq+9+CH22yBcQ2+uiQ0W7CnnTCzR46wRzO2E+v4O5T9z69paTQay
         cWR+Lq1dwHxa+zdgdOifr+f1zRhXKP7EMBkde0gs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Richter <tmricht@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 4.14 58/60] s390/cpum_sf.c: fix file permission for cpum_sfb_size
Date:   Mon, 23 Nov 2020 13:22:40 +0100
Message-Id: <20201123121807.853909478@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.028396732@linuxfoundation.org>
References: <20201123121805.028396732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

commit 78d732e1f326f74f240d416af9484928303d9951 upstream.

This file is installed by the s390 CPU Measurement sampling
facility device driver to export supported minimum and
maximum sample buffer sizes.
This file is read by lscpumf tool to display the details
of the device driver capabilities. The lscpumf tool might
be invoked by a non-root user. In this case it does not
print anything because the file contents can not be read.

Fix this by allowing read access for all users. Reading
the file contents is ok, changing the file contents is
left to the root user only.

For further reference and details see:
 [1] https://github.com/ibm-s390-tools/s390-tools/issues/97

Fixes: 69f239ed335a ("s390/cpum_sf: Dynamically extend the sampling buffer if overflows occur")
Cc: <stable@vger.kernel.org> # 3.14
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/perf_cpum_sf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -1662,4 +1662,4 @@ out:
 	return err;
 }
 arch_initcall(init_cpum_sampling_pmu);
-core_param(cpum_sfb_size, CPUM_SF_MAX_SDB, sfb_size, 0640);
+core_param(cpum_sfb_size, CPUM_SF_MAX_SDB, sfb_size, 0644);


