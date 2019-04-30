Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A955F81A
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbfD3LmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:42:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729166AbfD3LmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:42:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49CF221707;
        Tue, 30 Apr 2019 11:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624533;
        bh=xdzXT7iuE8BD5Wk4ArbhgsGfo4b+Mi84Qr64q17W6j0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRemPcEYGsy/cT2/18Yhy7BoCpG+Zg1g8h1tib8wjxGFLj/V5tyIBDJdGsKUc5/Bm
         8hDfYgwpsJN2EMwdjaNEeGXiI0FaZ+gPzW2swus9AgDpo567dStdzT8zK5YYLWnUQv
         LaukapQwYv9DyhyLoZNG4dl/Ujd4VMGC2w/SxeQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH 4.14 29/53] intel_th: gth: Fix an off-by-one in output unassigning
Date:   Tue, 30 Apr 2019 13:38:36 +0200
Message-Id: <20190430113556.353779668@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113549.400132183@linuxfoundation.org>
References: <20190430113549.400132183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 91d3f8a629849968dc91d6ce54f2d46abf4feb7f upstream.

Commit 9ed3f22223c3 ("intel_th: Don't reference unassigned outputs")
fixes a NULL dereference for all masters except the last one ("256+"),
which keeps the stale pointer after the output driver had been unassigned.

Fix the off-by-one.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Fixes: 9ed3f22223c3 ("intel_th: Don't reference unassigned outputs")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/intel_th/gth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwtracing/intel_th/gth.c
+++ b/drivers/hwtracing/intel_th/gth.c
@@ -624,7 +624,7 @@ static void intel_th_gth_unassign(struct
 	othdev->output.port = -1;
 	othdev->output.active = false;
 	gth->output[port].output = NULL;
-	for (master = 0; master < TH_CONFIGURABLE_MASTERS; master++)
+	for (master = 0; master <= TH_CONFIGURABLE_MASTERS; master++)
 		if (gth->master[master] == port)
 			gth->master[master] = -1;
 	spin_unlock(&gth->gth_lock);


