Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFFA658285
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbiL1Qhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234981AbiL1Qgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:36:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4CF19C3A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:33:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CC8D61541
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:33:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E65BC433D2;
        Wed, 28 Dec 2022 16:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245180;
        bh=pm5Zv/Er1KLMVxZNDI/ktZnJaPYbszTji8K/IG4IT1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QAQ2VmWvTeBl/0I1RhsB2CUVudHuK5nGc1wIAcvLTirSq9uZyiT8/7UK8PWEeatxa
         F433eXqbahXy0XVUzPtq8zvsanXtxKKCzzZlKdw39+VqJQrCl9hkRQ9bQqkLUq5Yrs
         o8fNTD6J+R1p+iDdvirMnBP0FD8ZVS5lB6Uvpjz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Milan Landaverde <milan@mdaverde.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0846/1073] bpf: prevent leak of lsm program after failed attach
Date:   Wed, 28 Dec 2022 15:40:34 +0100
Message-Id: <20221228144351.000064682@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 0e758911d963..6b6fb7237ebe 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3505,9 +3505,9 @@ static int bpf_prog_attach(const union bpf_attr *attr)
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



