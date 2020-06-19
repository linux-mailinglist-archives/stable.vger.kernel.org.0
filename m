Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69A220104C
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393648AbgFSP2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:28:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393644AbgFSP2m (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:28:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 173A321924;
        Fri, 19 Jun 2020 15:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580521;
        bh=iGDstssJZNRPmYGflzsJwE0HzniypEW0XvpWSC3yA2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y7vqGFllGuVq4PXDXrz/ZqKpS/Ve09ULDyVsrfmWfJy2+DbTcmBwxevwACvV1EtsR
         GPY++qmCvCukDf/ORSyrKvrC/r/+cbvE3CZhfSTQuxI00TutZng5y6Qa0bEhEQpDRf
         HZGdd6hNa81C+Y0tRaWbwU6hxhakvE5fxanGsUMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Sitnicki <jakub@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 251/376] selftests/bpf, flow_dissector: Close TAP device FD after the test
Date:   Fri, 19 Jun 2020 16:32:49 +0200
Message-Id: <20200619141722.206454468@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit b8215dce7dfd817ca38807f55165bf502146cd68 ]

test_flow_dissector leaves a TAP device after it's finished, potentially
interfering with other tests that will run after it. Fix it by closing the
TAP descriptor on cleanup.

Fixes: 0905beec9f52 ("selftests/bpf: run flow dissector tests in skb-less mode")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200531082846.2117903-11-jakub@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/flow_dissector.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
index 92563898867c..9f3634c9971d 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -523,6 +523,7 @@ void test_flow_dissector(void)
 		CHECK_ATTR(err, tests[i].name, "bpf_map_delete_elem %d\n", err);
 	}
 
+	close(tap_fd);
 	bpf_prog_detach(prog_fd, BPF_FLOW_DISSECTOR);
 	bpf_object__close(obj);
 }
-- 
2.25.1



