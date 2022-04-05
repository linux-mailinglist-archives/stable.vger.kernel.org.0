Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF3FF4F3032
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242479AbiDEJhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235547AbiDEJCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:02:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD995F68;
        Tue,  5 Apr 2022 01:54:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B1FF614E4;
        Tue,  5 Apr 2022 08:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58290C385A0;
        Tue,  5 Apr 2022 08:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148843;
        bh=t5Bh1O2VM6dCuC+1XS/5HmnWzonTZ/xRqj/XfBCYSiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QWQBbedweRLxJ7X9y1ytYWwQxGdPm0qHzRXkg9RZipTs/UaDZqd0Pa5E+c22xfTiQ
         ci4D6lgXYaYFtsc4jV2/S1GNFvjAFFebGOtQQJRk3chbnDaQRADd754WQBqmhbtpm9
         MXIX8FKopO8hjRDKAARhWzRI3hKNlNUVnfeJizfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Jiri Olsa <jolsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0500/1017] bpftool: Fix the error when lookup in no-btf maps
Date:   Tue,  5 Apr 2022 09:23:33 +0200
Message-Id: <20220405070409.140615264@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index af83ae37d247..285fb2cbaef6 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -1053,11 +1053,9 @@ static void print_key_value(struct bpf_map_info *info, void *key,
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



