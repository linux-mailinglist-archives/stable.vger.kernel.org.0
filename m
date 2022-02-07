Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34C294ABC3A
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385056AbiBGLbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384228AbiBGL0A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:26:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82714C03FECF;
        Mon,  7 Feb 2022 03:25:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A68CCB811BE;
        Mon,  7 Feb 2022 11:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AB1C340F0;
        Mon,  7 Feb 2022 11:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233130;
        bh=RvfjgcB8o1T/+ITst3mAWwtUq/8YKRmzvA/v0luQ6P4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bqb4agpgUY/0kRLNTnMXskKyI16z9DyyRdujcRzbNPdQWccpcRDCQZdxvX72KXI1B
         T4Bxrm88ThQ+qe3WKYs0Fyf4YI/t0zMhtssFHHRZxuXcY+MyiHHixs4hNPvlBDG3LM
         9JgQIUVd9QKg6YmC2TWwQYthYTBQdvEkgJzZmghg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>,
        James Smart <jsmart2021@gmail.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.15 026/110] nvme-fabrics: fix state check in nvmf_ctlr_matches_baseopts()
Date:   Mon,  7 Feb 2022 12:05:59 +0100
Message-Id: <20220207103803.132352091@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
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

From: Uday Shankar <ushankar@purestorage.com>

commit 6a51abdeb259a56d95f13cc67e3a0838bcda0377 upstream.

Controller deletion/reset, immediately followed by or concurrent with
a reconnect, is hard failing the connect attempt resulting in a
complete loss of connectivity to the controller.

In the connect request, fabrics looks for an existing controller with
the same address components and aborts the connect if a controller
already exists and the duplicate connect option isn't set. The match
routine filters out controllers that are dead or dying, so they don't
interfere with the new connect request.

When NVME_CTRL_DELETING_NOIO was added, it missed updating the state
filters in the nvmf_ctlr_matches_baseopts() routine. Thus, when in this
new state, it's seen as a live controller and fails the connect request.

Correct by adding the DELETING_NIO state to the match checks.

Fixes: ecca390e8056 ("nvme: fix deadlock in disconnect during scan_work and/or ana_work")
Cc: <stable@vger.kernel.org> # v5.7+
Signed-off-by: Uday Shankar <ushankar@purestorage.com>
Reviewed-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/fabrics.h |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -169,6 +169,7 @@ nvmf_ctlr_matches_baseopts(struct nvme_c
 			struct nvmf_ctrl_options *opts)
 {
 	if (ctrl->state == NVME_CTRL_DELETING ||
+	    ctrl->state == NVME_CTRL_DELETING_NOIO ||
 	    ctrl->state == NVME_CTRL_DEAD ||
 	    strcmp(opts->subsysnqn, ctrl->opts->subsysnqn) ||
 	    strcmp(opts->host->nqn, ctrl->opts->host->nqn) ||


