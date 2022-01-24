Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D7649A273
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365749AbiAXXvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1837925AbiAXWpi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:45:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1700EC0550D3;
        Mon, 24 Jan 2022 13:06:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6EEEB80FA1;
        Mon, 24 Jan 2022 21:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA741C340E5;
        Mon, 24 Jan 2022 21:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058361;
        bh=y6pxtUIpEOXti+4rAY08oFuU3RChd4ALLBj5AbyrRLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UseJFk04GQWm0MKPh2JbEPS4cGyEXl/J1c7gju9KkDNRoV3FZApCJ/1H9C3XGLE47
         Hb9Pno8pSZFUwERAvxdBDkLZEYiFQpVQp476VYD+PQQdOLdO28U8m3Gwpmboi7j+Xd
         hUiFAneLPHHZbQ0oBCq6/6qu75uFeeFGiRPpFAAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0232/1039] bpf: Adjust BTF log size limit.
Date:   Mon, 24 Jan 2022 19:33:41 +0100
Message-Id: <20220124184133.116112474@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit c5a2d43e998a821701029f23e25b62f9188e93ff ]

Make BTF log size limit to be the same as the verifier log size limit.
Otherwise tools that progressively increase log size and use the same log
for BTF loading and program loading will be hitting hard to debug EINVAL.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20211201181040.23337-7-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 9bdb03767db57..0cb1ceb91ca96 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4460,7 +4460,7 @@ static struct btf *btf_parse(bpfptr_t btf_data, u32 btf_data_size,
 		log->len_total = log_size;
 
 		/* log attributes have to be sane */
-		if (log->len_total < 128 || log->len_total > UINT_MAX >> 8 ||
+		if (log->len_total < 128 || log->len_total > UINT_MAX >> 2 ||
 		    !log->level || !log->ubuf) {
 			err = -EINVAL;
 			goto errout;
-- 
2.34.1



