Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9C820D729
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbgF2T1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:27:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732666AbgF2TZn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E332825405;
        Mon, 29 Jun 2020 15:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445352;
        bh=siDFv2wBYonOfCEnGvScoWYFodnBr3X6yc4XrIJKW9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=omi0j0rzDn1rUsCn//77wA55nGr8hG4dws3yBWHPYZ9n2u6d5rznIJeuZCSClYpKI
         1U+csIgX8ggK2rrXpLzT5LytVrd9rcyxR9hvT9kdfjySNdReReZ4NEBf5yaVLl1TQQ
         RaWgO4Mpqlgioxw5hbLbaFYS4pWwUA0yHyLympvQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 110/191] media: dvb_frontend: better document the -EPERM condition
Date:   Mon, 29 Jun 2020 11:38:46 -0400
Message-Id: <20200629154007.2495120-111-sashal@kernel.org>
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

commit da5516b5e81d45a96291823620f6c820178dc055 upstream

Two readonly ioctls can't be allowed if the frontend device
is opened in read only mode. Explain why.

Reviewed by: Shuah Khan <shuahkh@osg.samsung.com>

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index a7ba8e200b677..673cefb7230cb 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1925,9 +1925,23 @@ static int dvb_frontend_ioctl(struct file *file, unsigned int cmd, void *parg)
 		return -ENODEV;
 	}
 
-	if ((file->f_flags & O_ACCMODE) == O_RDONLY &&
-	    (_IOC_DIR(cmd) != _IOC_READ || cmd == FE_GET_EVENT ||
-	     cmd == FE_DISEQC_RECV_SLAVE_REPLY)) {
+	/*
+	 * If the frontend is opened in read-only mode, only the ioctls
+	 * that don't interfere with the tune logic should be accepted.
+	 * That allows an external application to monitor the DVB QoS and
+	 * statistics parameters.
+	 *
+	 * That matches all _IOR() ioctls, except for two special cases:
+	 *   - FE_GET_EVENT is part of the tuning logic on a DVB application;
+	 *   - FE_DISEQC_RECV_SLAVE_REPLY is part of DiSEqC 2.0
+	 *     setup
+	 * So, those two ioctls should also return -EPERM, as otherwise
+	 * reading from them would interfere with a DVB tune application
+	 */
+	if ((file->f_flags & O_ACCMODE) == O_RDONLY
+	    && (_IOC_DIR(cmd) != _IOC_READ
+		|| cmd == FE_GET_EVENT
+		|| cmd == FE_DISEQC_RECV_SLAVE_REPLY)) {
 		up(&fepriv->sem);
 		return -EPERM;
 	}
-- 
2.25.1

