Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17963679A24
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbjAXNpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234270AbjAXNoq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:44:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA7D46173;
        Tue, 24 Jan 2023 05:43:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E14DF611FC;
        Tue, 24 Jan 2023 13:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDD6C433D2;
        Tue, 24 Jan 2023 13:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567775;
        bh=Yp3hHNij9/bTJKTCgLv3LCBfq/9uGno3R7DONhwxznk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mP6OAcPtQYai7TUowVOOdU0UcBxPyEkWXpEoM4qgl5NT//72VD4Z2b8sbsuId4DoY
         W3uTdEklYcj4WcF7j3ljU+NJoqfwroqvT/qfa0J9TE3EmdalxCnSzf+OL1dFvfeLqj
         EQeVsv1CgRWygBiIsiRemhNAsxiRhL5WVzkP2l0K11DrME45g8pDbmkFc0VZ5MWSHG
         VOsrzgyMW2p0hLOJE/KWMQxz+3ZBxnnKQRdXNmRLmDQICHQRQS4q0grmC9c7Hajpqg
         GbzDRqUni81sT6NMiWDubql0CGP4W0rtW94nkYeYNn6NDKZ3J8T+Kc/xSrYFXSux9s
         D25ubjEkSaZhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jordy Zomer <jordyzomer@google.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, ebiederm@xmission.com,
        brho@google.com, catalin.marinas@arm.com, broonie@kernel.org,
        legion@kernel.org, Jason@zx2c4.com, surenb@google.com
Subject: [PATCH AUTOSEL 6.1 34/35] prlimit: do_prlimit needs to have a speculation check
Date:   Tue, 24 Jan 2023 08:41:30 -0500
Message-Id: <20230124134131.637036-34-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134131.637036-1-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 739790605705ddcf18f21782b9c99ad7d53a8c11 ]

do_prlimit() adds the user-controlled resource value to a pointer that
will subsequently be dereferenced.  In order to help prevent this
codepath from being used as a spectre "gadget" a barrier needs to be
added after checking the range.

Reported-by: Jordy Zomer <jordyzomer@google.com>
Tested-by: Jordy Zomer <jordyzomer@google.com>
Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sys.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sys.c b/kernel/sys.c
index 5fd54bf0e886..88b31f096fb2 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1442,6 +1442,8 @@ static int do_prlimit(struct task_struct *tsk, unsigned int resource,
 
 	if (resource >= RLIM_NLIMITS)
 		return -EINVAL;
+	resource = array_index_nospec(resource, RLIM_NLIMITS);
+
 	if (new_rlim) {
 		if (new_rlim->rlim_cur > new_rlim->rlim_max)
 			return -EINVAL;
-- 
2.39.0

