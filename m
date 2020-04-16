Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86951AC897
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394949AbgDPPLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:11:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729119AbgDPNuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:50:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8674620786;
        Thu, 16 Apr 2020 13:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045019;
        bh=lFhx4Pwgt/IIWG+kD1mKhR5l8kclKGuuGvtVWpV6au4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zT0tQHVvR612Mk80UTb1cx3orxP7UiIi53uIIKVHx8pkbLjS+XoSJhQh5rQvtUpjV
         76YMUE9jRTXr02y0Vo8H46YyM944MNzLm/YynqYY4ayV66vHZ0toa213Rlj7mMhAuV
         /giyZluQKDwaq4vo5Son6wb8PRr8UqR9AIN33mtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Mueller <mimu@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.4 196/232] s390/diag: fix display of diagnose call statistics
Date:   Thu, 16 Apr 2020 15:24:50 +0200
Message-Id: <20200416131339.718575125@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Mueller <mimu@linux.ibm.com>

commit 6c7c851f1b666a8a455678a0b480b9162de86052 upstream.

Show the full diag statistic table and not just parts of it.

The issue surfaced in a KVM guest with a number of vcpus
defined smaller than NR_DIAG_STAT.

Fixes: 1ec2772e0c3c ("s390/diag: add a statistic for diagnose calls")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/diag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kernel/diag.c
+++ b/arch/s390/kernel/diag.c
@@ -84,7 +84,7 @@ static int show_diag_stat(struct seq_fil
 
 static void *show_diag_stat_start(struct seq_file *m, loff_t *pos)
 {
-	return *pos <= nr_cpu_ids ? (void *)((unsigned long) *pos + 1) : NULL;
+	return *pos <= NR_DIAG_STAT ? (void *)((unsigned long) *pos + 1) : NULL;
 }
 
 static void *show_diag_stat_next(struct seq_file *m, void *v, loff_t *pos)


