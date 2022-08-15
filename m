Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146B6593A1E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbiHOTcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344471AbiHOTba (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:31:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB93961107;
        Mon, 15 Aug 2022 11:44:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18E53611E6;
        Mon, 15 Aug 2022 18:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06438C433D7;
        Mon, 15 Aug 2022 18:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589079;
        bh=BE+qFjw6qKenTUdK2eHcBqM74EQDU1O2m42p5rJePb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgjQQcCVsLvueZOEpMlvioDUYxAg42wrH5vD1Nq/xbIb3FkJ6GHNFt7QfUN9wWjBg
         9h+UXQ66+Nn7LvrocxrUGuAiQN3dzmUJkDbUCJghTmLj/PYvMzEapnCnLFDu3O1vz9
         rJ8S7yLp9M6eAfVJ0PZi2wwD52wRTlvrgzBILNZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 607/779] net: 9p: fix refcount leak in p9_read_work() error handling
Date:   Mon, 15 Aug 2022 20:04:11 +0200
Message-Id: <20220815180403.298006742@linuxfoundation.org>
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

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 4ac7573e1f9333073fa8d303acc941c9b7ab7f61 ]

p9_req_put need to be called when m->rreq->rc.sdata is NULL to avoid
temporary refcount leak.

Link: https://lkml.kernel.org/r/20220712104438.30800-1-hbh25y@gmail.com
Fixes: 728356dedeff ("9p: Add refcount to p9_req_t")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
[Dominique: commit wording adjustments, p9_req_put argument fixes for rebase]
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_fd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index c55c8a608bc7..6fe3719c1fc6 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -345,6 +345,7 @@ static void p9_read_work(struct work_struct *work)
 			p9_debug(P9_DEBUG_ERROR,
 				 "No recv fcall for tag %d (req %p), disconnecting!\n",
 				 m->rc.tag, m->rreq);
+			p9_req_put(m->client, m->rreq);
 			m->rreq = NULL;
 			err = -EIO;
 			goto error;
-- 
2.35.1



