Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1624B4BE397
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350762AbiBUJjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:39:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351314AbiBUJg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:36:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C6B2DD7A;
        Mon, 21 Feb 2022 01:15:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80340608C1;
        Mon, 21 Feb 2022 09:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639A1C340E9;
        Mon, 21 Feb 2022 09:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434921;
        bh=udyfW1L3muCkfAB2xkuL09YazwKCow9OUHBy04Zui/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aFd1M56BsN+KM7V0V9XXgqRIJ1kfG3kAhsZ21vG8uH/SNuKoZ82XNWvJaBpToAVcL
         u0u8eaZezTeovo2O1XvLJVG27DTy7Nrn1Wh/uc0Ni2aHD4vjidqbwnytzqkWQB3TU7
         sA1jP1ifJJol4+WFho3XiezwAZYImWVkFvJflRmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.15 178/196] ucounts: Handle wrapping in is_ucounts_overlimit
Date:   Mon, 21 Feb 2022 09:50:10 +0100
Message-Id: <20220221084936.909589544@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Eric W. Biederman <ebiederm@xmission.com>

commit 0cbae9e24fa7d6c6e9f828562f084da82217a0c5 upstream.

While examining is_ucounts_overlimit and reading the various messages
I realized that is_ucounts_overlimit fails to deal with counts that
may have wrapped.

Being wrapped should be a transitory state for counts and they should
never be wrapped for long, but it can happen so handle it.

Cc: stable@vger.kernel.org
Fixes: 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
Link: https://lkml.kernel.org/r/20220216155832.680775-5-ebiederm@xmission.com
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/ucount.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -344,7 +344,8 @@ bool is_ucounts_overlimit(struct ucounts
 	if (rlimit > LONG_MAX)
 		max = LONG_MAX;
 	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
-		if (get_ucounts_value(iter, type) > max)
+		long val = get_ucounts_value(iter, type);
+		if (val < 0 || val > max)
 			return true;
 		max = READ_ONCE(iter->ns->ucount_max[type]);
 	}


