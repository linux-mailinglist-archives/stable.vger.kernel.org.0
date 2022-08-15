Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F53594CA3
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242459AbiHPArZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347029AbiHPApu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:45:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B015D477F;
        Mon, 15 Aug 2022 13:41:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13B04B8114A;
        Mon, 15 Aug 2022 20:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BFEC433C1;
        Mon, 15 Aug 2022 20:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596059;
        bh=D6XnQg1CsGu7Vx9lk0X2XQu5E8oNyv90wVb7G96iflc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j60y1S9hQGWzVmxjE/cxXoxV1Dn3ZJl5uoNjLbSmMHHUEw0Zr8QXqZwJiDMXy+p3j
         0zqn+y9ziJFxPUGwA6Hm8DeDGP+Q0bjZ5VfGqqkYF6jjBmFcpkEHzI/rEmRfMFkl3t
         JofCCdYf8Hi/6Z3hazXrYQgluSOFjcQwB4n1BlsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0960/1157] net: 9p: fix refcount leak in p9_read_work() error handling
Date:   Mon, 15 Aug 2022 20:05:16 +0200
Message-Id: <20220815180518.042090237@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 007c3f45fe05..e758978b44be 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -343,6 +343,7 @@ static void p9_read_work(struct work_struct *work)
 			p9_debug(P9_DEBUG_ERROR,
 				 "No recv fcall for tag %d (req %p), disconnecting!\n",
 				 m->rc.tag, m->rreq);
+			p9_req_put(m->client, m->rreq);
 			m->rreq = NULL;
 			err = -EIO;
 			goto error;
-- 
2.35.1



