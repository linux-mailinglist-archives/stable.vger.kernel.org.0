Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC745939AF
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244049AbiHOT2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343604AbiHOT0L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:26:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CF73ED6B;
        Mon, 15 Aug 2022 11:41:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D657E61120;
        Mon, 15 Aug 2022 18:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8CCC433D6;
        Mon, 15 Aug 2022 18:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588898;
        bh=atgAS25s2COpB8BFvUkh8vDm4Mkm8/SqFe6Oe0UtabQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHSBeCqtZkLeMvvCmyf3WdQKwAkItTccoz9urkEG0SfXxGZusO4r7zaaDuFDJZzr4
         WOUgyxrWyPQ3IWHeAi1zLRzaMeZAqSl8urY2yBqyQ7zUSIGKdZZz/8ajvswcyjY8OK
         7sLQqY0BlSu0PCsA1TOOiyHsCe6wNDvlpE7q9/Vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 549/779] nvme: use command_id instead of req->tag in trace_nvme_complete_rq()
Date:   Mon, 15 Aug 2022 20:03:13 +0200
Message-Id: <20220815180400.793451288@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index 35bac7a25422..aa8b0f86b2be 100644
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



