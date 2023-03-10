Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9ECD6B4219
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbjCJN7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbjCJN7q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:59:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAF1116B8E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:59:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7206B822C0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE38C4339C;
        Fri, 10 Mar 2023 13:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456772;
        bh=GnFaU6znMvVjgYZwqXmjwHHmNCtVX80BE4HkEbnvA3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=orxSOZdacxB6C3O4I3713LZrXPskxozcYZ/6unvj2dNQNcclwBf3ckCSW1obuLnv3
         pWkzsD9X01LcLTCMSt1k48XM4wYrMDrOPWLzUfShuBUwK3s80vTGsJ6kY+KmzR0OJj
         wiMVyXMwj2qHghaJaC9sZ/sC/eiW2iU3ADC7OyZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Wagner <dwagner@suse.de>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 119/211] nvme-fabrics: show well known discovery name
Date:   Fri, 10 Mar 2023 14:38:19 +0100
Message-Id: <20230310133722.354699218@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
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

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit 26a57cb35548ae67c14871cccbf50da3edb01ea4 ]

The kernel always logs the unique subsystem name for a discovery
controller, even in the case user space asked for the well known.

This has lead to confusion as the logs of nvme-cli and the kernel
logs didn't match.

First, nvme-cli connects to the well known discovery controller to
figure out if it supports TP8013. If so then nvme-cli disconnects and
connects to the unique discovery controller. Currently, the kernel show
that user space connected twice to the unique one.

To avoid further confusion, show the well known discovery controller if
user space asked for it:

  $ nvme connect-all -v -t tcp -a 192.168.0.1
  nvme0: nqn.2014-08.org.nvmexpress.discovery connected
  nvme0: nqn.2014-08.org.nvmexpress.discovery disconnected
  nvme0: nqn.discovery connected

  kernel log:
  nvme nvme0: new ctrl: NQN "nqn.2014-08.org.nvmexpress.discovery", addr 192.168.0.1:8009
  nvme nvme0: Removing ctrl: NQN "nqn.2014-08.org.nvmexpress.discovery"
  nvme nvme0: new ctrl: NQN "nqn.discovery", addr 192.168.0.1:8009

Fixes: e5ea42faa773 ("nvme: display correct subsystem NQN")
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
index a6e22116e1396..dcac3df8a5f76 100644
--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -189,7 +189,8 @@ nvmf_ctlr_matches_baseopts(struct nvme_ctrl *ctrl,
 
 static inline char *nvmf_ctrl_subsysnqn(struct nvme_ctrl *ctrl)
 {
-	if (!ctrl->subsys)
+	if (!ctrl->subsys ||
+	    !strcmp(ctrl->opts->subsysnqn, NVME_DISC_SUBSYS_NAME))
 		return ctrl->opts->subsysnqn;
 	return ctrl->subsys->subnqn;
 }
-- 
2.39.2



