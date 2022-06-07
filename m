Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5199854132E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357319AbiFGT4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357740AbiFGTzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:55:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B575A980B5;
        Tue,  7 Jun 2022 11:23:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94C3FB82383;
        Tue,  7 Jun 2022 18:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED17CC36B02;
        Tue,  7 Jun 2022 18:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626221;
        bh=3LvubQ/oMd98qexprLQfHhASSsUZesS2fEQgpHx095c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hW1KW84Ha9ORsKCz9P/zSgF9wM3/q0VqYFzUr49NeJQUWRbWGncAgXLuZKfLd6iXH
         +baIKLdoLT/BV+lqdGgT1xdoxExGb/1HIQEEgT6R0Ysm8C2IiW4aVF5QIxx44L0tBL
         wAd6j2GSEjG6QFYbwwXSDx5NnrHF1YbzFIEKjSAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 260/772] scftorture: Fix distribution of short handler delays
Date:   Tue,  7 Jun 2022 18:57:32 +0200
Message-Id: <20220607164956.683962777@linuxfoundation.org>
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

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 8106bddbab5f0ba180e6d693c7c1fc6926d57caa ]

The scftorture test module's scf_handler() function is supposed to provide
three different distributions of short delays (including "no delay") and
one distribution of long delays, if specified by the scftorture.longwait
module parameter.  However, the second of the two non-zero-wait short delays
is disabled due to the first such delay's "goto out" not being enclosed in
the "then" clause with the "udelay()".

This commit therefore adjusts the code to provide the intended set of
delays.

Fixes: e9d338a0b179 ("scftorture: Add smp_call_function() torture test")
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/scftorture.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/scftorture.c b/kernel/scftorture.c
index dcb0410950e4..5d113aa59e77 100644
--- a/kernel/scftorture.c
+++ b/kernel/scftorture.c
@@ -267,9 +267,10 @@ static void scf_handler(void *scfc_in)
 	}
 	this_cpu_inc(scf_invoked_count);
 	if (longwait <= 0) {
-		if (!(r & 0xffc0))
+		if (!(r & 0xffc0)) {
 			udelay(r & 0x3f);
-		goto out;
+			goto out;
+		}
 	}
 	if (r & 0xfff)
 		goto out;
-- 
2.35.1



