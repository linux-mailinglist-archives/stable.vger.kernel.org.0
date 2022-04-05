Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBFFB4F31A1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235872AbiDEIke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237733AbiDEISS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:18:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4EEB714B;
        Tue,  5 Apr 2022 01:07:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25BE5B81BB0;
        Tue,  5 Apr 2022 08:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73860C385A1;
        Tue,  5 Apr 2022 08:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146038;
        bh=EiD2outIWfFC46bZJ3egPCZBTRSu+xJQiDUM5rGAR1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qd5RDGgokoeiaG1gzjyoSe7FfSMZMksfzgPG0Tr2FOlh1s9oVPcWHkYQL5wPrt8Y8
         Y2oGPd11f05i4sniu+rSbJcN6x0wSqg9DkRSELFFy+7s/S0yJid+0Uk3D0W8f/1Iny
         oV0qjTVauws/5s1uGg/tGjby/+6uXjNePlublQBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Kuohai <xukuohai@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0619/1126] libbpf: Skip forward declaration when counting duplicated type names
Date:   Tue,  5 Apr 2022 09:22:46 +0200
Message-Id: <20220405070425.805243227@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit 4226961b0019b2e1612029e8950a9e911affc995 ]

Currently if a declaration appears in the BTF before the definition, the
definition is dumped as a conflicting name, e.g.:

    $ bpftool btf dump file vmlinux format raw | grep "'unix_sock'"
    [81287] FWD 'unix_sock' fwd_kind=struct
    [89336] STRUCT 'unix_sock' size=1024 vlen=14

    $ bpftool btf dump file vmlinux format c | grep "struct unix_sock"
    struct unix_sock;
    struct unix_sock___2 {	<--- conflict, the "___2" is unexpected
		    struct unix_sock___2 *unix_sk;

This causes a compilation error if the dump output is used as a header file.

Fix it by skipping declaration when counting duplicated type names.

Fixes: 351131b51c7a ("libbpf: add btf_dump API for BTF-to-C conversion")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20220301053250.1464204-2-xukuohai@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf_dump.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 07ebe70d3a30..6b1bc1f43728 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1505,6 +1505,11 @@ static const char *btf_dump_resolve_name(struct btf_dump *d, __u32 id,
 	if (s->name_resolved)
 		return *cached_name ? *cached_name : orig_name;
 
+	if (btf_is_fwd(t) || (btf_is_enum(t) && btf_vlen(t) == 0)) {
+		s->name_resolved = 1;
+		return orig_name;
+	}
+
 	dup_cnt = btf_dump_name_dups(d, name_map, orig_name);
 	if (dup_cnt > 1) {
 		const size_t max_len = 256;
-- 
2.34.1



