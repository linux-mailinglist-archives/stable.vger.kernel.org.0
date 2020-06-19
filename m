Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8373E201416
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391671AbgFSPII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:08:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391662AbgFSPIF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:08:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2BBB21941;
        Fri, 19 Jun 2020 15:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579285;
        bh=mJrXbTTQE/TU8fIHQr6LBtPOS7pr8EpfcxM26Vd55II=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MUVNTWj8FU2M7qYieCpsy66PwL8CCynLjaIBK5nG/8ULcGU0vFQXDSBGeAzeJI8MN
         cBsHElMByQTLtOIc7yIx7hfGH5+AbKLqIVXXsfiVMfvbwcadHaU6vh9HvECq8Lj7SH
         ZiEQAgjIRFPb1nR3K5KsUAPh6eLKSYcevG+D4EVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 077/261] selftests/bpf: Fix memory leak in extract_build_id()
Date:   Fri, 19 Jun 2020 16:31:28 +0200
Message-Id: <20200619141653.581584693@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 9f56bb531a809ecaa7f0ddca61d2cf3adc1cb81a ]

getline() allocates string, which has to be freed.

Fixes: 81f77fd0deeb ("bpf: add selftest for stackmap with BPF_F_STACK_BUILD_ID")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20200429012111.277390-7-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 3bf18364c67c..8cb3469dd11f 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -293,6 +293,7 @@ int extract_build_id(char *build_id, size_t size)
 		len = size;
 	memcpy(build_id, line, len);
 	build_id[len] = '\0';
+	free(line);
 	return 0;
 err:
 	fclose(fp);
-- 
2.25.1



