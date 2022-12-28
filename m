Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A139658193
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbiL1Q3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233390AbiL1Q3V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:29:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D76B1B1CA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:25:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99E9DB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E75CC433D2;
        Wed, 28 Dec 2022 16:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244732;
        bh=mN7b1bBfSuTcDQqVpqek5Dy9LYiuRHhhIF4+xO9/b+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvfhjMma6Qt3g6SC2x358IW9iR/31G1z9HnUFi+6NKEbqXMjIw+7dp0wL6MATCzBP
         4Rpl6xZmEFnQf/iRPiWZX1Y+c+vdTJIgELclUTi1YDwDZ56noGfsRTvVoQKcwZVZQq
         PLc29/q9YGw91AIVNGaac8NRAE6MpuwnDTIqFLTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Beau Belgrave <beaub@linux.microsoft.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0727/1146] tracing/user_events: Fix call print_fmt leak
Date:   Wed, 28 Dec 2022 15:37:46 +0100
Message-Id: <20221228144349.891986592@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Beau Belgrave <beaub@linux.microsoft.com>

[ Upstream commit 4bded7af8b9af6e97514b0521004f90267905aef ]

If user_event_trace_register() fails within user_event_parse() the
call's print_fmt member is not freed. Add kfree call to fix this.

Link: https://lkml.kernel.org/r/20221123183248.554-1-beaub@linux.microsoft.com

Fixes: aa3b2b4c6692 ("user_events: Add print_fmt generation support for basic types")
Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index 539b08ae7020..9cb53182bb31 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -1359,6 +1359,7 @@ static int user_event_parse(struct user_event_group *group, char *name,
 put_user:
 	user_event_destroy_fields(user);
 	user_event_destroy_validators(user);
+	kfree(user->call.print_fmt);
 	kfree(user);
 	return ret;
 }
-- 
2.35.1



