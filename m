Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5928142904C
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240724AbhJKOHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:07:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237996AbhJKOFA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:05:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3A61611CE;
        Mon, 11 Oct 2021 13:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960771;
        bh=4ZuKaxt9DmrfB/UDHzyV2kWzu915lcEmuOr1QnS+O7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ps7X6o6BPuq4Wrv9aRXqwkfbN29MR0u8iIdB8U4rJUMTdXuWSXmNdj1mTpjfJwF4x
         jBGBKGjb53ywc1bTql/ggSXVM1MwI9Zh+04fBwpOfUkJAxTZpWFknRGOYZSSCfykjg
         gaQj+aMAaWtyr5E9Y7wmQPD212ucHNNcG83AJcy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 068/151] libbpf: Fix memory leak in strset
Date:   Mon, 11 Oct 2021 15:45:40 +0200
Message-Id: <20211011134520.045865698@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit b0e875bac0fab3e7a7431c2eee36a8ccc0c712ac ]

Free struct strset itself, not just its internal parts.

Fixes: 90d76d3ececc ("libbpf: Extract internal set-of-strings datastructure APIs")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20211001185910.86492-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/strset.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/strset.c b/tools/lib/bpf/strset.c
index 1fb8b49de1d6..ea655318153f 100644
--- a/tools/lib/bpf/strset.c
+++ b/tools/lib/bpf/strset.c
@@ -88,6 +88,7 @@ void strset__free(struct strset *set)
 
 	hashmap__free(set->strs_hash);
 	free(set->strs_data);
+	free(set);
 }
 
 size_t strset__data_size(const struct strset *set)
-- 
2.33.0



