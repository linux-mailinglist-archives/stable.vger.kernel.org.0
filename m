Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD49545C600
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350708AbhKXOEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:04:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:48876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245166AbhKXOAz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:00:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1150632E4;
        Wed, 24 Nov 2021 13:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759382;
        bh=cw1RtDyMxMLEBiBDx79B+Nz3HhjXEgotB9mhf9BNzBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JAUSg2Wk6qkTLi0YAcIz8/usPX2DZd6pr+dRqYKdGnNz19c5NfM/74rpy78dUH9Ig
         NSVqIq6Dtx6eDAx39hqBcZk6TFwJkAP8Ra2Z8l1LRBkzckElLKgomfPcyCvz8ARx+7
         JmTLWL44Z8LSZDrOq5XBV/h703HEsz6iCK4ydbvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.15 221/279] s390/dump: fix copying to user-space of swapped kdump oldmem
Date:   Wed, 24 Nov 2021 12:58:28 +0100
Message-Id: <20211124115726.369085216@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Egorenkov <egorenar@linux.ibm.com>

commit 3b90954419d4c05651de9cce6d7632bcf6977678 upstream.

This commit fixes a bug introduced by commit e9e7870f90e3 ("s390/dump:
introduce boot data 'oldmem_data'").
OLDMEM_BASE was mistakenly replaced by oldmem_data.size instead of
oldmem_data.start.

This bug caused the following error during kdump:
kdump.sh[878]: No program header covering vaddr 0x3434f5245found kexec bug?

Fixes: e9e7870f90e3 ("s390/dump: introduce boot data 'oldmem_data'")
Cc: stable@vger.kernel.org # 5.15+
Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Reviewed-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/crash_dump.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -191,8 +191,8 @@ static int copy_oldmem_user(void __user
 				return rc;
 		} else {
 			/* Check for swapped kdump oldmem areas */
-			if (oldmem_data.start && from - oldmem_data.size < oldmem_data.size) {
-				from -= oldmem_data.size;
+			if (oldmem_data.start && from - oldmem_data.start < oldmem_data.size) {
+				from -= oldmem_data.start;
 				len = min(count, oldmem_data.size - from);
 			} else if (oldmem_data.start && from < oldmem_data.size) {
 				len = min(count, oldmem_data.size - from);


