Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D7C2C08ED
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388285AbgKWND0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:03:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732395AbgKWMvd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:51:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A986E204EF;
        Mon, 23 Nov 2020 12:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135892;
        bh=jsySVGJFKPxFYzkq3/Op67mvaJSdKrPhqstmM51QoWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZGlv5Mt1+fDZMpatAWxMecsA6qi++VaDtxyWsBnW0cLz05pLmPUUYhQpO0gm39BB/
         DdYPTtahe+zCTlC1pq+AFiuaYcgOY41ZP596XvCUsc6p3JQhRstT7ch1J1SVePIobb
         sGslL4c6pPT69h6Tstjki9+YHmBhyI7Wuim8p+m8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Richter <tmricht@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.9 233/252] s390/cpum_sf.c: fix file permission for cpum_sfb_size
Date:   Mon, 23 Nov 2020 13:23:03 +0100
Message-Id: <20201123121846.818059376@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
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
@@ -2228,4 +2228,4 @@ out:
 }
 
 arch_initcall(init_cpum_sampling_pmu);
-core_param(cpum_sfb_size, CPUM_SF_MAX_SDB, sfb_size, 0640);
+core_param(cpum_sfb_size, CPUM_SF_MAX_SDB, sfb_size, 0644);


