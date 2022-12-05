Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381D264328A
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbiLET06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233987AbiLET0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:26:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914E825C6A
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:23:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 179F4612D8
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFBFC433C1;
        Mon,  5 Dec 2022 19:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268194;
        bh=PBF8roq2s4eVgfA4poNqbM0zOD4uvA+mV6O7Vz9eV0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGOO14L5OLZzjw5fOqss27G5Sjqkrh+C/Y8+q4wezlyrQoDQzqIiV5619PcioTRUN
         Ni3InlYqooFAB8tASs5Ep1hk8N91aLDQ8qX4+NJ3w6AueAsFMKhoQAhhCH1sZesA+E
         LJ2iQ/PhaPLB1S679U1L8jYIix0V5hfeZQJym7Ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 015/124] libbpf: Use correct return pointer in attach_raw_tp
Date:   Mon,  5 Dec 2022 20:08:41 +0100
Message-Id: <20221205190808.880271477@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 5fd2a60aecf3a42b14fa371c55b3dbb18b229230 ]

We need to pass '*link' to final libbpf_get_error,
because that one holds the return value, not 'link'.

Fixes: 4fa5bcfe07f7 ("libbpf: Allow BPF program auto-attach handlers to bail out")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20221114145257.882322-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e36c44090720..79ea83be21ce 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -11143,7 +11143,7 @@ static int attach_raw_tp(const struct bpf_program *prog, long cookie, struct bpf
 	}
 
 	*link = bpf_program__attach_raw_tracepoint(prog, tp_name);
-	return libbpf_get_error(link);
+	return libbpf_get_error(*link);
 }
 
 /* Common logic for all BPF program types that attach to a btf_id */
-- 
2.35.1



