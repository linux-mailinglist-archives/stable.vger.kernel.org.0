Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2EAA106EC8
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730964AbfKVK74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:59:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:51500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730961AbfKVK7z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:59:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C328B20706;
        Fri, 22 Nov 2019 10:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420395;
        bh=4NfQ9fxpNP+h0TZLuSv/Z7hVRrKUXXgL0ky5mqRXjFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PRED9w69/V6i+1WWcseoimSmw4KUjMpE0bLcgSB3jVhtMmVQrE4mhHKqOX2pkXORi
         cQARbwKc33O44y86yw7XNElsKEteWM4EZkRrv+eC/ZdwytdltA+JNZ4PZ4gts5oQ3j
         DUEs3GycEHXXe/nGxoC2HDDzsALhoFfPy2OKbf48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gustavo Pimentel <gustavo.pimentel@synopsys.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 075/220] tools: PCI: Fix compilation warnings
Date:   Fri, 22 Nov 2019 11:27:20 +0100
Message-Id: <20191122100917.694687117@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo Pimentel <gustavo.pimentel@synopsys.com>

[ Upstream commit fef31ecaaf2c5c54db85b35e893bf8abec96b93f ]

Current compilation produces the following warnings:

tools/pci/pcitest.c: In function 'run_test':
tools/pci/pcitest.c:56:9: warning: unused variable 'time'
[-Wunused-variable]
  double time;
         ^~~~
tools/pci/pcitest.c:55:25: warning: unused variable 'end'
[-Wunused-variable]
  struct timespec start, end;
                         ^~~
tools/pci/pcitest.c:55:18: warning: unused variable 'start'
[-Wunused-variable]
  struct timespec start, end;
                  ^~~~~
tools/pci/pcitest.c:146:1: warning: control reaches end of non-void
function [-Wreturn-type]
 }
 ^

Fix them:
 - remove unused variables
 - change function return from int to void, since it's not used

Signed-off-by: Gustavo Pimentel <gustavo.pimentel@synopsys.com>
[lorenzo.pieralisi@arm.com: rewrote the commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/pci/pcitest.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/pci/pcitest.c b/tools/pci/pcitest.c
index af146bb03b4df..ec4d51f3308b8 100644
--- a/tools/pci/pcitest.c
+++ b/tools/pci/pcitest.c
@@ -23,7 +23,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/ioctl.h>
-#include <time.h>
 #include <unistd.h>
 
 #include <linux/pcitest.h>
@@ -48,17 +47,15 @@ struct pci_test {
 	unsigned long	size;
 };
 
-static int run_test(struct pci_test *test)
+static void run_test(struct pci_test *test)
 {
 	long ret;
 	int fd;
-	struct timespec start, end;
-	double time;
 
 	fd = open(test->device, O_RDWR);
 	if (fd < 0) {
 		perror("can't open PCI Endpoint Test device");
-		return fd;
+		return;
 	}
 
 	if (test->barnum >= 0 && test->barnum <= 5) {
-- 
2.20.1



