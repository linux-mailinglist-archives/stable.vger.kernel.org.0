Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E5912F128
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgABW6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:58:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:56370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728074AbgABWP2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:15:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7078322314;
        Thu,  2 Jan 2020 22:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003327;
        bh=uj2F/Bn3vJZFnGw988xr2Yfv8vMIVr6SR5KDEcBLs9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=emamTCToYjfXf+dfD0P32unsBwTkph1qk9sbERKjOEuUrwxXAthDBXhNadaBpYYbk
         /RYxkXv0uDgqKHFi4RG0a+iADPleAvr/laqfUIKAWGyyKPuJHAhhWCO7Y0gVzL/ZAn
         6C6APMg4JZhB0ALBKz0+QvqtCwDieKoOI/XELfcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maurizio Lombardi <mlombard@redhat.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/191] scsi: scsi_debug: num_tgts must be >= 0
Date:   Thu,  2 Jan 2020 23:06:11 +0100
Message-Id: <20200102215839.473237715@linuxfoundation.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit aa5334c4f3014940f11bf876e919c956abef4089 ]

Passing the parameter "num_tgts=-1" will start an infinite loop that
exhausts the system memory

Link: https://lore.kernel.org/r/20191115163727.24626-1-mlombard@redhat.com
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d323523f5f9d..32965ec76965 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5263,6 +5263,11 @@ static int __init scsi_debug_init(void)
 		return -EINVAL;
 	}
 
+	if (sdebug_num_tgts < 0) {
+		pr_err("num_tgts must be >= 0\n");
+		return -EINVAL;
+	}
+
 	if (sdebug_guard > 1) {
 		pr_err("guard must be 0 or 1\n");
 		return -EINVAL;
-- 
2.20.1



