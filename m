Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27B26D95C9
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 13:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238223AbjDFLhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 07:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238210AbjDFLgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 07:36:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A42A5C4;
        Thu,  6 Apr 2023 04:34:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2E786448A;
        Thu,  6 Apr 2023 11:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4B8C4339B;
        Thu,  6 Apr 2023 11:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680780843;
        bh=FrPrFRzIb80pwqGPPW/9W4CngxldpXYwhVu5k4UI80Q=;
        h=From:To:Cc:Subject:Date:From;
        b=sYnM4NjzMbhILoUjrkvIKXnYDQlisejccKwGKyuExp+d35Y/K2HLxIH9aNsf9CILI
         m9tVgx+o4O0CA+1K8e94Rq6KdehFLnUJdNlhibf2gDUKL1hKXwGKJ9Z6qMeIQrWssS
         ucu7Mf01HqgevsqxmTkIkYdZn+jbo9LgkmG3ILGenFl9yjQndW63e80e/xRbsVulfy
         eKcu7QHc6TaJXtNLu7Jqx7wAvOt1cJnP7SmJ3m+SyRwVX2pjXqjr6CZw4gUe4bpfvw
         /v0eLR33jW3RX8S51Xn8BtUzVhfRQNrqOz2JbSpR4PxISm/SlU3qfapkNd25Veur+9
         fae+mtL1WfkVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Raillard <douglas.raillard@arm.com>,
        Mukesh Ojha <quic_mojha@quicinc.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rostedt@goodmis.org,
        mhiramat@kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 1/8] f2fs: Fix f2fs_truncate_partial_nodes ftrace event
Date:   Thu,  6 Apr 2023 07:33:53 -0400
Message-Id: <20230406113400.649038-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Raillard <douglas.raillard@arm.com>

[ Upstream commit 0b04d4c0542e8573a837b1d81b94209e48723b25 ]

Fix the nid_t field so that its size is correctly reported in the text
format embedded in trace.dat files. As it stands, it is reported as
being of size 4:

        field:nid_t nid[3];     offset:24;      size:4; signed:0;

Instead of 12:

        field:nid_t nid[3];     offset:24;      size:12;        signed:0;

This also fixes the reported offset of subsequent fields so that they
match with the actual struct layout.

Signed-off-by: Douglas Raillard <douglas.raillard@arm.com>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/f2fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 52e6456bdb922..098d6dff20bef 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -498,7 +498,7 @@ TRACE_EVENT(f2fs_truncate_partial_nodes,
 	TP_STRUCT__entry(
 		__field(dev_t,	dev)
 		__field(ino_t,	ino)
-		__field(nid_t,	nid[3])
+		__array(nid_t,	nid, 3)
 		__field(int,	depth)
 		__field(int,	err)
 	),
-- 
2.39.2

