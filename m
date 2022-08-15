Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5767D59492A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355501AbiHOX4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356367AbiHOXyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:54:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FEA160130;
        Mon, 15 Aug 2022 13:19:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED70AB80EA8;
        Mon, 15 Aug 2022 20:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416B7C433D6;
        Mon, 15 Aug 2022 20:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594736;
        bh=JYVX+japmWo6QkvwKxE7PofA1DxPVMaWjvU8+Bwxme0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qU09QDDbLYGmQUi4Iy+KfhX6AXG42VplkeDb+0Q27bXqaF6OM3zBhrIOARQ9ws2Dv
         aVWunW9B0pErfXCnOJ+6+/FDO2rPFqEHPYKnGBUETdVgDKUEZeQh7VLJNjRwI0LQnL
         Uo/fleJv0Ov7+oIcv/uF4GuwAl0G6GKdFeIK860M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0515/1157] libbpf: fix an snprintf() overflow check
Date:   Mon, 15 Aug 2022 19:57:51 +0200
Message-Id: <20220815180500.290138001@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit b77ffb30cfc5f58e957571d8541c6a7e3da19221 ]

The snprintf() function returns the number of bytes it *would* have
copied if there were enough space.  So it can return > the
sizeof(gen->attach_target).

Fixes: 67234743736a ("libbpf: Generate loader program out of BPF ELF file.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/r/YtZ+oAySqIhFl6/J@kili
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/gen_loader.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index 927745b08014..23f5c46708f8 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -533,7 +533,7 @@ void bpf_gen__record_attach_target(struct bpf_gen *gen, const char *attach_name,
 	gen->attach_kind = kind;
 	ret = snprintf(gen->attach_target, sizeof(gen->attach_target), "%s%s",
 		       prefix, attach_name);
-	if (ret == sizeof(gen->attach_target))
+	if (ret >= sizeof(gen->attach_target))
 		gen->error = -ENOSPC;
 }
 
-- 
2.35.1



