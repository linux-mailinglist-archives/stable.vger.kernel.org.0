Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB40657F5B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbiL1QEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234255AbiL1QD6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:03:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D81E186D2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:03:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25E73B81710
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83556C433D2;
        Wed, 28 Dec 2022 16:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243434;
        bh=BDB3VCuhU2MsAOQBEy2IuWIMQbw75/ec0VuvdB0Fh9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dnbRiJII9vzD9xyXEUTfuV13JhI9E001wGmjtv8LdwqQEqiFKyw7rUhXb/F9+eTsm
         RGSwnLqahzgGaXlKyh1fJtX6DueJPO7bFgBtFXi1JlvpAbaNcqKReZEhLhCA6iCTKg
         o1cgDzGlV5Db7Vw4E+pNgvPSKKUpSNxCjGZ9GIDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0492/1146] bpftool: Fix memory leak in do_build_table_cb
Date:   Wed, 28 Dec 2022 15:33:51 +0100
Message-Id: <20221228144343.546860523@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit fa55ef14ef4fe06198c0ce811b603aec24134bc2 ]

strdup() allocates memory for path. We need to release the memory in the
following error path. Add free() to avoid memory leak.

Fixes: 8f184732b60b ("bpftool: Switch to libbpf's hashmap for pinned paths of BPF objects")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20221206071906.806384-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 0cdb4f711510..e7a11cff7245 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -499,6 +499,7 @@ static int do_build_table_cb(const char *fpath, const struct stat *sb,
 	if (err) {
 		p_err("failed to append entry to hashmap for ID %u, path '%s': %s",
 		      pinned_info.id, path, strerror(errno));
+		free(path);
 		goto out_close;
 	}
 
-- 
2.35.1



