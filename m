Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C0E24BBDC
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgHTJs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:48:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729497AbgHTJsX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:48:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88D4C2078D;
        Thu, 20 Aug 2020 09:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916903;
        bh=XrbbsEwzjw+TUQZLjHjpZRKnnu1QqeUqlC+z7zSuM0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yhzok+Gl3wZNYnHyjEFi22g3Utbz8yfYuIM2xJbyG2Dyd2JwNP5eU3U1+yojm+jaN
         Chmpkr7UKiYLxRF19ailGvRYQad6kf68tkl3z/MjuXLz2XRZaaBKhmrKSDsaqivAAN
         7ibiQoU+haVpImPabSkb8Z43hiDpcevdX63OwP6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/152] selftests/bpf: Test_progs indicate to shell on non-actions
Date:   Thu, 20 Aug 2020 11:20:54 +0200
Message-Id: <20200820091558.191183968@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

[ Upstream commit 6c92bd5cd4650c39dd929565ee172984c680fead ]

When a user selects a non-existing test the summary is printed with
indication 0 for all info types, and shell "success" (EXIT_SUCCESS) is
indicated. This can be understood by a human end-user, but for shell
scripting is it useful to indicate a shell failure (EXIT_FAILURE).

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/159363984736.930467.17956007131403952343.stgit@firesoul
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 8cb3469dd11f2..a7d06724c18c2 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -584,5 +584,8 @@ int main(int argc, char **argv)
 	free(env.test_selector.num_set);
 	free(env.subtest_selector.num_set);
 
+	if (env.succ_cnt + env.fail_cnt + env.skip_cnt == 0)
+		return EXIT_FAILURE;
+
 	return env.fail_cnt ? EXIT_FAILURE : EXIT_SUCCESS;
 }
-- 
2.25.1



