Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 189394ABBA4
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384666AbiBGL3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383127AbiBGLVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:21:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157CCC0401ED;
        Mon,  7 Feb 2022 03:21:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C016DB81028;
        Mon,  7 Feb 2022 11:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196C4C004E1;
        Mon,  7 Feb 2022 11:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232889;
        bh=0cHK4kI7oB+4nl48C8/PSNfoVr5JtJ7//C89PqRan88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bkq/E+PDc0ZvvYy64FPupBdCHRSi8n7xnTkhRhhsgYu7PAPwhbQWGHnd8rCYWboHB
         WMbp/1+nP/jghYOg5GtDEEMx0sBT1u//X1q8jBq4oYEbG5TPbZSofDlL7KZSFK51t5
         ESphpfABaBgpwVQT42hTi36Ef3+rWQA0ndQsYZpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>,
        James Smart <jsmart2021@gmail.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 16/74] nvme-fabrics: fix state check in nvmf_ctlr_matches_baseopts()
Date:   Mon,  7 Feb 2022 12:06:14 +0100
Message-Id: <20220207103757.765200459@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
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
@@ -153,6 +153,7 @@ nvmf_ctlr_matches_baseopts(struct nvme_c
 			struct nvmf_ctrl_options *opts)
 {
 	if (ctrl->state == NVME_CTRL_DELETING ||
+	    ctrl->state == NVME_CTRL_DELETING_NOIO ||
 	    ctrl->state == NVME_CTRL_DEAD ||
 	    strcmp(opts->subsysnqn, ctrl->opts->subsysnqn) ||
 	    strcmp(opts->host->nqn, ctrl->opts->host->nqn) ||


