Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 040371F324
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbfEOLGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:06:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728096AbfEOLGu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:06:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2055720644;
        Wed, 15 May 2019 11:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918409;
        bh=mR1/2oKmKgb0i6tQzVTTyhgvG4twiIGqat1FCFseRlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMkIEw3Tx4GcXH48YsOatjxqWs1aLb7AkSF1G/rl8MaUdY7XNaKiw8JEBLwfveU0O
         6XUzcrF2s74Pmw9evmNik49p9NnGPb/AFgfBGcH0ljQnxKr5ttXZJBNW+doslb+jMZ
         f7eU5tYwvpx7eoftE7WtgByM//ZaboR+HeWi8TG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH 4.4 067/266] intel_th: gth: Fix an off-by-one in output unassigning
Date:   Wed, 15 May 2019 12:52:54 +0200
Message-Id: <20190515090724.706156241@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
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
@@ -597,7 +597,7 @@ static void intel_th_gth_unassign(struct
 	othdev->output.port = -1;
 	othdev->output.active = false;
 	gth->output[port].output = NULL;
-	for (master = 0; master < TH_CONFIGURABLE_MASTERS; master++)
+	for (master = 0; master <= TH_CONFIGURABLE_MASTERS; master++)
 		if (gth->master[master] == port)
 			gth->master[master] = -1;
 	spin_unlock(&gth->gth_lock);


