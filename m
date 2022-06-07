Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317E5541C9E
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382663AbiFGWCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382463AbiFGWCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:02:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35C924F793;
        Tue,  7 Jun 2022 12:14:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 096CF61923;
        Tue,  7 Jun 2022 19:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158B9C385A2;
        Tue,  7 Jun 2022 19:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629277;
        bh=1ASL6fBMDAmWBj3axiWH/dhSFOu0lxh5MMkutiN/P/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jk21CeqihnFCBNCHO39k6kFO6FiYMpjofrmFqFiG+MEApGpUtcb57u6PUaKWgw04+
         6+56AeqooZte/1/noyqIaNVFseJzBppyHg6nkpF9HIB0sN6yMQaMwtXakLNc04S3rc
         wexkiUQNn38XT841WTqCWinS2It4yvmNgmA/PEGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        Krzysztof Kensicki <krzysztof.kensicki@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 592/879] nvdimm: Allow overwrite in the presence of disabled dimms
Date:   Tue,  7 Jun 2022 19:01:50 +0200
Message-Id: <20220607165020.036905415@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit bb7bf697fed58eae9d3445944e457ab0de4da54f ]

It is not clear why the original implementation of overwrite support
required the dimm driver to be active before overwrite could proceed. In
fact that can lead to cases where the kernel retains an invalid cached
copy of the labels from before the overwrite. Unfortunately the kernel
has not only allowed that case, but enforced it.

Going forward, allow for overwrite to happen while the label area is
offline, and follow-on with updates to 'ndctl sanitize-dimm --overwrite'
to trigger the label area invalidation by default.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Reported-by: Krzysztof Kensicki <krzysztof.kensicki@intel.com>
Fixes: 7d988097c546 ("acpi/nfit, libnvdimm/security: Add security DSM overwrite support")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/security.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 4b80150e4afa..b5aa55c61461 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -379,11 +379,6 @@ static int security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
 			|| !nvdimm->sec.flags)
 		return -EOPNOTSUPP;
 
-	if (dev->driver == NULL) {
-		dev_dbg(dev, "Unable to overwrite while DIMM active.\n");
-		return -EINVAL;
-	}
-
 	rc = check_security_state(nvdimm);
 	if (rc)
 		return rc;
-- 
2.35.1



