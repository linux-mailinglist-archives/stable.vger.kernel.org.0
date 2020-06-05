Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F9B1EFB57
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgFEOPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:15:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726553AbgFEOPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:15:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 782A12063A;
        Fri,  5 Jun 2020 14:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366548;
        bh=Scdha6iQPtZn1Tntw8fZXJD+kymQVK8iBLPJRJSVIsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=miPZep2DTNdM+nJ/hVYTsC2KHbFXbhBzuJlhMFaYMJl8j1WcJ+lYuhc+gs8yvwCkr
         kJhwEZ/A+1V+iTHqavN/S8TTJAmliLcG4BuqMRSGj/9AQroQdVrcGvXZFz/6dZXh8C
         D5f69YhAava2tLzV6f2jBvuVGO06d2jM3shinWFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.7 11/14] media: Revert "staging: imgu: Address a compiler warning on alignment"
Date:   Fri,  5 Jun 2020 16:15:01 +0200
Message-Id: <20200605135951.686677573@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605135951.018731965@linuxfoundation.org>
References: <20200605135951.018731965@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 81d1adeb52c97fbe097e8c94e36c3eb702cdb110 upstream.

This reverts commit c9d52c114a9fcc61c30512c7f810247a9f2812af.

The patch being reverted changed the memory layout of struct
ipu3_uapi_acc_param. Revert it, and address the compiler warning issues in
further patches.

Fixes: commit c9d52c114a9f ("media: staging: imgu: Address a compiler warning on alignment")
Reported-by: Tomasz Figa <tfiga@chromium.org>
Tested-by: Bingbu Cao <bingbu.cao@intel.com>
Cc: stable@vger.kernel.org # for v5.3 and up
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/media/ipu3/include/intel-ipu3.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/media/ipu3/include/intel-ipu3.h
+++ b/drivers/staging/media/ipu3/include/intel-ipu3.h
@@ -2477,7 +2477,7 @@ struct ipu3_uapi_acc_param {
 	struct ipu3_uapi_yuvp1_yds_config yds2 __attribute__((aligned(32)));
 	struct ipu3_uapi_yuvp2_tcc_static_config tcc __attribute__((aligned(32)));
 	struct ipu3_uapi_anr_config anr;
-	struct ipu3_uapi_awb_fr_config_s awb_fr __attribute__((aligned(32)));
+	struct ipu3_uapi_awb_fr_config_s awb_fr;
 	struct ipu3_uapi_ae_config ae;
 	struct ipu3_uapi_af_config_s af;
 	struct ipu3_uapi_awb_config awb;


