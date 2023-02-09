Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5E6A690A37
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 14:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjBINbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 08:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbjBINbK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 08:31:10 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FF65FE41;
        Thu,  9 Feb 2023 05:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675949458; x=1707485458;
  h=from:to:cc:subject:date:message-id;
  bh=bCjPdSIAYc3dV0BDVXkJFfQqW8XHr+J4i5SMM2yLfEE=;
  b=mhnMpDb2z1YxdsilHqF3j1gWt3S8s73Hbjo6R/H67pQ2Lrqk7jYSeYbw
   Zgbi1GmdC6d9VxbgRecEQ5oLisjw/thS471qZ99PBqzv1RMF9FJZ6WkHK
   Y3E29jjbe6a2v0+L7VG/HEaAbImU9BDyVhHZKEoiQTbWEhnT3rAcv8/v3
   zYZNKfkfQgcdl+uwWW35mSga6XywPVheUzXklwmQfydCPkv4z9xVB8E8j
   /ABSNaDgV0fcXt2EE154QWjSVBLU6dZ6aj8YlECHT1e0zeFqbtW93D7Zu
   TQEtjjKmgJ0fgyYFgPDK8LXMbwlB2vhexsq6lTe1GEOmxF07h+cK+C9Df
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="310460183"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="310460183"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 05:30:57 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="841593382"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="841593382"
Received: from qiuxu-clx.sh.intel.com ([10.239.53.105])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 05:30:54 -0800
From:   Qiuxu Zhuo <qiuxu.zhuo@intel.com>
To:     Tony Luck <tony.luck@intel.com>
Cc:     Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Borislav Petkov <bp@alien8.de>,
        Aristeu Rozanski <aris@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Feng Xu <feng.f.xu@intel.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/1] EDAC/skx: Fix overflows on the DRAM row address mapping arrays
Date:   Thu,  9 Feb 2023 21:30:23 +0800
Message-Id: <20230209133023.39825-1-qiuxu.zhuo@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The current DRAM row address mapping arrays skx_{open,close}_row[]
only support ranks with sizes up to 16G. Decoding a rank address
to a DRAM row address for a 32G rank by using either one of the
above arrays by the skx_edac driver, will result in an overflow on
the array.

For a 32G rank, the most significant DRAM row address bit (the
bit17) is mapped from the bit34 of the rank address. Add this new
mapping item to both arrays to fix the overflow issue.

Fixes: 98f2fc829e3b ("EDAC, skx_edac: Delete duplicated code")
Reported-by: Feng Xu <feng.f.xu@intel.com>
Tested-by: Feng Xu <feng.f.xu@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
---
 drivers/edac/skx_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/skx_base.c b/drivers/edac/skx_base.c
index 9397abb42c49..0a862336a7ce 100644
--- a/drivers/edac/skx_base.c
+++ b/drivers/edac/skx_base.c
@@ -510,7 +510,7 @@ static bool skx_rir_decode(struct decoded_addr *res)
 }
 
 static u8 skx_close_row[] = {
-	15, 16, 17, 18, 20, 21, 22, 28, 10, 11, 12, 13, 29, 30, 31, 32, 33
+	15, 16, 17, 18, 20, 21, 22, 28, 10, 11, 12, 13, 29, 30, 31, 32, 33, 34
 };
 
 static u8 skx_close_column[] = {
@@ -518,7 +518,7 @@ static u8 skx_close_column[] = {
 };
 
 static u8 skx_open_row[] = {
-	14, 15, 16, 20, 28, 21, 22, 23, 24, 25, 26, 27, 29, 30, 31, 32, 33
+	14, 15, 16, 20, 28, 21, 22, 23, 24, 25, 26, 27, 29, 30, 31, 32, 33, 34
 };
 
 static u8 skx_open_column[] = {
-- 
2.17.1

