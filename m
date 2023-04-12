Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8CA16DEE9A
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjDLIn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbjDLInJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:43:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BA09740
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:42:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3666D63081
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD12C4331E;
        Wed, 12 Apr 2023 08:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288901;
        bh=No/o7Nw40NJctC95qme3wB0FA3XKx6bh26qzevsE4PQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZQYIMrsmVWM0Wr/QH5H177wQF8GedvhhzpHHquiiiU0abFJc6v2kBGqleneqDfFe
         FWotFwPkK3LazN24w9rIE8KE7ScfensT37U9bRmiJm546gNPctm60cxMcVNppQHXm4
         NUP9gSZs8h+gYoy8wfM/bb9qBhDrv18f+vIAhQpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ira Weiny <ira.weiny@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.1 061/164] PCI/DOE: Fix memory leak with CONFIG_DEBUG_OBJECTS=y
Date:   Wed, 12 Apr 2023 10:33:03 +0200
Message-Id: <20230412082839.410632625@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit abf04be0e7071f2bcd39bf97ba407e7d4439785e upstream.

After a pci_doe_task completes, its work_struct needs to be destroyed
to avoid a memory leak with CONFIG_DEBUG_OBJECTS=y.

Fixes: 9d24322e887b ("PCI/DOE: Add DOE mailbox support functions")
Tested-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: stable@vger.kernel.org # v6.0+
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/r/775768b4912531c3b887d405fc51a50e465e1bf9.1678543498.git.lukas@wunner.de
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/doe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/doe.c b/drivers/pci/doe.c
index c14ffdf23f87..e5e9b287b976 100644
--- a/drivers/pci/doe.c
+++ b/drivers/pci/doe.c
@@ -224,6 +224,7 @@ static void signal_task_complete(struct pci_doe_task *task, int rv)
 {
 	task->rv = rv;
 	task->complete(task);
+	destroy_work_on_stack(&task->work);
 }
 
 static void signal_task_abort(struct pci_doe_task *task, int rv)
-- 
2.40.0



