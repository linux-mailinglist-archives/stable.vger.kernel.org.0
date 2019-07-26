Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A75768F1
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388533AbfGZNpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:45:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728143AbfGZNpM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:45:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEA7922CE9;
        Fri, 26 Jul 2019 13:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148711;
        bh=cljafivhS5SgwGmwbvwM7kjh7jlUt6mW6AydIjbkjVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vf8GA85BVfYGM/4r/wlVn1CJUcPwOUoyEpnaEL5paQKmvdcn/Ug+bKiocMV5YAl6b
         C3V555TORvqXmu/zo2Yw1gUaeUu7+Cy4WM8jSFJBM7DD8JQ+8FBbEsk4rNPpjs27BA
         jWPHjnO+dtzfqsyQsk+MCHgDEHUPBqU4+ydOSby8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rodolfo Giometti <giometti@enneenne.com>,
        Greg KH <greg@kroah.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 24/30] drivers/pps/pps.c: clear offset flags in PPS_SETPARAMS ioctl
Date:   Fri, 26 Jul 2019 09:44:26 -0400
Message-Id: <20190726134432.12993-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726134432.12993-1-sashal@kernel.org>
References: <20190726134432.12993-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miroslav Lichvar <mlichvar@redhat.com>

[ Upstream commit 5515e9a6273b8c02034466bcbd717ac9f53dab99 ]

The PPS assert/clear offset corrections are set by the PPS_SETPARAMS
ioctl in the pps_ktime structs, which also contain flags.  The flags are
not initialized by applications (using the timepps.h header) and they
are not used by the kernel for anything except returning them back in
the PPS_GETPARAMS ioctl.

Set the flags to zero to make it clear they are unused and avoid leaking
uninitialized data of the PPS_SETPARAMS caller to other applications
that have a read access to the PPS device.

Link: http://lkml.kernel.org/r/20190702092251.24303-1-mlichvar@redhat.com
Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Cc: Greg KH <greg@kroah.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pps/pps.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 2f07cd615665..76ae38450aea 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -129,6 +129,14 @@ static long pps_cdev_ioctl(struct file *file,
 			pps->params.mode |= PPS_CANWAIT;
 		pps->params.api_version = PPS_API_VERS;
 
+		/*
+		 * Clear unused fields of pps_kparams to avoid leaking
+		 * uninitialized data of the PPS_SETPARAMS caller via
+		 * PPS_GETPARAMS
+		 */
+		pps->params.assert_off_tu.flags = 0;
+		pps->params.clear_off_tu.flags = 0;
+
 		spin_unlock_irq(&pps->lock);
 
 		break;
-- 
2.20.1

