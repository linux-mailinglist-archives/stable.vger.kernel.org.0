Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 990E910BBEF
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732870AbfK0VMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:12:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:44058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730993AbfK0VMt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:12:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 357A121774;
        Wed, 27 Nov 2019 21:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889168;
        bh=QAXlEx89V/eFxi+XF99MfbEdBLMZWohg5ORD/1mXyYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r9h9xqB4BitE15T2rwNAQ9dlID5OyTkVsa+vLSI345otkC22kU8KYgLS6h4gRxdeQ
         q8a7bYzeS6QqtcP0nS2342JSbIEXDMdr/vkyR/0kMbhUJRubLL1YnBsXw+0mn57huN
         6IOyL2JgWShKFsVLl6DPIS5RRGeg2FAeMMYMMy70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vito Caputo <vcaputo@pengaru.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 07/66] Revert "dm crypt: use WQ_HIGHPRI for the IO and crypt workqueues"
Date:   Wed, 27 Nov 2019 21:32:02 +0100
Message-Id: <20191127202643.853205365@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
References: <20191127202632.536277063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

commit f612b2132db529feac4f965f28a1b9258ea7c22b upstream.

This reverts commit a1b89132dc4f61071bdeaab92ea958e0953380a1.

Revert required hand-patching due to subsequent changes that were
applied since commit a1b89132dc4f61071bdeaab92ea958e0953380a1.

Requires: ed0302e83098d ("dm crypt: make workqueue names device-specific")
Cc: stable@vger.kernel.org
Bug: https://bugzilla.kernel.org/show_bug.cgi?id=199857
Reported-by: Vito Caputo <vcaputo@pengaru.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-crypt.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2700,21 +2700,18 @@ static int crypt_ctr(struct dm_target *t
 	}
 
 	ret = -ENOMEM;
-	cc->io_queue = alloc_workqueue("kcryptd_io/%s",
-				       WQ_HIGHPRI | WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
-				       1, devname);
+	cc->io_queue = alloc_workqueue("kcryptd_io/%s", WQ_MEM_RECLAIM, 1, devname);
 	if (!cc->io_queue) {
 		ti->error = "Couldn't create kcryptd io queue";
 		goto bad;
 	}
 
 	if (test_bit(DM_CRYPT_SAME_CPU, &cc->flags))
-		cc->crypt_queue = alloc_workqueue("kcryptd/%s",
-						  WQ_HIGHPRI | WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
+		cc->crypt_queue = alloc_workqueue("kcryptd/%s", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
 						  1, devname);
 	else
 		cc->crypt_queue = alloc_workqueue("kcryptd/%s",
-						  WQ_HIGHPRI | WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND,
+						  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND,
 						  num_online_cpus(), devname);
 	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";


