Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AAF1B0B06
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728964AbgDTMqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:46:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728435AbgDTMqw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:46:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D13E20736;
        Mon, 20 Apr 2020 12:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386811;
        bh=V0T2vJzigYrVCiLWOSJATcPRyJ+EEu6I4/FrCJIURc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c5eY+pFr+a+ykaK68P7tvHCPQ4OxIhk7aJJ49/GuPGcg6q3hxRnFRMi9dwtGxjIT5
         b1DiA7is2YS1jKtvHJLSdBgk/VVLJbjpnw1VP36OnZMCFwJgd2ud8UYct31DqKN9hm
         QUtFaC8I6jiVSPSsLb/hnSWNzoaE0nbL+P6o1Yi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 35/60] ASoC: Intel: mrfld: return error codes when an error occurs
Date:   Mon, 20 Apr 2020 14:39:13 +0200
Message-Id: <20200420121510.729638982@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121500.490651540@linuxfoundation.org>
References: <20200420121500.490651540@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 3025571edd9df653e1ad649f0638368a39d1bbb5 upstream.

Currently function sst_platform_get_resources always returns zero and
error return codes set by the function are never returned. Fix this
by returning the error return code in variable ret rather than the
hard coded zero.

Addresses-Coverity: ("Unused value")
Fixes: f533a035e4da ("ASoC: Intel: mrfld - create separate module for pci part")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Cezary Rojewski <cezary.rojewski@intel.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200208220720.36657-1-colin.king@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/intel/atom/sst/sst_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/intel/atom/sst/sst_pci.c
+++ b/sound/soc/intel/atom/sst/sst_pci.c
@@ -99,7 +99,7 @@ static int sst_platform_get_resources(st
 	dev_dbg(ctx->dev, "DRAM Ptr %p\n", ctx->dram);
 do_release_regions:
 	pci_release_regions(pci);
-	return 0;
+	return ret;
 }
 
 /*


