Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8EE658343
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235081AbiL1QpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233802AbiL1Qok (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:44:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C54D1CB33
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:40:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0ACFB817AE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC7AC433D2;
        Wed, 28 Dec 2022 16:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245631;
        bh=sp0I2+HMB3bd4EfxF/sCoyB+SJvJ5A3c9dd2kESsz+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEjSaVcck23ctKQ1Wn+hh1PCdN0eaMnZk7Y+9YEXqdCJJlcK0DQ13WxH+gUpglLXs
         eCyPsMt82RUAvz6kNZEi697lj2LzBi2IIw4kX5SjLeI6iFf+WwwPbV9rTvddbaZR65
         GJvPRDZPkzrkbThXpMpsXSzdhNb+mOOqA8Ho3Qfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Milan Landaverde <milan@mdaverde.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0896/1146] bpf: prevent leak of lsm program after failed attach
Date:   Wed, 28 Dec 2022 15:40:35 +0100
Message-Id: <20221228144354.534129610@linuxfoundation.org>
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

From: Milan Landaverde <milan@mdaverde.com>

[ Upstream commit e89f3edffb860a0f54a9ed16deadb7a4a1fa3862 ]

In [0], we added the ability to bpf_prog_attach LSM programs to cgroups,
but in our validation to make sure the prog is meant to be attached to
BPF_LSM_CGROUP, we return too early if the check fails. This results in
lack of decrementing prog's refcnt (through bpf_prog_put)
leaving the LSM program alive past the point of the expected lifecycle.
This fix allows for the decrement to take place.

[0] https://lore.kernel.org/all/20220628174314.1216643-4-sdf@google.com/

Fixes: 69fd337a975c ("bpf: per-cgroup lsm flavor")
Signed-off-by: Milan Landaverde <milan@mdaverde.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/r/20221213175714.31963-1-milan@mdaverde.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 7b373a5e861f..439ed7e5a82b 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3504,9 +3504,9 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 	case BPF_PROG_TYPE_LSM:
 		if (ptype == BPF_PROG_TYPE_LSM &&
 		    prog->expected_attach_type != BPF_LSM_CGROUP)
-			return -EINVAL;
-
-		ret = cgroup_bpf_prog_attach(attr, ptype, prog);
+			ret = -EINVAL;
+		else
+			ret = cgroup_bpf_prog_attach(attr, ptype, prog);
 		break;
 	default:
 		ret = -EINVAL;
-- 
2.35.1



