Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403D06DEF72
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbjDLIvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbjDLIu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:50:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268269778
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:50:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4030463159
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F48C433D2;
        Wed, 12 Apr 2023 08:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289415;
        bh=9ZU1sxrhWqxDPnkCAnIMktVGi6ySnIVZf5SpqMfZr4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPdqE6p51mAmdZbJnlNFag95ly55gdCPX85abAHCALtKrhhaUHs2B0A6yGRMeNSNa
         Cc5CdhNr+wixZY8sbmsRWXi/ZqOTfzO5eUGogL07Z+vVonmFhM51ctj17wq6CY5APN
         NsVrFzfJnBfMOT/D1A6l2niHx003nEQjjH9T6o+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ira Weiny <ira.weiny@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.2 060/173] PCI/DOE: Fix memory leak with CONFIG_DEBUG_OBJECTS=y
Date:   Wed, 12 Apr 2023 10:33:06 +0200
Message-Id: <20230412082840.528682137@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
 drivers/pci/doe.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/doe.c
+++ b/drivers/pci/doe.c
@@ -224,6 +224,7 @@ static void signal_task_complete(struct
 {
 	task->rv = rv;
 	task->complete(task);
+	destroy_work_on_stack(&task->work);
 }
 
 static void signal_task_abort(struct pci_doe_task *task, int rv)


