Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19AD54134D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357528AbiFGT7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357542AbiFGT6Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:58:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4566E8B94;
        Tue,  7 Jun 2022 11:24:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69A67B8237C;
        Tue,  7 Jun 2022 18:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C71C385A5;
        Tue,  7 Jun 2022 18:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626235;
        bh=9pWPZtcmpslMZO7D1zBvwT33N355vQeQ1cWgnuBLtxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oGi9gvdIeYnOqBZHBWr0aMCO8uuFjo/6/5AS5f069OltBcmhvzqKfZW32j+BQqVNK
         GPXvc7XZhXQ5fyQdtp2vulwRJufV3nFXBqmtZEDJivj6spYiAeX+Lu/DdY306+b82J
         Xa0JesDSShUe9gPXzrNAXRQoMbC0MpqrfSe6muFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 306/772] libbpf: Fix logic for finding matching program for CO-RE relocation
Date:   Tue,  7 Jun 2022 18:58:18 +0200
Message-Id: <20220607164958.042563097@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 966a7509325395c51c5f6d89e7352b0585e4804b ]

Fix the bug in bpf_object__relocate_core() which can lead to finding
invalid matching BPF program when processing CO-RE relocation. IF
matching program is not found, last encountered program will be assumed
to be correct program and thus error detection won't detect the problem.

Fixes: 9c82a63cf370 ("libbpf: Fix CO-RE relocs against .text section")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20220426004511.2691730-4-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 9c202bba911c..0ea7b91e675f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5639,9 +5639,10 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 		 */
 		prog = NULL;
 		for (i = 0; i < obj->nr_programs; i++) {
-			prog = &obj->programs[i];
-			if (strcmp(prog->sec_name, sec_name) == 0)
+			if (strcmp(obj->programs[i].sec_name, sec_name) == 0) {
+				prog = &obj->programs[i];
 				break;
+			}
 		}
 		if (!prog) {
 			pr_warn("sec '%s': failed to find a BPF program\n", sec_name);
-- 
2.35.1



