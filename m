Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A76281991B2
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731169AbgCaJKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:10:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731147AbgCaJKN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:10:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A34A2072E;
        Tue, 31 Mar 2020 09:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645812;
        bh=rAT7k9QfL/uRKMskwddcHA1BKZ5ENz8y42pgaEwLH+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z09UONIayBqSaGIQp91fFrgOridDgs+gBP12ULhbczpzOXhId9dKt7KXJ7e7tz2ko
         3oyS466P7VqXk0Zyn+Rdh8xsGqCmVj5uqdQO720zdTezbqUWEfgvS3bxlVyB6WEjjU
         5KuXy7SAqjsnuhxrP0WeRzpOgQpqyfdTEFL/XCVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.5 157/170] staging: kpc2000: prevent underflow in cpld_reconfigure()
Date:   Tue, 31 Mar 2020 10:59:31 +0200
Message-Id: <20200331085439.631756439@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 72db61d7d17a475d3cc9de1a7c871d518fcd82f0 upstream.

This function should not allow negative values of "wr_val".  If
negatives are allowed then capping the upper bound at 7 is
meaningless.  Let's make it unsigned.

Fixes: 7dc7967fc39a ("staging: kpc2000: add initial set of Daktronics drivers")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200224103325.hrxdnaeqsthplu42@kili.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/kpc2000/kpc2000/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/kpc2000/kpc2000/core.c
+++ b/drivers/staging/kpc2000/kpc2000/core.c
@@ -110,10 +110,10 @@ static ssize_t cpld_reconfigure(struct d
 				const char *buf, size_t count)
 {
 	struct kp2000_device *pcard = dev_get_drvdata(dev);
-	long wr_val;
+	unsigned long wr_val;
 	int rv;
 
-	rv = kstrtol(buf, 0, &wr_val);
+	rv = kstrtoul(buf, 0, &wr_val);
 	if (rv < 0)
 		return rv;
 	if (wr_val > 7)


