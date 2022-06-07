Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F07A5415AC
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357818AbiFGUiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356956AbiFGUfx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:35:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590571EC562;
        Tue,  7 Jun 2022 11:37:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB4076157B;
        Tue,  7 Jun 2022 18:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B34C385A2;
        Tue,  7 Jun 2022 18:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627077;
        bh=+qYyiDJGeKCahr8QfyQ+ZqpAAbEYjvVX4oxGHvDXOOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ONUrf09sN6+xXspEGojofVFKHN3yfjYvceIeHQF0+0x6a4+D5TkWHk1L4ASdyPIr8
         AYXzQc4GuHp1r51egygNBnQYqR4C9segC0v0z9Ev4/mUwWpkMLT9k92kPEkvP6FI4o
         th0bXDsuhpP8DL+DwBAu6X6xCAvwqZuhNjfqcojk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 602/772] rtla: Fix __set_sched_attr error message
Date:   Tue,  7 Jun 2022 19:03:14 +0200
Message-Id: <20220607165006.680494153@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@kernel.org>

[ Upstream commit 941a53c39a151e9aceef153cdfaed0f166ba01b7 ]

rtla's function __set_sched_attr() was borrowed from stalld, but I
forgot to update the error message to something meaningful for rtla.

 Update the error message from:
        boost_with_deadline failed to boost pid PID: STRERROR
 to a proper one:
        Failed to set sched attributes to the pid PID: STRERROR

Link: https://lkml.kernel.org/r/a2d19b2c53f6512aefd1ee7f8c1bd19d4fc8b99d.1651247710.git.bristot@kernel.org
Link: https://lore.kernel.org/r/eeded730413e7feaa13f946924bcf2cbf7dd9561.1650617571.git.bristot@kernel.org/

Fixes: b1696371d865 ("rtla: Helper functions for rtla")
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/tracing/rtla/src/utils.c b/tools/tracing/rtla/src/utils.c
index ffaf8ec84001..c4dd2aa0e963 100644
--- a/tools/tracing/rtla/src/utils.c
+++ b/tools/tracing/rtla/src/utils.c
@@ -254,7 +254,7 @@ int __set_sched_attr(int pid, struct sched_attr *attr)
 
 	retval = sched_setattr(pid, attr, flags);
 	if (retval < 0) {
-		err_msg("boost_with_deadline failed to boost pid %d: %s\n",
+		err_msg("Failed to set sched attributes to the pid %d: %s\n",
 			pid, strerror(errno));
 		return 1;
 	}
-- 
2.35.1



