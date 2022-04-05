Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39A54F28E6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240144AbiDEIXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237322AbiDEIRz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:17:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D888B3DE4;
        Tue,  5 Apr 2022 01:06:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7ED0DB81BAF;
        Tue,  5 Apr 2022 08:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3AB9C385A0;
        Tue,  5 Apr 2022 08:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145961;
        bh=Pq3+SVaoZd+Fd197Y5mdzFTMoxlvF+PCrqlvowlz+Cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zwXCSIm4tun+fC/EgZ8slUbx/fOQziaThUshrBfJAVyUsEEa+2Vmr8by4xfxLeQjJ
         hj8L3GsT+gh1U1+DkxvqaTnEZP6zRcR2j4ksKl+3v5iZnm7IsXv1DNASyLqovTe+wK
         jZOMRk+1Q2mZnxXC6JM9LX2RwbaNPycQkjRIZc+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0554/1126] cxl/port: Hold port reference until decoder release
Date:   Tue,  5 Apr 2022 09:21:41 +0200
Message-Id: <20220405070423.894407819@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 74be98774dfbc5b8b795db726bd772e735d2edd4 ]

KASAN + DEBUG_KOBJECT_RELEASE reports a potential use-after-free in
cxl_decoder_release() where it goes to reference its parent, a cxl_port,
to free its id back to port->decoder_ida.

 BUG: KASAN: use-after-free in to_cxl_port+0x18/0x90 [cxl_core]
 Read of size 8 at addr ffff888119270908 by task kworker/35:2/379

 CPU: 35 PID: 379 Comm: kworker/35:2 Tainted: G           OE     5.17.0-rc2+ #198
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
 Workqueue: events kobject_delayed_cleanup
 Call Trace:
  <TASK>
  dump_stack_lvl+0x59/0x73
  print_address_description.constprop.0+0x1f/0x150
  ? to_cxl_port+0x18/0x90 [cxl_core]
  kasan_report.cold+0x83/0xdf
  ? to_cxl_port+0x18/0x90 [cxl_core]
  to_cxl_port+0x18/0x90 [cxl_core]
  cxl_decoder_release+0x2a/0x60 [cxl_core]
  device_release+0x5f/0x100
  kobject_cleanup+0x80/0x1c0

The device core only guarantees parent lifetime until all children are
unregistered. If a child needs a parent to complete its ->release()
callback that child needs to hold a reference to extend the lifetime of
the parent.

Fixes: 40ba17afdfab ("cxl/acpi: Introduce cxl_decoder objects")
Reported-by: Ben Widawsky <ben.widawsky@intel.com>
Tested-by: Ben Widawsky <ben.widawsky@intel.com>
Reviewed-by: Ben Widawsky <ben.widawsky@intel.com>
Link: https://lore.kernel.org/r/164505751190.4175768.13324905271463416712.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 3f9b98ecd18b..aa5239ac67c6 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -182,6 +182,7 @@ static void cxl_decoder_release(struct device *dev)
 
 	ida_free(&port->decoder_ida, cxld->id);
 	kfree(cxld);
+	put_device(&port->dev);
 }
 
 static const struct device_type cxl_decoder_switch_type = {
@@ -500,7 +501,10 @@ struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port, int nr_targets)
 	if (rc < 0)
 		goto err;
 
+	/* need parent to stick around to release the id */
+	get_device(&port->dev);
 	cxld->id = rc;
+
 	cxld->nr_targets = nr_targets;
 	dev = &cxld->dev;
 	device_initialize(dev);
-- 
2.34.1



