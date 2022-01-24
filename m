Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A2E49AB43
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389918AbiAYErS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 23:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1325574AbiAYDhr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 22:37:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7171FC0811AD;
        Mon, 24 Jan 2022 12:33:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A728B81229;
        Mon, 24 Jan 2022 20:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E08CC340E5;
        Mon, 24 Jan 2022 20:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056387;
        bh=xSjM7sQ/q68pyXWnObsGO6CNownTJ0gLgJiruFyMyig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VXBnwyzbIHwl6L8iMtNJKDl7qiNsg18pcPzw2jKgCKdRZEvOT2VsNhdM7UjTQcAYk
         od3ZAmGHHdONvF7dK/NWj6Rv7r6TA/AyohaXh+Xln+7v4/6BUW6SWs2V8XAjtFe1W5
         wAKseeDt5RFOu1DiQLHgBtZ+LrlqUbpxm2CLc/Bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Hengqi Chen <hengqi.chen@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 466/846] selftests/bpf: Fix memory leaks in btf_type_c_dump() helper
Date:   Mon, 24 Jan 2022 19:39:43 +0100
Message-Id: <20220124184117.052223356@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 8ba285874913da21ca39a46376e9cc5ce0f45f94 ]

Free up memory and resources used by temporary allocated memstream and
btf_dump instance.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Hengqi Chen <hengqi.chen@gmail.com>
Link: https://lore.kernel.org/bpf/20211107165521.9240-4-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/btf_helpers.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/btf_helpers.c b/tools/testing/selftests/bpf/btf_helpers.c
index b692e6ead9b55..0a4ad7cb2c200 100644
--- a/tools/testing/selftests/bpf/btf_helpers.c
+++ b/tools/testing/selftests/bpf/btf_helpers.c
@@ -246,18 +246,23 @@ const char *btf_type_c_dump(const struct btf *btf)
 	d = btf_dump__new(btf, NULL, &opts, btf_dump_printf);
 	if (libbpf_get_error(d)) {
 		fprintf(stderr, "Failed to create btf_dump instance: %ld\n", libbpf_get_error(d));
-		return NULL;
+		goto err_out;
 	}
 
 	for (i = 1; i <= btf__get_nr_types(btf); i++) {
 		err = btf_dump__dump_type(d, i);
 		if (err) {
 			fprintf(stderr, "Failed to dump type [%d]: %d\n", i, err);
-			return NULL;
+			goto err_out;
 		}
 	}
 
+	btf_dump__free(d);
 	fflush(buf_file);
 	fclose(buf_file);
 	return buf;
+err_out:
+	btf_dump__free(d);
+	fclose(buf_file);
+	return NULL;
 }
-- 
2.34.1



