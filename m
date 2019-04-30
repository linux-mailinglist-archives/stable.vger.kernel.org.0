Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BACA5F73C
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730789AbfD3LsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:48:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730798AbfD3LsJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:48:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 656622054F;
        Tue, 30 Apr 2019 11:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624888;
        bh=N3aEVoJ6zXx6nbSZpcU5Yo9Re3BOt9G3seEmxMhSMOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPVWRGcJHAIH5p3/zrFWL7zTpa1udOFUrKTPlak+tVuj3jq3tfFK1J44ADnG3U/2I
         O1lj2CFVPKrNYaR9zoY72DLgYBmvNr8+sGiOfru8oBau3ztfJPtXbXBBM0EXqn3xeg
         Q2eos2fJn23cBDMvruU67KY2WvZYDPbPl1FEakTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 03/89] intel_th: gth: Fix an off-by-one in output unassigning
Date:   Tue, 30 Apr 2019 13:37:54 +0200
Message-Id: <20190430113609.964782030@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 91d3f8a629849968dc91d6ce54f2d46abf4feb7f ]

Commit 9ed3f22223c3 ("intel_th: Don't reference unassigned outputs")
fixes a NULL dereference for all masters except the last one ("256+"),
which keeps the stale pointer after the output driver had been unassigned.

Fix the off-by-one.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Fixes: 9ed3f22223c3 ("intel_th: Don't reference unassigned outputs")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/intel_th/gth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/intel_th/gth.c b/drivers/hwtracing/intel_th/gth.c
index cc287cf6eb29..edc52d75e6bd 100644
--- a/drivers/hwtracing/intel_th/gth.c
+++ b/drivers/hwtracing/intel_th/gth.c
@@ -616,7 +616,7 @@ static void intel_th_gth_unassign(struct intel_th_device *thdev,
 	othdev->output.port = -1;
 	othdev->output.active = false;
 	gth->output[port].output = NULL;
-	for (master = 0; master < TH_CONFIGURABLE_MASTERS; master++)
+	for (master = 0; master <= TH_CONFIGURABLE_MASTERS; master++)
 		if (gth->master[master] == port)
 			gth->master[master] = -1;
 	spin_unlock(&gth->gth_lock);
-- 
2.19.1



