Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33894F3780
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353064AbiDELNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349099AbiDEJtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6EFAA997F;
        Tue,  5 Apr 2022 02:40:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 825D661368;
        Tue,  5 Apr 2022 09:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC0CC385A2;
        Tue,  5 Apr 2022 09:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151650;
        bh=kTwXVej5jnwI0ge7d0/k1GflTMj2Y/jFHaUkXu9gn7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTbZR1Itp97KYlzM3vj0IA7NUK54TJ+AY3e7rbE/BtTPiawvi0QabAinsn9QtwG/1
         tisCZTm6QChrw4ibPSMJ/AVh53YjZ1IkvHEmUXyi5EdXfFdItGk4jTQkRmsnqSIgcW
         JBd3SSZuPn+ZzvLHc6BMaBavdVmNHFd/TW7QkF6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Jiri Olsa <jolsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 455/913] bpftool: Fix the error when lookup in no-btf maps
Date:   Tue,  5 Apr 2022 09:25:17 +0200
Message-Id: <20220405070353.487822593@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Yinjun Zhang <yinjun.zhang@corigine.com>

[ Upstream commit edc21dc909c6c133a2727f063eadd7907af51f94 ]

When reworking btf__get_from_id() in commit a19f93cfafdf the error
handling when calling bpf_btf_get_fd_by_id() changed. Before the rework
if bpf_btf_get_fd_by_id() failed the error would not be propagated to
callers of btf__get_from_id(), after the rework it is. This lead to a
change in behavior in print_key_value() that now prints an error when
trying to lookup keys in maps with no btf available.

Fix this by following the way used in dumping maps to allow to look up
keys in no-btf maps, by which it decides whether and where to get the
btf info according to the btf value type.

Fixes: a19f93cfafdf ("libbpf: Add internal helper to load BTF data by FD")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/1644249625-22479-1-git-send-email-yinjun.zhang@corigine.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/map.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 407071d54ab1..72ef9ddae260 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -1042,11 +1042,9 @@ static void print_key_value(struct bpf_map_info *info, void *key,
 	json_writer_t *btf_wtr;
 	struct btf *btf;
 
-	btf = btf__load_from_kernel_by_id(info->btf_id);
-	if (libbpf_get_error(btf)) {
-		p_err("failed to get btf");
+	btf = get_map_kv_btf(info);
+	if (libbpf_get_error(btf))
 		return;
-	}
 
 	if (json_output) {
 		print_entry_json(info, key, value, btf);
-- 
2.34.1



