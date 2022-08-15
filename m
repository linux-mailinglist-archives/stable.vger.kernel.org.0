Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69161594479
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346885AbiHOWWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349406AbiHOWV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:21:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA2BB5A58;
        Mon, 15 Aug 2022 12:43:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E0A761215;
        Mon, 15 Aug 2022 19:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16665C433C1;
        Mon, 15 Aug 2022 19:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592620;
        bh=P6zsy+Br50IxBtDghnh0AItILePGuWVPwZtgnBjUs34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dYLtOJK9Fqje69L8m6W5CO9Bv5qV90yWOT0cuQ+DbncWQ0ne2KSn1pZLGUOAMXHDo
         PreaIin5kNPJav+iJWnV/AShWfPCqxain+3gy17qTgJH8gHpynwPTA/I74vSQw9bu8
         p/iiSsxVlBTvyhgBDiBFwRjb8KbdgGWVOKM8o1PM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0817/1095] nvme: use command_id instead of req->tag in trace_nvme_complete_rq()
Date:   Mon, 15 Aug 2022 20:03:36 +0200
Message-Id: <20220815180503.076313071@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Bean Huo <beanhuo@micron.com>

[ Upstream commit 679c54f2de672b7d79d02f8c4ad483ff6dd8ce2e ]

Use command_id instead of req->tag in trace_nvme_complete_rq(),
because of commit e7006de6c238 ("nvme: code command_id with a genctr
for use authentication after release"), cmd->common.command_id is set to
((genctl & 0xf)< 12 | req->tag), no longer req->tag, which makes cid in
trace_nvme_complete_rq and trace_nvme_setup_cmd are not the same.

Fixes: e7006de6c238 ("nvme: code command_id with a genctr for use authentication after release")
Signed-off-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/trace.h b/drivers/nvme/host/trace.h
index 37c7f4c89f92..6f0eaf6a1528 100644
--- a/drivers/nvme/host/trace.h
+++ b/drivers/nvme/host/trace.h
@@ -98,7 +98,7 @@ TRACE_EVENT(nvme_complete_rq,
 	    TP_fast_assign(
 		__entry->ctrl_id = nvme_req(req)->ctrl->instance;
 		__entry->qid = nvme_req_qid(req);
-		__entry->cid = req->tag;
+		__entry->cid = nvme_req(req)->cmd->common.command_id;
 		__entry->result = le64_to_cpu(nvme_req(req)->result.u64);
 		__entry->retries = nvme_req(req)->retries;
 		__entry->flags = nvme_req(req)->flags;
-- 
2.35.1



