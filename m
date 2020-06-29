Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52A820D725
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732301AbgF2T1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:27:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732663AbgF2TZn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E99AC2540A;
        Mon, 29 Jun 2020 15:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445355;
        bh=VC0RHqcVsa2hE+dmNr1/xgwrg5FMctxrbBQx02b4w1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dLNjKlVhlNc4uFRMiw0cmwyaR7eVRPBVQE7PdMU2mMiQCyxzzbI0w4XvxDqozRet0
         Aw5Wi0OkamoB1VtpUK4WmM7wG1rZppuTxWV1ufR9K0uwNHba66GnvfGKOJgNJQnmb9
         jVxs0YBCfqaWbxFJeZTURhqUuPvQFnYyKadreQRs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Daniel Scheller <d.scheller@gmx.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 113/191] media: dvb_frontend: be sure to init dvb_frontend_handle_ioctl() return code
Date:   Mon, 29 Jun 2020 11:38:49 -0400
Message-Id: <20200629154007.2495120-114-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

commit a9cb97c3e628902e37583d8a40bb28cf76522cf1 upstream

As smatch warned:
	drivers/media/dvb-core/dvb_frontend.c:2468 dvb_frontend_handle_ioctl() error: uninitialized symbol 'err'.

The ioctl handler actually got a regression here: before changeset
d73dcf0cdb95 ("media: dvb_frontend: cleanup ioctl handling logic"),
the code used to return -EOPNOTSUPP if an ioctl handler was not
implemented on a driver. After the change, it may return a random
value.

Fixes: d73dcf0cdb95 ("media: dvb_frontend: cleanup ioctl handling logic")

Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Tested-by: Daniel Scheller <d.scheller@gmx.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index a9ae9e5092050..6f9ee78a18703 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2113,7 +2113,7 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int i, err;
+	int i, err = -EOPNOTSUPP;
 
 	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
@@ -2148,6 +2148,7 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 			}
 		}
 		kfree(tvp);
+		err = 0;
 		break;
 	}
 	case FE_GET_PROPERTY: {
@@ -2198,6 +2199,7 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 			return -EFAULT;
 		}
 		kfree(tvp);
+		err = 0;
 		break;
 	}
 
-- 
2.25.1

