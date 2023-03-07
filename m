Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8063E6AEEA0
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbjCGSNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbjCGSNc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:13:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A156231CD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:09:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83E426152E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9482EC4339C;
        Tue,  7 Mar 2023 18:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212550;
        bh=7IDupy/uympF3yiDf3YB1jvkydvCTx1b3QoNG5dHuEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFO5mc9w31uR/DWyCej6PPepVDbpVJTI7lM4AHh2KrA6ZvoaZr2BhnsZ+hPkC1u7r
         SXy4x56s50ouymFOe7fablpLgYUFNz4WrIhQ7NkXI1M6Bi3FpGK3z5VaG38XbIwc85
         KjZ1A3WIjOv7maN3QVnV40I5/FDjJPzjhtal8+kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ilya Leoshkevich <iii@linux.ibm.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 220/885] libbpf: Fix alen calculation in libbpf_nla_dump_errormsg()
Date:   Tue,  7 Mar 2023 17:52:34 +0100
Message-Id: <20230307170011.650376326@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 17bcd27a08a21397698edf143084d7c87ce17946 ]

The code assumes that everything that comes after nlmsgerr are nlattrs.
When calculating their size, it does not account for the initial
nlmsghdr. This may lead to accessing uninitialized memory.

Fixes: bbf48c18ee0c ("libbpf: add error reporting in XDP")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20230210001210.395194-8-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/nlattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/nlattr.c b/tools/lib/bpf/nlattr.c
index 3900d052ed19e..975e265eab3bf 100644
--- a/tools/lib/bpf/nlattr.c
+++ b/tools/lib/bpf/nlattr.c
@@ -178,7 +178,7 @@ int libbpf_nla_dump_errormsg(struct nlmsghdr *nlh)
 		hlen += nlmsg_len(&err->msg);
 
 	attr = (struct nlattr *) ((void *) err + hlen);
-	alen = nlh->nlmsg_len - hlen;
+	alen = (void *)nlh + nlh->nlmsg_len - (void *)attr;
 
 	if (libbpf_nla_parse(tb, NLMSGERR_ATTR_MAX, attr, alen,
 			     extack_policy) != 0) {
-- 
2.39.2



