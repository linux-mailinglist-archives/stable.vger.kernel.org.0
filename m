Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF486D951B
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 13:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjDFLbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 07:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjDFLbg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 07:31:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F3DA2;
        Thu,  6 Apr 2023 04:31:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ED7A64636;
        Thu,  6 Apr 2023 11:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81B0C433D2;
        Thu,  6 Apr 2023 11:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680780695;
        bh=OJnp1eB1GU+IdWevcDAhKD+L9ozYSOlac/WkoeZhdY4=;
        h=From:To:Cc:Subject:Date:From;
        b=TAOQPpr8ev1UMXA/XeT3VTqs+DtxjfS0dSo1heaw8T0pibgmPXk0YsSLkXqc90PEW
         TziPpMsrz+D1L9cj460wh6RqNMwm+DHszMQqU3amr4hekyKYsmGuVugTYDcbNhbrSR
         DEKnT3AuZNTHlj/TeOfITwrzx4RsUTHFygNgxAt4si7Df/4Ef7ZnuWjOxtXK3B54lp
         4ZJOxBSeP5jcinKi3Q0i0HUsqw2pv2R67GqAMr7gOZDt1pSSdVH0LPFG0hqbqKcaAN
         OxGlaeBC869IbtI9Fs8qGtwaYa2etOim+dlCOly+sW//PaY5dpfV+lrb+9ZU58mYIo
         GsHmclQlLHHhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Raillard <douglas.raillard@arm.com>,
        Mukesh Ojha <quic_mojha@quicinc.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rostedt@goodmis.org,
        mhiramat@kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 01/17] f2fs: Fix f2fs_truncate_partial_nodes ftrace event
Date:   Thu,  6 Apr 2023 07:31:15 -0400
Message-Id: <20230406113131.648213-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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
index 35ecb3118c7d5..111fafe049f7d 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -512,7 +512,7 @@ TRACE_EVENT(f2fs_truncate_partial_nodes,
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

