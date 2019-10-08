Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58988D010B
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 21:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfJHTP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 15:15:57 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35873 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726439AbfJHTP5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 15:15:57 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 428D721F2E;
        Tue,  8 Oct 2019 15:15:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 15:15:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=cGsfZt
        le2SbFlv3TkP67GlqTQHNWoiwMzoUzNAJDAvU=; b=kguOe2T0BElH/jasBKA4bU
        fNe2W95SAqazHjRVewyryLn6vZjmW9naV0x8kBUZYFoI0PR9eSUUCIQMwW7ubqI5
        lkc80F9Iadgs0LABvDRh4P+rvCEYiDVCfbWu2gCFx0jW8OaT0TKsfqNT9xThEGua
        i4xtB7rbL1yM5nyUX+eRORPKkF09MkmzOSfQFW2Cnf5TEItR4GcI4LnxvWVAjgsF
        eKBIpXgZIjobzS7TjH7fhDAZmh18LBMK026Yu82bg4IoF/7QmoGGy4p5eEIO6cRD
        u3WZGEelvIOVpYHSnlnVoAksJlU0gS948X7nUH5HWFkxm/zrJJhzLjlIhON2nRMw
        ==
X-ME-Sender: <xms:a-CcXTxr1uRl0Mwus-4Ri-oaSYuv1au-d9fra86wPCcpXRGavDjCGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheelgddufeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:a-CcXWuiPPZ1gLBaeCYtuGUu7keeq3a1rAdQiOLHc9xDijc2cQQOFg>
    <xmx:a-CcXcBvUiZ1zG9HGiBSILBV8EtCmUWyhHbJQ0Lz4CfYRa0mAVd50Q>
    <xmx:a-CcXapDIj9sBh6eQ9BRe-YQ3qvrOL3D7WXr3mQvP-41GvbtAfiL-A>
    <xmx:bOCcXbYmMVCYE5H7_4Lm6_jwARDmjQMB6esJJ3O1fQbz9NMFGbbRng>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5AAE3D60067;
        Tue,  8 Oct 2019 15:15:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] libnvdimm: prevent nvdimm from requesting key when security" failed to apply to 5.3-stable tree
To:     dave.jiang@intel.com, dan.j.williams@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 21:15:53 +0200
Message-ID: <157056215310918@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 674f31a352da5e9f621f757b9a89262f486533a0 Mon Sep 17 00:00:00 2001
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 24 Sep 2019 10:34:49 -0700
Subject: [PATCH] libnvdimm: prevent nvdimm from requesting key when security
 is disabled

Current implementation attempts to request keys from the keyring even when
security is not enabled. Change behavior so when security is disabled it
will skip key request.

Error messages seen when no keys are installed and libnvdimm is loaded:

    request-key[4598]: Cannot find command to construct key 661489677
    request-key[4606]: Cannot find command to construct key 34713726

Cc: stable@vger.kernel.org
Fixes: 4c6926a23b76 ("acpi/nfit, libnvdimm: Add unlock of nvdimm support for Intel DIMMs")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/156934642272.30222.5230162488753445916.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 9e45b207ff01..89b85970912d 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -177,6 +177,10 @@ static int __nvdimm_security_unlock(struct nvdimm *nvdimm)
 			|| !nvdimm->sec.flags)
 		return -EIO;
 
+	/* No need to go further if security is disabled */
+	if (test_bit(NVDIMM_SECURITY_DISABLED, &nvdimm->sec.flags))
+		return 0;
+
 	if (test_bit(NDD_SECURITY_OVERWRITE, &nvdimm->flags)) {
 		dev_dbg(dev, "Security operation in progress.\n");
 		return -EBUSY;

